require 'singleton'
require 'fileutils'
require 'shellwords'

module Specinfra
  module Backend
    class Exec < Base

      def run_command(cmd, opts={})
        cmd = build_command(cmd)
        cmd = add_pre_command(cmd)
        stdout = run_with_no_ruby_environment do
          `#{build_command(cmd)} 2>&1`
        end
        # In ruby 1.9, it is possible to use Open3.capture3, but not in 1.8
        # stdout, stderr, status = Open3.capture3(cmd)

        if @example
          @example.metadata[:command] = cmd
          @example.metadata[:stdout]  = stdout
        end

        CommandResult.new :stdout => stdout, :exit_status => $?.exitstatus
      end

      def run_with_no_ruby_environment
        keys = %w[BUNDLER_EDITOR BUNDLE_BIN_PATH BUNDLE_GEMFILE
          RUBYOPT GEM_HOME GEM_PATH GEM_CACHE]

        keys.each { |key| ENV["_SPECINFRA_#{key}"] = ENV[key] ; ENV.delete(key) }
        yield
      ensure
        keys.each { |key| ENV[key] = ENV.delete("_SPECINFRA_#{key}") }
      end

      def build_command(cmd)
        shell = Specinfra.configuration.shell || '/bin/sh'
        cmd = cmd.shelljoin if cmd.is_a?(Array)
        cmd = "#{shell.shellescape} -c #{cmd.shellescape}"

        path = Specinfra.configuration.path
        if path
          cmd = "env PATH=#{path.shellescape}:\"$PATH\" #{cmd}"
        end

        cmd
      end

      def add_pre_command(cmd)
        if Specinfra.configuration.pre_command
          pre_cmd = build_command(Specinfra.configuration.pre_command)
          "#{pre_cmd} && #{cmd}"
        else
          cmd
        end
      end

      def check_service_is_running(service)
        ret = run_command(commands.check_service_is_running(service))

        # In Ubuntu, some services are under upstart and "service foo status" returns
        # exit status 0 even though they are stopped.
        # So return false if stdout contains "stopped/waiting".
        return false if ret.stdout =~ /stopped\/waiting/

        # If the service is not registered, check by ps command
        if ret.exit_status == 1
          ret = run_command(commands.check_process_is_running(service))
        end

        ret.success?
      end

      def check_service_is_monitored_by_monit(process)
        ret = run_command(commands.check_service_is_monitored_by_monit(process))
        return false unless ret.stdout != nil && ret.success?

        retlines = ret.stdout.split(/[\r\n]+/).map(&:strip)
        proc_index = retlines.index("Process '#{process}'")
        return false unless proc_index

        retlines[proc_index+2].match(/\Amonitoring status\s+monitored\Z/i) != nil
      end

      def check_file_is_readable(file, by_whom)
        mode = sprintf('%04s',run_command(commands.get_file_mode(file)).stdout.strip)
        mode = mode.split('')
        mode_octal = mode[0].to_i * 512 + mode[1].to_i * 64 + mode[2].to_i * 8 + mode[3].to_i * 1
        case by_whom
        when nil
          mode_octal & 0444 != 0
        when 'owner'
          mode_octal & 0400 != 0
        when 'group'
          mode_octal & 0040 != 0
        when 'others'
          mode_octal & 0004 != 0
        end
      end

      def check_file_is_writable(file, by_whom)
        mode = sprintf('%04s',run_command(commands.get_file_mode(file)).stdout.strip)
        mode = mode.split('')
        mode_octal = mode[0].to_i * 512 + mode[1].to_i * 64 + mode[2].to_i * 8 + mode[3].to_i * 1
        case by_whom
        when nil
          mode_octal & 0222 != 0
        when 'owner'
          mode_octal & 0200 != 0
        when 'group'
          mode_octal & 0020 != 0
        when 'others'
          mode_octal & 0002 != 0
        end
      end

      def check_file_is_executable(file, by_whom)
        mode = sprintf('%04s',run_command(commands.get_file_mode(file)).stdout.strip)
        mode = mode.split('')
        mode_octal = mode[0].to_i * 512 + mode[1].to_i * 64 + mode[2].to_i * 8 + mode[3].to_i * 1
        case by_whom
        when nil
          mode_octal & 0111 != 0
        when 'owner'
          mode_octal & 0100 != 0
        when 'group'
          mode_octal & 0010 != 0
        when 'others'
          mode_octal & 0001 != 0
        end
      end

      def check_file_is_mounted(path, expected_attr, only_with)
        ret = run_command(commands.check_file_is_mounted(path))
        if expected_attr.nil? || ret.failure?
          return ret.success?
        end

        mount = ret.stdout.scan(/\S+/)
        actual_attr    = { :device => mount[0], :type => mount[4] }
        mount[5].gsub(/\(|\)/, '').split(',').each do |option|
          name, val = option.split('=')
          if val.nil?
            actual_attr[name.to_sym] = true
          else
            val = val.to_i if val.match(/^\d+$/)
            actual_attr[name.to_sym] = val
          end
        end

        if ! expected_attr[:options].nil?
          expected_attr.merge!(expected_attr[:options])
          expected_attr.delete(:options)
        end

        if only_with
          actual_attr == expected_attr
        else
          expected_attr.each do |key, val|
            return false if actual_attr[key] != val
          end
          true
        end
      end

      def check_routing_table_has_entry(expected_attr)
        return false if ! expected_attr[:destination]
        ret = run_command(commands.check_routing_table_has_entry(expected_attr[:destination]))
        return false if ret.failure?

        ret.stdout.gsub!(/\r\n/, "\n")

        ret.stdout =~ /^(\S+)(?: via (\S+))? dev (\S+).+\n(?:default via (\S+))?/
        actual_attr = {
          :destination => $1,
          :gateway     => $2 ? $2 : $4,
          :interface   => expected_attr[:interface] ? $3 : nil
        }

        expected_attr.each do |key, val|
          return false if actual_attr[key] != val
        end
        true
      end

      def copy_file(from, to)
        begin
          FileUtils.cp(from, to)
        rescue => e
          return false
        end
        true
      end
    end
  end
end

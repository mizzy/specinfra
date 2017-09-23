module Specinfra
  class Processor
    def self.check_service_is_running(service)
      cmd = Specinfra.command.get(:check_service_is_running, service)
      ret = Specinfra.backend.run_command(cmd)

      # In Ubuntu, some services are under upstart and "service foo status" returns
      # exit status 0 even though they are stopped.
      # So return false if stdout contains "stopped/waiting" or "stop/waiting".
      return false if ret.stdout =~ /stop(ped)?\/waiting/

      # If the service is not registered, check by ps command
      if ret.exit_status == 1
        cmd = Specinfra.command.get(:check_process_is_running, service)
        ret = Specinfra.backend.run_command(cmd)
      end

      ret.success?
    end

    def self.check_service_is_monitored_by_monit(process)
      cmd = Specinfra.command.get(:check_service_is_monitored_by_monit, process)
      ret = Specinfra.backend.run_command(cmd)
      return false unless ret.stdout != nil && ret.success?

      retlines = ret.stdout.split(/[\r\n]+/).map(&:strip)
      proc_index = retlines.index("Process '#{process}'")
      return false unless proc_index

      retlines[proc_index+2].match(/\Amonitoring status\s+monitored\Z/i) != nil
    end

    def self.check_file_is_readable(file, by_whom)
      cmd = Specinfra.command.get(:get_file_mode, file)
      mode = sprintf('%04s',Specinfra.backend.run_command(cmd).stdout.strip)
      mode = mode.split('')
      mode_octal = mode[0].to_i * 512 + mode[1].to_i * 64 + mode[2].to_i * 8 + mode[3].to_i * 1
      case by_whom.to_s
      when ''
        mode_octal & 0444 != 0
      when 'owner'
        mode_octal & 0400 != 0
      when 'group'
        mode_octal & 0040 != 0
      when 'others'
        mode_octal & 0004 != 0
      end
    end

    def self.check_file_is_writable(file, by_whom)
      cmd = Specinfra.command.get(:get_file_mode, file)
      mode = sprintf('%04s',Specinfra.backend.run_command(cmd).stdout.strip)
      mode = mode.split('')
      mode_octal = mode[0].to_i * 512 + mode[1].to_i * 64 + mode[2].to_i * 8 + mode[3].to_i * 1
      case by_whom.to_s
      when ''
        mode_octal & 0222 != 0
      when 'owner'
        mode_octal & 0200 != 0
      when 'group'
        mode_octal & 0020 != 0
      when 'others'
        mode_octal & 0002 != 0
      end
    end

    def self.check_file_is_executable(file, by_whom)
      cmd  = Specinfra.command.get(:get_file_mode, file)
      mode = sprintf('%04s',Specinfra.backend.run_command(cmd).stdout.strip)
      mode = mode.split('')
      mode_octal = mode[0].to_i * 512 + mode[1].to_i * 64 + mode[2].to_i * 8 + mode[3].to_i * 1
      case by_whom.to_s
      when ''
        mode_octal & 0111 != 0
      when 'owner'
        mode_octal & 0100 != 0
      when 'group'
        mode_octal & 0010 != 0
      when 'others'
        mode_octal & 0001 != 0
      end
    end

    def self.check_file_is_mounted(path, expected_attr, only_with)
      cmd = Specinfra.command.get(:check_file_is_mounted, path)
      ret = Specinfra.backend.run_command(cmd)
      if expected_attr.nil? || ret.failure?
        return ret.success?
      end

      mount = ret.stdout.scan(/\S+/)
      actual_attr = { }
      actual_attr[:device] = mount[0]
      # Output of mount depends on os:
      # a)  proc on /proc type proc (rw,noexec,nosuid,nodev)
      # b)  procfs on /proc (procfs, local)
      actual_attr[:type] = mount[4] if mount[3] == 'type' # case a.
      if match = ret.stdout.match(/\((.*)\)/)
        options = match[1].split(',')
        actual_attr[:type] ||= options.shift              # case b.
        options.each do |option|
          name, val = option.split('=')
          if val.nil?
            actual_attr[name.strip.to_sym] = true
          else
            val = val.to_i if val.match(/^\d+$/)
            actual_attr[name.strip.to_sym] = val
          end
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

    def self.check_fstab_has_entry(expected_attr)
      return false unless expected_attr[:mount_point]
      cmd = Specinfra.command.get(:get_fstab_entry, expected_attr[:mount_point])
      ret = Specinfra.backend.run_command(cmd)
      return false if ret.failure?

      fstab = ret.stdout.scan(/\S+/)
      actual_attr = {
        :device      => fstab[0],
        :mount_point => fstab[1],
        :type        => fstab[2],
        :dump        => fstab[4].to_i,
        :pass        => fstab[5].to_i
      }
      fstab[3].split(',').each do |option|
        name, val = option.split('=')
        if val.nil?
          actual_attr[name.to_sym] = true
        else
          val = val.to_i if val.match(/^\d+$/)
          actual_attr[name.to_sym] = val
        end
      end

      unless expected_attr[:options].nil?
        expected_attr.merge!(expected_attr[:options])
        expected_attr.delete(:options)
      end

      expected_attr.each do |key, val|
        return false if actual_attr[key] != val
      end
      true
    end

    def self.check_routing_table_has_entry(expected_attr)
      return false if ! expected_attr[:destination]
      cmd = Specinfra.command.get(:get_routing_table_entry, expected_attr[:destination])
      ret = Specinfra.backend.run_command(cmd)
      return false if ret.failure?

      ret.stdout.gsub!(/\r\n/, "\n")

      if os[:family] == 'openbsd'
        match = ret.stdout.match(/^(\S+)\s+(\S+).*?(\S+[0-9]+)(\s*)$/)
        actual_attr = {
          :destination => $1,
          :gateway     => $2,
          :interface   => expected_attr[:interface] ? $3 : nil
        }
      else
        matches = ret.stdout.scan(/^(\S+)(?: via (\S+))? dev (\S+).+\n|^(\S+).*\n|\s+nexthop via (\S+)\s+dev (\S+).+/)
        if matches.length > 1
          # ECMP route
          destination = nil
          matches.each do |groups|
            if groups[3]
              destination = groups[3]
              next
            end
            next if expected_attr[:gateway] && expected_attr[:gateway] != groups[4]
            next if expected_attr[:interface] && expected_attr[:interface] != groups[5]

            actual_attr = {
              :destination => destination,
              :gateway => groups[4],
              :interface => groups[5]
            }
          end
        elsif matches.length == 1
          # Non-ECMP route
          groups = matches[0]
          actual_attr = {
            :destination => groups[0],
            :gateway     => groups[1] ? groups[1] : groups[3],
            :interface   => expected_attr[:interface] ? groups[2] : nil
          }
        end

      end

      expected_attr.each do |key, val|
        return false if actual_attr[key] != val
      end
      true
    end

    def self.get_default_gateway(attr)
      cmd = Specinfra.command.get(:get_routing_table_entry, 'default')
      ret = Specinfra.backend.run_command(cmd)
      return false if ret.failure?

      ret.stdout.gsub!(/\r\n/, "\n")

      if os[:family] == 'openbsd'
        match = ret.stdout.match(/^(\S+)\s+(\S+).*?(\S+[0-9]+)(\s*)$/)
        if attr == :gateway
          $2
        elsif attr == :interface
          $3
        end
      else
        ret.stdout =~ /^(\S+)(?: via (\S+))? dev (\S+).+\n(?:default via (\S+))?/
        if attr == :gateway
          $2 ? $2 : $4
        elsif attr == :interface
          $3
        end
      end
    end
  end
end

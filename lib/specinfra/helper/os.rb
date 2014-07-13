module Specinfra
  module Helper
    module OS
      def commands
        Specinfra::Command::Base.new
      end

      def os
        property[:os_by_host] = {} if ! property[:os_by_host]
        host_port = current_host_and_port

        if property[:os_by_host][host_port]
          os_by_host = property[:os_by_host][host_port]
        else
          # Set command object explicitly to avoid `stack too deep`
          os_by_host = detect_os
          property[:os_by_host][host_port] = os_by_host
        end
        os_by_host
      end

      private

      # put this in a module for better reuse
      def current_host_and_port
        if Specinfra.configuration.ssh
          [Specinfra.configuration.ssh.host, Specinfra.configuration.ssh.options[:port]]
        else
          ['localhost', nil]
        end
      end

      def run_command(cmd)
        backend.run_command(cmd)
      end

      def detect_os
        return Specinfra.configuration.os if Specinfra.configuration.os
        arch = run_command('uname -m').stdout.strip
        # Fedora also has an /etc/redhat-release so the Fedora check must
        # come before the RedHat check
        if run_command('ls /etc/fedora-release').success?
          line = run_command('cat /etc/redhat-release').stdout
          if line =~ /release (\d[\d]*)/
            release = $1
          end
          { :family => 'fedora', :release => release }
        elsif run_command('ls /etc/redhat-release').success?
          line = run_command('cat /etc/redhat-release').stdout
          if line =~ /release (\d[\d.]*)/
            release = $1
          end

          { :family => 'redhat', :release => release, :arch => arch }
        elsif run_command('ls /etc/system-release').success?
          { :family => 'redhat', :release => nil, :arch => arch } # Amazon Linux
        elsif run_command('ls /etc/SuSE-release').success?
          line = run_command('cat /etc/SuSE-release').stdout
          if line =~ /SUSE Linux Enterprise Server (\d+)/
            release = $1
            family = 'SuSE'
          elsif line =~ /openSUSE (\d+\.\d+|\d+)/
            release = $1
            family = 'OpenSUSE'
          end
          { :family => family, :release => release, :arch => arch }
        elsif run_command('ls /etc/debian_version').success?
          lsb_release = run_command("lsb_release -ir")
          if lsb_release.success?
            if lsb_release.stdout =~ /:/
              distro = lsb_release.stdout.split("\n").first.split(':').last
              release = lsb_release.stdout.split("\n").last.split(':').last.strip
            end
          else
            lsb_release = run_command("cat /etc/lsb-release")
            if lsb_release.success?
              lsb_release.stdout.each_line do |line|
                distro = line.split('=').last if line =~ /^DISTRIB_ID=/
                release = line.split('=').last.strip if line =~ /^DISTRIB_RELEASE=/
              end
            end
          end
          distro ||= 'Debian'
          release ||= nil
          { :family => distro.strip, :release => release, :arch => arch }
        elsif run_command('ls /etc/gentoo-release').success?
          { :family => 'Gentoo', :release => nil, :arch => arch }
        elsif run_command('ls /usr/lib/setup/Plamo-*').success?
          { :family => 'Plamo', :release => nil, :arch => arch }
        elsif run_command('ls /var/run/current-system/sw').success?
          { :family => 'NixOS', :release => nil, :arch => arch }
        elsif run_command('uname -s').stdout =~ /AIX/i
          { :family => 'AIX', :release => nil, :arch => arch }
        elsif ( uname = run_command('uname -sr').stdout) && uname =~ /SunOS/i
          if uname =~ /5.10/
            { :family => 'Solaris10', :release => nil, :arch => arch }
          elsif run_command('grep -q "Oracle Solaris 11" /etc/release').success?
            { :family => 'Solaris11', :release => nil, :arch => arch }
          elsif run_command('grep -q SmartOS /etc/release').success?
            { :family => 'SmartOS', :release => nil, :arch => arch }
          else
            { :family => 'Solaris', :release => nil, :arch => arch }
          end
        elsif run_command('uname -s').stdout =~ /Darwin/i
          { :family => 'Darwin', :release => nil }
        elsif ( uname = run_command('uname -sr').stdout ) && uname =~ /FreeBSD/i
          if uname =~ /10./
            { :family => 'FreeBSD10', :release => nil, :arch => arch }
          else
            { :family => 'FreeBSD', :release => nil, :arch => arch }
          end
        elsif run_command('uname -sr').stdout =~ /Arch/i
          { :family => 'Arch', :release => nil, :arch => arch }
        elsif run_command('uname -s').stdout =~ /OpenBSD/i
          { :family => 'OpenBSD', :release => nil, :arch => arch }
        else
          { :family => 'Base', :release => nil, :arch => arch }
        end
      end
    end
  end
end

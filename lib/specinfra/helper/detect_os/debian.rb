class Specinfra::Helper::DetectOs::Debian < Specinfra::Helper::DetectOs
  def detect
    if (debian_version = run_command('cat /etc/debian_version')) && debian_version.success?
      distro   = nil
      release  = nil
      codename = nil
      if (lsb_release = run_command("lsb_release -irc")) && lsb_release.success?
        lsb_release.stdout.each_line do |line|
          distro   = line.split(':').last.strip if line =~ /^Distributor ID:/
          release  = line.split(':').last.strip if line =~ /^Release:/
          codename = line.split(':').last.strip if line =~ /^Codename:/
        end
      elsif (lsb_release = run_command("cat /etc/lsb-release")) && lsb_release.success?
        lsb_release.stdout.each_line do |line|
          distro   = line.split('=').last.strip if line =~ /^DISTRIB_ID=/
          release  = line.split('=').last.strip if line =~ /^DISTRIB_RELEASE=/
          codename = line.split('=').last.strip if line =~ /^DISTRIB_CODENAME=/
        end
      elsif (lsb_release = run_command("cat /etc/os-release")) && lsb_release.success?
        lsb_release.stdout.each_line do |line|
          distro   = line.split('=').last.delete('"').strip if line =~ /^ID=/
          release  = line.split('=').last.delete('"').strip if line =~ /^VERSION_ID=/
          codename = line.split('=').last.delete('"').strip if line =~ /^VERSION_CODENAME=/
        end
        # There is no codename notation until Debian Jessie
        if codename.nil?
          lsb_release.stdout.each_line do |line|
            version = line.split('=').last.delete('"').strip if line =~ /^VERSION=/
            # For debian releases
            if m = /^[0-9]+ \((\w+)\)$/.match(version)
              codename = m[1]
            end
          end
        end
      end
      distro ||= 'debian'
      # lsb-release not available or reported no version number:
      if release.nil? || release == 'n/a'
        release = case debian_version.stdout.chomp
                  when /^[[:digit:]]+\.[[:digit:]]+$/
                    debian_version.stdout.chomp
                  when %r{^\w+/sid$}
                    # a number larger than any normal Debian version ever:
                    2**32 - 1.0
                  else
                    nil
                  end
      end
      { :family => distro.gsub(/[^[:alnum:]]/, '').downcase, :release => release, :codename => codename }
    end
  end
end

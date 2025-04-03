class Specinfra::Helper::DetectOs::Debian < Specinfra::Helper::DetectOs
  def detect
    if (debian_version = run_command('cat /etc/debian_version')) && debian_version.success?
      distro  = nil
      release = nil
      if (lsb_release = run_command("lsb_release -ir")) && lsb_release.success?
        lsb_release.stdout.each_line do |line|
          distro  = line.split(':').last.strip if line =~ /^Distributor ID:/
          release = line.split(':').last.strip if line =~ /^Release:/
        end
      elsif (lsb_release = run_command("cat /etc/lsb-release")) && lsb_release.success?
        lsb_release.stdout.each_line do |line|
          distro  = line.split('=').last.strip if line =~ /^DISTRIB_ID=/
          release = line.split('=').last.strip if line =~ /^DISTRIB_RELEASE=/
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
      { :family => distro.gsub(/[^[:alnum:]]/, '').downcase, :release => release }
    end
  end
end

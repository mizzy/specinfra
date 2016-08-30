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
      else
        if debian_version.stdout.chomp =~ /^[[:digit:]]+\.[[:digit:]]+$/
          release = debian_version.stdout.chomp
        end
      end
      distro ||= 'debian'
      release ||= nil
      { :family => distro.gsub(/[^[:alnum:]]/, '').downcase, :release => release }
    end
  end
end

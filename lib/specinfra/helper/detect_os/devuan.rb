class Specinfra::Helper::DetectOs::Devuan < Specinfra::Helper::DetectOs
  def detect
    if (devuan_version = run_command('cat /etc/devuan_version')) && devuan_version.success?
      distro  = nil
      release = nil
      if (lsb_release = run_command("lsb_release -ir")) && lsb_release.success?
        lsb_release.stdout.each_line do |line|
          distro  = line.split(':').last.strip if line =~ /^Distributor ID:/
          release = line.split(':').last.strip if line =~ /^Release:/
        end
      else
        if devuan_version.stdout.chomp =~ /^[[:digit:]]+\.[[:digit:]]+$/
          release = devuan_version.stdout.chomp
        end
      end
      distro ||= 'devuan'
      release ||= nil
      { :family => distro.gsub(/[^[:alnum:]]/, '').downcase, :release => release }
    end
  end
end

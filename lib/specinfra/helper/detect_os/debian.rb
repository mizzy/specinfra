class Specinfra::Helper::DetectOs::Debian < Specinfra::Helper::DetectOs
  def self.detect
    if run_command('ls /etc/debian_version').success?
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
      distro ||= 'debian'
      release ||= nil
      { :family => distro.strip.downcase, :release => release }
    end
  end
end

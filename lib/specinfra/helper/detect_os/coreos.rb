class Specinfra::Helper::DetectOs::Coreos < Specinfra::Helper::DetectOs
  def detect
    if run_command('ls /etc/coreos/update.conf').success?
      distro  = nil
      release = nil
      lsb_release = run_command("cat /etc/lsb-release")
      if lsb_release.success?
        lsb_release.stdout.each_line do |line|
          distro  = 'coreos' if line.include? "CoreOS"
          release = line.split('=').last.strip if line =~ /^DISTRIB_RELEASE=/
        end
      end
      distro ||= 'coreos'
      release ||= nil
      { :family => distro.gsub(/[^[:alnum:]]/, '').downcase, :release => release }
    end
  end
end

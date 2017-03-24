class Specinfra::Helper::DetectOs::Suse < Specinfra::Helper::DetectOs
  def detect
    if run_command('ls /etc/os-release').success? and run_command('ls /etc/SuSe-release').success?
      line = run_command('cat /etc/os-release').stdout
      if line =~ /NAME=\"OpenSUSE"/
        family = 'opensuse'
      elsif line =~ /NAME=\"SLES"/
        family = 'sles'
      elsif line =~ /openSUSE (\d+\.\d+|\d+)/
        release = $1
        family = 'opensuse'
      end
      { :family => family, :release => release }
    end
  end
end

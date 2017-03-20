class Specinfra::Helper::DetectOs::Suse < Specinfra::Helper::DetectOs
  def detect
    if run_command('ls /etc/os-release').success?
      line = run_command('cat /etc/os-release').stdout
      if line =~ /NAME=\"OpenSUSE"/
        family = 'opensuse'
      elsif line =~ /NAME=\"SLES"/
        family = 'sles'
      end
      if line =~ /VERSION_ID=\"(\d+\.\d+|\d+)\"/
        release = $1
      end
      { :family => family, :release => release }
    end
  end
end

class Specinfra::Helper::DetectOs::Suse < Specinfra::Helper::DetectOs
  def detect
    if run_command('ls /etc/os-release').success? and run_command('zypper -V').success?
      line = run_command('cat /etc/os-release').stdout
      if line =~ /ID=opensuse/
        family = 'opensuse'
      elsif line =~ /NAME=\"SLES"/
        family = 'sles'
      end
      if line =~ /VERSION_ID=\"(\d+\.\d+|\d+)\"/
        release = $1
      end
      { :family => family, :release => release }
    elsif run_command('ls /etc/SuSE-release').success? and run_command('zypper -V').success?
      line = run_command('cat /etc/SuSE-release').stdout
      if line =~ /SUSE Linux Enterprise Server (\d+)/
        release = $1
        family = 'suse'
      elsif line =~ /openSUSE (\d+\.\d+|\d+)/
        release = $1
        family = 'opensuse'
      end
      { :family => family, :release => release }
    end
  end
end

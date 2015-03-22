class Specinfra::Helper::DetectOs::Suse < Specinfra::Helper::DetectOs
  def detect
    if run_command('ls /etc/SuSE-release').success?
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

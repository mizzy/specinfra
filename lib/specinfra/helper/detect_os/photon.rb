class Specinfra::Helper::DetectOs::Photon < Specinfra::Helper::DetectOs
  def detect
    if run_command('ls /etc/os-release').success?
      line = run_command('cat /etc/os-release').stdout
      if line =~ /ID=photon/
        family = 'photon'
        if line =~ /VERSION_ID=(\d+\.\d+|\d+)/
          release = $1
        end
        { :family => family, :release => release }
      end
    end
  end
end

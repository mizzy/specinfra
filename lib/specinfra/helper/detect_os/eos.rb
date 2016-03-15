class Specinfra::Helper::DetectOs::Redhat < Specinfra::Helper::DetectOs
  def detect
    # Arista Networks EOS
    if run_command('ls /etc/Eos-release').success?
      line = run_command('cat /etc/Eos-release').stdout
      if line =~ /release (\d[\d.]*[A-Z]*)/
        release = $1
      end
      { :family => 'eos', :release => release }
    end
  end
end






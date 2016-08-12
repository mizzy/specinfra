class Specinfra::Helper::DetectOs::Eos < Specinfra::Helper::DetectOs
  def detect
    # Arista Networks EOS
    if run_command('ls /etc/Eos-release').success?
      line = run_command('cat /etc/Eos-release').stdout
      if line =~ /EOS (\d[\d.]*[A-Z]*)/
        release = $1
      end
      { :family => 'eos', :release => release }
    end
  end
end

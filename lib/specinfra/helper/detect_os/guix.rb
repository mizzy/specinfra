class Specinfra::Helper::DetectOs::Guix < Specinfra::Helper::DetectOs
  def detect
    if run_command('ls /etc/os-release').success?
      line = run_command('cat /etc/os-release').stdout
      if line =~ /ID=guix/
        { :family => 'guix', :release => nil }
      end
    end
  end
end

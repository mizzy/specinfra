class Specinfra::Helper::DetectOs::Voidlinux < Specinfra::Helper::DetectOs
  def detect
    if run_command("ls /etc/os-release").success?
      line = run_command("cat /etc/os-release").stdout

      if line =~ /^ID="void"/
        { :family => 'voidlinux', :release => nil }
      end
    end
  end
end

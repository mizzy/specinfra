class Specinfra::Helper::DetectOs::Arch < Specinfra::Helper::DetectOs
  def detect
    if run_command('ls /etc/arch-release').success?
      { :family => 'arch', :release => nil }
    end
  end
end

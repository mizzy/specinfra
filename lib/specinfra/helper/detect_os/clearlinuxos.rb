class Specinfra::Helper::DetectOs::Clearlinuxos < Specinfra::Helper::DetectOs
  def detect
    if run_command('/usr/bin/swupd').success?
      { :family => 'nixos', :release => nil }
    end
  end
end

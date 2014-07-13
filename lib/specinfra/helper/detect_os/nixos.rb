class Specinfra::Helper::DetectOs::Nixos < Specinfra::Helper::DetectOs
  def self.detect
    if run_command('ls /var/run/current-system/sw').success?
      { :family => 'nixos', :release => nil }
    end
  end
end

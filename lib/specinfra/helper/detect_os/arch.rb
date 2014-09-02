class Specinfra::Helper::DetectOs::Arch < Specinfra::Helper::DetectOs
  def self.detect
    if File.exist?('/etc/arch-release')
      { :family => 'arch', :release => nil }
    end
  end
end

class Specinfra::Helper::DetectOs::Arch < Specinfra::Helper::DetectOs
  def self.detect
    if run_command('uname -sr').stdout =~ /Arch/i
      { :family => 'arch', :release => nil }
    end
  end
end

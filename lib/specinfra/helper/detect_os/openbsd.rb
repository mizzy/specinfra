class Specinfra::Helper::DetectOs::Openbsd < Specinfra::Helper::DetectOs
  def self.detect
    if run_command('uname -s').stdout =~ /OpenBSD/i
      { :family => 'OpenBSD', :release => nil }
    end
  end
end

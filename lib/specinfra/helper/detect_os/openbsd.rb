class Specinfra::Helper::DetectOs::Openbsd < Specinfra::Helper::DetectOs
  def detect
    if run_command('uname -s').stdout =~ /OpenBSD/i
      { :family => 'openbsd', :release => nil }
    end
  end
end

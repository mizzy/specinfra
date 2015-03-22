class Specinfra::Helper::DetectOs::Freebsd < Specinfra::Helper::DetectOs
  def detect
    if ( uname = run_command('uname -sr').stdout ) && uname =~ /FreeBSD/i
      if uname =~ /10./
        { :family => 'freebsd', :release => 10 }
      else
        { :family => 'freebsd', :release => nil }
      end
    end
  end
end

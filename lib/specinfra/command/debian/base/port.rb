class Specinfra::Command::Debian::Base::Port < Specinfra::Command::Linux::Base::Port
  class << self
    def create(os_info=nil)
      if (os_info || os)[:release].to_i < 8
        self
      else
        Specinfra::Command::Debian::V8::Port
      end
    end
  end
end

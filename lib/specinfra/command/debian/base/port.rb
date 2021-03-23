class Specinfra::Command::Debian::Base::Port < Specinfra::Command::Linux::Base::Port
  class << self
    def create(os_info=nil)
      release = (os_info || os)[:release]
      if ["testing", "unstable"].include?(release) || release.to_i >= 8
        Specinfra::Command::Debian::V8::Port
      else
        self
      end
    end
  end
end

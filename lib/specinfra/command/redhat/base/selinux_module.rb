class Specinfra::Command::Redhat::Base::SelinuxModule < Specinfra::Command::Linux::Base::SelinuxModule
  class << self
    def create(os_info=nil)
      if (os_info || os)[:release].to_i < 8
        self
      else
        Specinfra::Command::Redhat::V8::SelinuxModule
      end
    end
  end
end

class Specinfra::Command::Redhat::Base::Port < Specinfra::Command::Base::Port
  class << self
    def create(os_info=nil)
      if (os_info || os)[:release].to_i < 7
        self
      else
        Specinfra::Command::Redhat::V7::Port
      end
    end
  end
end

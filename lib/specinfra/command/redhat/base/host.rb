class Specinfra::Command::Redhat::Base::Host < Specinfra::Command::Base::Host
  class << self
    def create(os_info=nil)
      if (os_info || os)[:release].to_i < 7
        self
      else
        Specinfra::Command::Redhat::V7::Host
      end
    end
  end
end

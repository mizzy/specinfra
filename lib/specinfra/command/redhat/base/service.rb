class Specinfra::Command::Redhat::Base::Service < Specinfra::Command::Linux::Base::Service
  class << self
    def create(os_info=nil)
      if (os_info || os)[:release].to_i < 7
        self
      else
        Specinfra::Command::Redhat::V7::Service
      end
    end
  end
end

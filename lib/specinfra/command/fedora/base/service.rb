class Specinfra::Command::Fedora::Base::Service < Specinfra::Command::Redhat::Base::Service
  class << self
    def create(os_info=nil)
      if (os_info || os)[:release].to_i < 15
        self
      else
        Specinfra::Command::Fedora::V15::Service
      end
    end
  end
end

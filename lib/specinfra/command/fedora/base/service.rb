class Specinfra::Command::Fedora::Base::Service < Specinfra::Command::Redhat::Base::Service
  class << self
    def create
      if os[:release].to_i < 15
        self
      else
        Specinfra::Command::Fedora::V15::Service
      end
    end
  end
end

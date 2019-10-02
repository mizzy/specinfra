class Specinfra::Command::Redhat::Base::Service < Specinfra::Command::Linux::Base::Service
  class << self
    def create(os_info=nil)
      release = (os_info || os)[:release].to_i
      # Dirty hack for Amazon Linux
      if release < 7 || release > 2000
        self
      else
        Specinfra::Command::Redhat::V7::Service
      end
    end
  end
end

class Specinfra::Command::Sles::Base::Service < Specinfra::Command::Suse::Base::Service
  class << self
    def create(os_info=nil)
      if (os_info || os)[:release].to_i < 12
        self
      else
        Specinfra::Command::Sles::V12::Service
      end
    end
  end
end

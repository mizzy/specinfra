class Specinfra::Command::Ubuntu::Base::Port < Specinfra::Command::Linux::Base::Port
  class << self
    def create(os_info=nil)
      if (os_info || os)[:release].to_i < 18
        self
      else
        Specinfra::Command::Ubuntu::V18::Port
      end
    end
  end
end

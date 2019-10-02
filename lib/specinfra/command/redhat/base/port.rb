class Specinfra::Command::Redhat::Base::Port < Specinfra::Command::Base::Port
  class << self
    def create(os_info=nil)
      release = (os_info || os)[:release].to_i
      # Dirty hack for Amazon Linux
      if release < 7 || release > 2000
        self
      else
        Specinfra::Command::Redhat::V7::Port
      end
    end
  end
end

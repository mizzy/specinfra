class Specinfra::Command::Freebsd::Base::User < Specinfra::Command::Base::User
  class << self
    def create(os_info=nil)
      if (os_info || os)[:release].to_i < 7
        Specinfra::Command::Freebsd::V6::User
      else
        self
      end
    end

    def get_minimum_days_between_password_change(user)
      "0"
    end

    def get_maximum_days_between_password_change(user)
      "pw usershow -n #{escape(user)} | cut -d':' -f 6"
    end

  end
end

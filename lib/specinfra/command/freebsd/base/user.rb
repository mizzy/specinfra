class Specinfra::Command::Freebsd::Base::User < Specinfra::Command::Base::User
  class << self

    def get_minimum_days_between_password_change(user)
      "0"
    end

    def get_maximum_days_between_password_change(user)
      "pw usershow -n #{escape(user)} | cut -d':' -f 6"
    end

  end
end

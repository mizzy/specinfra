class Specinfra::Command::Sles::V11::User < Specinfra::Command::Sles::Base::User
  class << self
    def get_minimum_days_between_password_change(user)
      "chage -l #{escape(user)} | sed -n 's/^Minimum://p' | sed 's|^[[:blank:]]*||g'"
    end

    def get_maximum_days_between_password_change(user)
      "chage -l #{escape(user)} | sed -n 's/^Maximum://p' | sed 's|^[[:blank:]]*||g'"
    end
  end
end
class Specinfra::Command::Solaris::V11::User < Specinfra::Command::Solaris::Base::User
  class << self
    def get_minimum_days_between_password_change(user)
      "passwd -s #{escape(user)} | sed 's/ \\{1,\\}/%/g' | tr '%' '\n' | sed '4q;d'"
    end

    def get_maximum_days_between_password_change(user)
      "passwd -s #{escape(user)} | sed 's/ \\{1,\\}/%/g' | tr '%' '\n' | sed '5q;d'"
    end
  end
end

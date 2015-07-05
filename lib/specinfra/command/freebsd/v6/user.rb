class Specinfra::Command::Freebsd::V6::User < Specinfra::Command::Freebsd::Base::User
  class << self
    def check_has_home_directory(user, path_to_home)
      "pw user show #{escape(user)} | cut -f 9 -d ':' | grep -w -- #{escape(path_to_home)}"
    end

    def check_has_login_shell(user, path_to_shell)
      "pw user show #{escape(user)} | cut -f 10 -d ':' | grep -w -- #{escape(path_to_shell)}"
    end

    def get_home_directory(user)
      "pw user show #{escape(user)} | cut -f 9 -d ':'"
    end

    def get_login_shell(user)
      "pw user show #{escape(user)} | cut -f 10 -d ':'"
    end
  end
end

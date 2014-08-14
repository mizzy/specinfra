class Specinfra::Command::Openbsd::Base::User < Specinfra::Command::Base::User
  class << self
    def check_has_login_shell(user, path_to_shell)
      "getent passwd #{escape(user)} | cut -f 7 -d ':' | grep #{escape(path_to_shell)}"
    end

    def check_has_home_directory(user, path_to_home)
      "getent passwd #{escape(user)} | cut -f 6 -d ':' | grep #{escape(path_to_home)}"
    end
  end
end

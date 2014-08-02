class Specinfra::Command::Solaris::Base::User < Specinfra::Command::Base::User
  class << self
    def check_belongs_to_group(user, group)
      "id -Gn #{escape(user)} | grep -- #{escape(group)}"
    end

    def check_has_home_directory(user, path_to_home)
      "getent passwd #{escape(user)} | cut -f 6 -d ':' | grep -w -- #{escape(path_to_home)}"
    end

    def check_has_login_shell(user, path_to_shell)
      "getent passwd #{escape(user)} | cut -f 7 -d ':' | grep -w -- #{escape(path_to_shell)}"
    end
  end
end

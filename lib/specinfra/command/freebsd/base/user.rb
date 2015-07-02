class Specinfra::Command::Freebsd::Base::User < Specinfra::Command::Base::User
  class << self
    def create
      @passwd = '/etc/passwd'
      @masterpasswd = '/etc/master.passwd'
      if os[:release].to_i < 7
        self
      else
        Specinfra::Command::Base::User
      end
    end

    def check_has_home_directory(user, path_to_home)
      "grep  ^#{escape(user)}: #{@passwd} | cut -f 6 -d ':' | grep -w -- #{escape(path_to_home)}"
    end

    def check_has_login_shell(user, path_to_shell)
      "grep  ^#{escape(user)}: #{@passwd} | cut -f 7 -d ':' | grep -w -- #{escape(path_to_shell)}"
    end

    def get_home_directory(user)
      "grep  ^#{escape(user)}: #{@passwd} | awk -F: '{ print $6 }'"
    end

    def get_login_shell(user)
      "grep  ^#{escape(user)}: #{@passwd} | cut -f 7 -d ':'"
    end

    def get_encrypted_password(user)
      "grep  ^#{escape(user)}: #{masterpasswd}  | awk -F: '{ print $2 }'"
    end

  end
end

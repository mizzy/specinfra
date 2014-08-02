class Specinfra::Command::Aix::Base::User < Specinfra::Command::Base::User
  class << self
    def check_belongs_to_group(user, group)
      "lsuser -a groups #{escape(user)} | awk -F'=' '{print $2}'| sed -e 's/,/ /g' |grep -w  -- #{escape(group)}"
    end

    def check_has_login_shell(user, path_to_shell)
      "lsuser -a shell #{escape(user)} |awk -F'=' '{print $2}' | grep -w -- #{escape(path_to_shell)}"
    end

    def check_has_home_directory(user, path_to_home)
      "lsuser -a home #{escape(user)} | awk -F'=' '{print $2}' | grep -w -- #{escape(path_to_home)}"
    end
  end
end

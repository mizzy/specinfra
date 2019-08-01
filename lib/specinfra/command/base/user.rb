class Specinfra::Command::Base::User < Specinfra::Command::Base
  class << self
    def check_exists(user)
      "id #{escape(user)}"
    end

    def check_belongs_to_group(user, group)
      "id #{escape(user)} | sed 's/ context=.*//g' | cut -f 4 -d '=' | grep -- #{escape(group)}"
    end

    def check_belongs_to_primary_group(user, group)
      "id -gn #{escape(user)}| grep ^#{escape(group)}$"
    end

    def check_is_system_user(user)
      exists = "getent passwd #{escape(user)} > /dev/null 2>&1"
      uid = "getent passwd #{escape(user)} | cut -f 3 -d ':'"
      sys_uid_min = "awk 'BEGIN{sys_uid_min=101} {if($1~/^SYS_UID_MIN/){sys_uid_min=$2}} END{print sys_uid_min}' /etc/login.defs"
      sys_uid_max = "awk 'BEGIN{sys_uid_max=0;uid_min=1000} {if($1~/^SYS_UID_MAX/){sys_uid_max=$2}if($1~/^UID_MIN/){uid_min=$2}} END{if(sys_uid_max!=0){print sys_uid_max}else{print uid_min-1}}' /etc/login.defs"
      %Q|#{exists} && test "$(#{uid})" -ge "$(#{sys_uid_min})" && test "$(#{uid})" -le "$(#{sys_uid_max})"|
    end

    def check_has_uid(user, uid)
      regexp = "^uid=#{uid}("
      "id #{escape(user)} | grep -- #{escape(regexp)}"
    end

    def check_has_home_directory(user, path_to_home)
      "getent passwd #{escape(user)} | cut -f 6 -d ':' | grep -w -- #{escape(path_to_home)}"
    end

    def check_has_login_shell(user, path_to_shell)
      "getent passwd #{escape(user)} | cut -f 7 -d ':' | grep -w -- #{escape(path_to_shell)}"
    end

    def check_has_authorized_key(user, key)
      key.sub!(/\s+\S*$/, '') if key.match(/^\S+\s+\S+\s+\S*$/)
      "grep -w -- #{escape(key)} ~#{escape(user)}/.ssh/authorized_keys"
    end

    def get_minimum_days_between_password_change(user)
      "chage -l #{escape(user)} | sed -n 's/^Minimum.*: //p'"
    end

    def get_maximum_days_between_password_change(user)
      "chage -l #{escape(user)} | sed -n 's/^Maximum.*: //p'"
    end

    def get_uid(user)
      "id -u #{escape(user)}"
    end

    def get_gid(user)
      "id -g #{escape(user)}"
    end

    def get_home_directory(user)
      "getent passwd #{escape(user)} | cut -f 6 -d ':'"
    end

    def get_login_shell(user)
      "getent passwd #{escape(user)} | cut -f 7 -d ':'"
    end

    def update_home_directory(user, directory)
      "usermod -d #{escape(directory)} #{escape(user)}"
    end

    def update_login_shell(user, shell)
      "usermod -s #{escape(shell)} #{escape(user)}"
    end

    def update_uid(user, uid)
      "usermod -u #{escape(uid)} #{escape(user)}"
    end

    def update_gid(user, gid)
      "usermod -g #{escape(gid)} #{escape(user)}"
    end

    def add(user, options)
      command = ['useradd']
      command << '-g' << escape(options[:gid])            if options[:gid]
      command << '-d' << escape(options[:home_directory]) if options[:home_directory]
      command << '-p' << escape(options[:password])       if options[:password]
      command << '-s' << escape(options[:shell])          if options[:shell]
      command << '-m' if options[:create_home]
      command << '-r' if options[:system_user]
      command << '-u' << escape(options[:uid])            if options[:uid]
      command << escape(user)
      command.join(' ')
    end

    def update_encrypted_password(user, encrypted_password)
      %Q!echo #{escape("#{user}:#{encrypted_password}")} | chpasswd -e!
    end

    def get_encrypted_password(user)
      "getent shadow #{escape(user)} | cut -f 2 -d ':'"
    end
  end
end

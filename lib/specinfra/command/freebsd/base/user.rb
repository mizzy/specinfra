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
      'echo 0'
    end

    def get_maximum_days_between_password_change(user)
      "pw usershow -n #{escape(user)} | cut -d':' -f 6"
    end

    def update_home_directory(user, directory)
      "pw user mod #{escape(user)} -d #{escape(directory)}"
    end

    def update_login_shell(user, shell)
      "pw user mod #{escape(user)} -s #{escape(shell)}"
    end

    def update_uid(user, uid)
      "pw user mod #{escape(user)} -u #{escape(uid)}"
    end

    def update_gid(user, gid)
      "pw user mod #{escape(user)} -g #{escape(gid)}"
    end

    def add(user, options)
      command = ['pw', 'user', 'add', escape(user)]
      command << '-g' << escape(options[:gid])            if options[:gid]
      command << '-d' << escape(options[:home_directory]) if options[:home_directory]
      command << '-s' << escape(options[:shell])          if options[:shell]
      command << '-m' if options[:create_home]
      command << '-u' << escape(options[:uid])            if options[:uid]
      if options[:password]
        command.concat(['&&', 'chpass', '-p', "\'#{options[:password]}\'", escape(user)])
      end
      command.join(' ')
    end

    def update_encrypted_password(user, encrypted_password)
      "chpass -p \'#{encrypted_password}\' #{escape(user)}"
    end

    def get_encrypted_password(user)
      "getent passwd #{escape(user)} | awk -F: '{ print $2 }'"
    end
  end
end

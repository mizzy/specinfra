class Specinfra::Command::Darwin::Base::User < Specinfra::Command::Base::User
  class << self
    def check_has_home_directory(user, path_to_home)
      "#{get_home_directory(user)} | grep -E '^#{escape(path_to_home)}$'"
    end

    def check_has_login_shell(user, path_to_shell)
      "finger #{escape(user)} | grep -E '^Directory' | awk '{ print $4 }' | grep -E '^#{escape(path_to_shell)}$'"
    end

    def get_home_directory(user)
      "finger #{escape(user)} | grep -E '^Directory' | awk '{ print $2 }'"
    end

    def update_home_directory(user, directory)
      "dscl . -create /Users/#{escape(user)} NFSHomeDirectory #{escape(directory)}"
    end

    def update_login_shell(user, shell)
      "dscl . -create /Users/#{escape(user)} UserShell #{escape(shell)}"
    end

    def update_encrypted_password(user, password)
      "dscl . passwd /Users/#{escape(user)} #{escape(password)}"
    end

    def update_gid(user, gid)
      "dscl . -create /Users/#{escape(user)} PrimaryGroupID #{escape(gid)}"
    end

    def add(user, options)
      user_name = escape(user)
      record_path = "/Users/#{user_name}"
      dscl_create = "dscl . -create #{record_path}"

      command = [dscl_create]
      command << "#{dscl_create} UserShell #{escape(options[:shell])}"      if options[:shell]
      command << "#{dscl_create} UniqueID #{escape(options[:uid])}"         if options[:uid]
      command << "#{dscl_create} PrimaryGroupID #{escape(options[:gid])}"   if options[:gid]

      home_dir = if options[:home_directory]
                   escape(options[:home_directory])
                 else
                   record_path
                 end
      command << "#{dscl_create} NFSHomeDirectory #{home_dir}"

      command << "dscl . passwd #{record_path} #{escape(options[:password])}"  if options[:password]
      command << "createhomedir -b -u #{user_name}"                            if options[:create_home]
      command.join(' && ')
    end
  end
end

class Specinfra::Command::Aix::Base::File < Specinfra::Command::Base::File
  class << self
    def check_is_accessible_by_user(file, user, access)
      "su -s sh -c \"test -#{access} #{file}\" #{user}"
    end

    def check_has_mode(file, mode)
      "find #{file} -prune -perm #{mode} | grep ^#{file}$"
    end

    def check_is_owned_by(file, owner)
      regexp = "^#{owner}$"
      "ls -al #{escape(file)} | awk '{print $3}' | grep -- #{escape(regexp)}"
    end

    def check_is_grouped(file, group)
      regexp = "^#{group}$"
      "ls -al #{escape(file)} | awk '{print $4}' | grep -- #{escape(regexp)}"
    end
  end
end

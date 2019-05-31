class Specinfra::Command::Aix::Base::File < Specinfra::Command::Base::File
  class << self
    def check_is_accessible_by_user(file, user, access)
      "su -s sh -c \"test -#{access} #{file}\" #{user}"
    end

    def check_has_mode(file, mode)
      "find #{file} -prune -perm #{mode} | grep ^#{file}$"
    end

    def check_is_owned_by(file, owner)
      "istat #{escape(file)} | grep Owner | awk '{print $2}' | grep -- #{escape(owner)}"
    end

    def check_is_grouped(file, group)
      "istat #{escape(file)} | grep Owner | awk '{print $4}' | grep -- #{escape(group)}"
    end

    def check_is_mounted(path)
      "mount | grep -w -- '#{escape(path)}'"
    end

    def check_is_linked_to(link, target)
      "ls -ld #{escape(link)} | cut -d '>' -f 2 | grep -w -- #{escape(target)}"
    end
  end
end

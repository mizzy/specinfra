class Specinfra::Command::Freebsd::Base::File < Specinfra::Command::Base::File
  class << self
    def check_is_grouped(file, group)
      regexp = "^#{group}$"
      "stat -f%Sg #{escape(file)} | grep -- #{escape(regexp)}"
    end

    def get_owner_group(file)
      "stat -f%Sg #{escape(file)}"
    end

    def check_is_owned_by(file, owner)
      regexp = "^#{owner}$"
      "stat -f%Su #{escape(file)} | grep -- #{escape(regexp)}"
    end

    def get_owner_user(file)
      "stat -f%Su #{escape(file)}"
    end

    def check_has_mode(file, mode)
      "test `stat -f%Mp%Lp #{escape(file)} | sed 's/^0*//'` -eq #{escape(mode)}"
    end

    def get_mode(file)
      "stat -f%Mp%Lp #{escape(file)} | sed 's/^0*//'"
    end

    def check_is_linked_to(link, target)
      "stat -f%Y #{escape(link)} | grep -- #{escape(target)}"
    end

    def get_mtime(file)
      "stat -f%m #{escape(file)}"
    end

    def get_size(file)
      "stat -f%z #{escape(file)}"
    end

    def get_sha256sum(file)
        "sha256 #{escape(file)} | cut -d ' ' -f 4"
    end

    def get_md5sum(file)
        "md5 #{escape(file)} | cut -d ' ' -f 4"
    end
  end
end

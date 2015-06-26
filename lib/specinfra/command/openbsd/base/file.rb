class Specinfra::Command::Openbsd::Base::File < Specinfra::Command::Base::File
  class << self
    def get_md5sum(file)
      "cksum -qa md5 #{escape(file)} | cut -d ' ' -f 1"
    end

    def get_sha256sum(file)
      "cksum -qa sha256 #{escape(file)} | cut -d ' ' -f 1"
    end

    def check_is_linked_to(link, target)
      "stat -f %Y #{escape(link)} | grep -- #{escape(target)}"
    end

    def check_has_mode(file, mode)
      regexp = "^#{mode}$"
      "stat -f%Lp #{escape(file)} | grep #{escape(regexp)}"
    end

    def check_is_owned_by(file, owner)
      regexp = "^#{owner}$"
      "stat -f %Su #{escape(file)} | grep -- #{escape(regexp)}"
    end

    def check_is_grouped(file, group)
      regexp = "^#{group}$"
      "stat -f %Sg #{escape(file)} | grep -- #{escape(regexp)}"
    end

    def check_is_mounted(path)
      regexp = "on #{path} "
      "mount | grep #{escape(regexp)}"
    end

    def get_mode(file)
      "stat -f%Lp #{escape(file)}"
    end

    def get_mtime(file)
      "stat -f %m #{escape(file)}"
    end

    def get_size(file)
      "stat -f %z #{escape(file)}"
    end
  end
end

class Specinfra::Command::Darwin::Base::File < Specinfra::Command::Base::File
  def check_access_by_user(file, user, access)
    "sudo -u #{user} -s /bin/test -#{access} #{file}"
  end

  def check_has_md5checksum(file, expected)
    "openssl md5 #{escape(file)} | cut -d'=' -f2 | cut -c 2- | grep -E ^#{escape(expected)}$"
  end

  def check_has_sha256checksum(file, expected)
    "openssl sha256 #{escape(file)} | cut -d'=' -f2 | cut -c 2- | grep -E ^#{escape(expected)}$"
  end

  def check_is_linked_to(link, target)
    "stat -f %Y #{escape(link)} | grep -- #{escape(target)}"
  end

  def check_mode(file, mode)
    regexp = "^#{mode}$"
    "stat -f%Lp #{escape(file)} | grep -- #{escape(regexp)}"
  end

  def check_is_owned_by(file, owner)
    regexp = "^#{owner}$"
    "stat -f %Su #{escape(file)} | grep -- #{escape(regexp)}"
  end

  def check_is_grouped(file, group)
    regexp = "^#{group}$"
    "stat -f %Sg #{escape(file)} | grep -- #{escape(regexp)}"
  end

  def get_mode(file)
    "stat -f%Lp #{escape(file)}"
  end
end


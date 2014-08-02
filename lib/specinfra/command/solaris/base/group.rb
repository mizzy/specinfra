class Specinfra::Command::Solaris::Base::Group < Specinfra::Command::Base::Group
  class << self
    def check_has_gid(group, gid)
      regexp = "^#{group}:"
      "getent group | grep -- #{escape(regexp)} | cut -f 3 -d ':' | grep -w -- #{escape(gid)}"
    end
  end
end

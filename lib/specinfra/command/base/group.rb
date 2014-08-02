class Specinfra::Command::Base::Group < Specinfra::Command::Base
  class << self
    def check_exists(group)
      "getent group #{escape(group)}"
    end

    def check_has_gid(group, gid)
      regexp = "^#{group}"
      "getent group | grep -w -- #{escape(regexp)} | cut -f 3 -d ':' | grep -w -- #{escape(gid)}"
    end
  end
end

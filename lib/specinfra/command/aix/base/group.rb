class Specinfra::Command::Aix::Base::Group < Specinfra::Command::Base::Group
  class << self

    def check_exists(group)
      "lsgroup #{escape(group)}"
    end

    def check_has_gid(group, gid)
      "lsgroup -a id #{escape(group)} | cut -f 2 -d '=' | grep -w -- #{escape(gid)}"
    end

  end
end

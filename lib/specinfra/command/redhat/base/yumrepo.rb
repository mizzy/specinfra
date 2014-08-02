class Specinfra::Command::Redhat::Base::Yumrepo < Specinfra::Command::Linux::Base::Yumrepo
  class << self
    def check_exists(repository)
      "yum repolist all -C | grep ^#{escape(repository)}"
    end

    def check_is_enabled(repository)
      "yum repolist all -C | grep ^#{escape(repository)} | grep enabled"
    end
  end
end



class Specinfra::Command::Redhat::Base::Yumrepo < Specinfra::Command::Linux::Base::Yumrepo
  class << self
    def create(os_info=nil)
      if (os_info || os)[:release].to_i < 8
        self
      else
        Specinfra::Command::Redhat::V8::Yumrepo
      end
    end

    def check_exists(repository)
      "yum repolist all -C | grep -qsE \"^[\\!\\*]?#{escape(repository)}\(\\s\|$\|\\/)\""
    end

    def check_is_enabled(repository)
      "yum repolist enabled -C | grep -qs \"^[\\!\\*]\\?#{escape(repository)}\""
    end
  end
end



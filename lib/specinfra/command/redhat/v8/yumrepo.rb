class Specinfra::Command::Redhat::V8::Yumrepo < Specinfra::Command::Redhat::Base::Yumrepo
  class << self
    def check_exists(repository)
      "dnf repolist all | grep -qsE \"^[\\!\\*]?#{escape(repository)}\(\\s\|$\|\\/)\""
    end

    def check_is_enabled(repository)
      "dnf repolist enabled | grep -qs \"^[\\!\\*]\\?#{escape(repository)}\""
    end
  end
end

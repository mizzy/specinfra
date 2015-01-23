class Specinfra::Command::Freebsd::Base::Service < Specinfra::Command::Base::Service
  class << self
    def check_is_enabled(service, level=3)
      "service -e | grep -- #{escape(service)}"
    end

    def check_is_running_under_daemontools(service)
      "svstat /var/service/#{escape(service)} | grep -E 'up \\(pid [0-9]+\\)'"
    end
  end
end

class Specinfra::Command::Freebsd::V6::Service < Specinfra::Command::Base::Service
  class << self
    def check_is_enabled(service, level=3)
      "service -e | grep -- /#{escape(service)}$"
    end
  end
end

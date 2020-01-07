class Specinfra::Command::Redhat::V8::SelinuxModule < Specinfra::Command::Redhat::Base::SelinuxModule
  class << self
    def check_is_installed(name, version=nil)
      "semodule -l | grep $'^#{escape(name)}'"
    end

    def check_is_enabled(name)
      "semodule -l | grep $'^#{escape(name)}'"
    end
  end
end

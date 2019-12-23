class Specinfra::Command::Redhat::V8::SelinuxModule < Specinfra::Command::Linux::Base::SelinuxModule
  class << self
    def check_is_installed(name, version=nil)
      cmd =  "semodule -l | grep $'^#{escape(name)}'"
      cmd
    end

    def check_is_enabled(name)
      cmd =  "semodule -l | grep $'^#{escape(name)}'"
      cmd
    end
  end
end

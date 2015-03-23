class Specinfra::Command::Solaris::Base::Service < Specinfra::Command::Base::Service
  class << self
    def check_is_enabled(service, level=nil)
      "svcs -l #{escape(service)} 2> /dev/null | egrep '^enabled *true$'"
    end

    def check_is_running(service)
      "svcs -H -o state #{escape(service)} 2> /dev/null | egrep '^online$'"
    end

    def check_has_property(svc, property)
      commands = []
      property.sort.each do |key, value|
        regexp = "^#{value}$"
        commands << "svcprop -p #{escape(key)} #{escape(svc)} | grep -- #{escape(regexp)}"
      end
      commands.join(' && ')
    end

    def get_property(service)
      "svcprop -a #{escape(service)}"
    end
  end
end

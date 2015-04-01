class Specinfra::Command::Redhat::Base::Service < Specinfra::Command::Linux::Base::Service
  class << self
    # CentOS 5.x does not include /sbin in $PATH for non-root users.
    def chkconfig_path ()
      rh_rel_file = '/etc/redhat-release'
      "chkconfig" unless File.exists? rh_rel_file
      # Extra redundant File.exists? required otherwise spec tests fail.
      if File.exists? rh_rel_file and IO.read(rh_rel_file).chomp.match(/^CentOS release 5\./)
        "/sbin/chkconfig"
      else
        "chkconfig"
      end
    end

    def check_is_enabled(service, level=3)
      "#{chkconfig_path} --list #{escape(service)} | grep #{level}:on"
    end

    def enable(service)
      "#{chkconfig_path} #{escape(service)} on"
    end

    def disable(service)
      "#{chkconfig_path} #{escape(service)} off"
    end

    def start(service)
      "service #{escape(service)} start"
    end

    def stop(service)
      "service #{escape(service)} stop"
    end

    def restart(service)
      "service #{escape(service)} restart"
    end

    def reload(service)
      "service #{escape(service)} reload"
    end
  end
end








class Specinfra::Command::Openbsd::Base::Interface < Specinfra::Command::Base::Interface 
  class << self
    def check_exists(name)
      "ifconfig #{name}"
    end

    def get_speed_of(name)
      "ifconfig #{name} | grep 'media\:' | perl -pe 's|.*media\:.*\\((.*?)\\)|\\1|'"
    end

    def check_has_ipv4_address(interface, ip_address)
      "ifconfig #{interface} | grep -w inet | cut -d ' ' -f 2"
    end

    def check_has_ipv6_address(interface, ip_address)
      "ifconfig #{interface} | grep -w inet6 | cut -d ' ' -f 2"
    end
  end
end

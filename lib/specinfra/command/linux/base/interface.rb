class Specinfra::Command::Linux::Base::Interface < Specinfra::Command::Base::Interface
  class << self
    def check_exists(name)
      "ip link show #{name}"
    end

    def get_speed_of(name)
      "cat /sys/class/net/#{name}/speed"
    end

    def check_has_ipv4_address(interface, ip_address)
      ip_address = ip_address.dup
      if ip_address =~ /\/\d+$/
        ip_address << " "
      else
        ip_address << "/"
      end
      ip_address.gsub!(".", "\\.")
      "ip addr show #{interface} | grep 'inet #{ip_address}'"
    end

    def check_has_ipv6_address(interface, ip_address)
      ip_address = ip_address.dup
      if ip_address =~ /\/\d+$/
        ip_address << " "
      else
        ip_address << "/"
      end
      ip_address.downcase!
      "ip addr show #{interface} | grep 'inet6 #{ip_address}'"
    end
  end
end


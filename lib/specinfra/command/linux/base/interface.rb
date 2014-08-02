class Specinfra::Command::Linux::Base::Interface < Specinfra::Command::Base::Interface
  class << self
    def get_speed_of(name)
      "ethtool #{name} | grep Speed | gawk '{print gensub(/Speed: ([0-9]+)Mb\\\/s/,\"\\\\1\",\"\")}'"
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
  end
end


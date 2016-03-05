class Specinfra::Command::Openbsd::Base::Interface < Specinfra::Command::Base::Interface
  class << self
    def check_exists(name)
      "ifconfig #{name}"
    end

    def get_speed_of(name)
      "ifconfig #{name} | grep 'media\:' | perl -pe 's|.*media\:.*\\((.*?)\\)|\\1|'"
    end

    def check_has_ipv4_address(interface, ip_address)
      ip_address = ip_address.dup
      if ip_address =~ /\/\d+$/
        # remove the prefix - better would be to calculate the netmask
        ip_address.gsub!(/\/\d+$/, "")
      end
      ip_address << " "
      ip_address.gsub!(".", "\\.")
      "ifconfig #{interface} inet | grep 'inet #{ip_address}'"
    end

    def check_has_ipv6_address(interface, ip_address)
      ip_address = ip_address.dup
      (ip_address, prefixlen) = ip_address.split(/\//)
      ip_address.downcase!
      if ip_address =~ /^fe80::/i
        # link local needs the scope (interface) appended
        ip_address << "%#{interface}"
      end
      unless prefixlen.to_s.empty?
        # append prefixlen
        ip_address << " prefixlen #{prefixlen}"
      else
        ip_address << " "
      end
      "ifconfig #{interface} inet6 | grep 'inet6 #{ip_address}'"
    end

    def get_ipv4_address(interface)
      "ifconfig #{interface} inet | grep inet | awk '{print $2}'"
    end

    def get_ipv6_address(interface)
      # Awk refuses to print '/' even with using escapes or hex so workaround with sed employed here.
      "ifconfig #{interface} inet6 | grep inet6 | awk '{print $2$3$4}' | sed 's/prefixlen/\//'; exit"
    end

    def get_link_state(interface)
      # Checks if interfaces is administratively up by parsing the options.
      # L1 check via status. Virtual interfaces like tapX missing the status will report up.
      # Emulates operstate in linux with exception of the unknown status.
      %Q{ifconfig #{interface} 2>&1 | awk -v s=down -F '[:<>,]' } +
      %Q{'NR == 1 && $3 == "UP" { s="up" }; /status:/ && $2 != " active" { s="down" }; END{ print s }'}
    end
  end
end

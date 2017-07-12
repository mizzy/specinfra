class Specinfra::Command::Freebsd::V11::Interface < Specinfra::Command::Freebsd::Base::Interface
  class << self
    def get_ipv4_address(interface)
      "ifconfig -f inet:cidr #{interface} inet | awk '/inet /{print $2}'"
    end

    def get_ipv6_address(interface)
      "ifconfig -f inet6:cidr #{interface} inet6 | awk '/inet6 /{print $2}' | tail -1"
    end
  end
end

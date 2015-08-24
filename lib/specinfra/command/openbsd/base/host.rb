class Specinfra::Command::Openbsd::Base::Host < Specinfra::Command::Base::Host
  class << self
    def get_ipaddress(name)
      # getent hosts will return both the ipv6 and ipv4 record.
      # this will only pick the first one. (Linux behavior)
      "getent hosts #{escape(name)} | awk '{print $1; exit}'"
    end
    def get_ipv4_address(name)
      # May return multiple values pick the one matching ipv4
      "getent hosts #{escape(name)} | awk '$1 ~ /^[0-9.]+$/ {print $1}'"
    end
    def get_ipv6_address(name)
      # May return multiple values pick the one matching ipv6
      "getent hosts #{escape(name)} | awk 'tolower($1) ~ /^[0-9a-f:]+$/ {print $1}'"
    end
  end
end

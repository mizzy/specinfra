class Specinfra::Command::Aix::Base::Inventory < Specinfra::Command::Base::Inventory
  class << self
    def get_memory
      'false'
    end

    def get_cpu
      'false'
    end

    def get_hostname
      'uname -n'
    end

    def get_domain
      # This is emulating the dnsdomainname command in Linux
      # Requires proper configuration of /etc/resolv.conf
      # and DNS.
      # The exit at the end is to only return one entry if
      # the host is running in dualstack mode (IPv4 and IPv6)
      'host -n `uname -n` | ' +
      'awk -v h=`uname -n` \'$1 ~ h { sub(h".", "", $1); print $1; exit }\''
    end

    def get_fqdn
      # This is emulating the hostname -f command in Linux
      # Requires proper configuration of /etc/resolv.conf
      # and DNS.
      # The exit at the end is to only return one entry if
      # the host is running in dualstack mode (IPv4 and IPv6)
      'host -n `uname -n` | awk -v h=`uname -n` \'$1 ~ h"." { print $1; exit }\''
    end

    def get_filesystem
      'df -kP'
    end
  end
end

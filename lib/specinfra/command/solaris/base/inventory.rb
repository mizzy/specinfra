class Specinfra::Command::Solaris::Base::Inventory < Specinfra::Command::Base::Inventory
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
      # There is no sure way to get the hostname like on linux 
      # This code is somewhat resembiling the functionality 
      # of the dnsdomainname command. 
      # Assumes either /etc/hosts or DNS is properly configured. 
      %Q{getent hosts `uname -n` | } +
      %Q{nawk -v h=`uname -n` '{sub(h".", "", $2); if ($2 != h){ print $2 } else { exit 1 } }'}
    end

    def get_fqdn
      # Same as with get_domain assumes that either 
      # /etc/hosts or DNS are configured correctly.
      %Q{getent hosts `uname -n` | } +
      %Q{nawk -v h=`unme -n` '{ if ($2 ~ h".") { print $2 } else { exit 1 } }'}
    end

    def get_filesystem
      # emulates df -kP on Linux 
      # Also offers a creative solution for the 
      # multiple swap entries by adding a number suffix.
      # e.g. swap0, swap1 and so on.
      %Q{df -k | nawk -v i=0 '$1 == "swap" { $1=$1i; i++ }; NF == 1 { printf($1); next }; { print }'}
    end

    def get_system_product_name
      "prtdiag | grep 'System Configuration'"
    end 

  end
end

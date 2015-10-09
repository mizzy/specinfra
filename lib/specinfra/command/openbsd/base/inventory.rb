class Specinfra::Command::Openbsd::Base::Inventory < Specinfra::Command::Base::Inventory
  class << self
    def get_memory
      'false'
    end

    def get_cpu
      'false'
    end

    def get_hostname
      'hostname -s'
    end

    def get_domain
      'hostname | ' +
      'awk -v h=`hostname -s` \'$1 ~ h { sub(h".", "", $1); print $1 }\''
    end

    def get_fqdn
      'hostname'
    end

    def get_filesystem
      'df -kP'
    end
 
    def get_system_product_name
      'sysctl -n hw.product' 
    end 

  end
end

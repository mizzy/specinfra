class Specinfra::Command::Linux::Base::Inventory < Specinfra::Command::Base::Inventory
  class << self
    def get_memory
      'cat /proc/meminfo'
    end

    def get_hostname
      'hostname -s'
    end

    def get_domain
      'dnsdomainame'
    end

    def get_fqdn
      'hostname -f'
    end
  end
end

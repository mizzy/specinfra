module Specinfra
  class HostInventory
    class Virtualization < Base
      def get
        res = {}
        if backend.run_command('ls /.dockerinit').success?
          res[:system] = 'docker'
          return res
        end

        if backend.run_command('ls /usr/sbin/dmidecode').success?
          ret = backend.run_command('dmidecode')
          if ret.exit_status == 0
            case ret.stdout
            when /Manufacturer: VMware/
              if ret.stdout =~ /Product Name: VMware Virtual Platform/
                res[:system] = 'vmware'
              end
            when /Manufacturer: Oracle Corporation/
              if ret.stdout =~ /Product Name: VirtualBox/
                res[:system] = 'vbox'
              end
            when /Product Name: KVM/
              res[:system] = 'kvm'
            when /Product Name: OpenStack/
              res[:system] = 'openstack'
            else
              nil
            end
          else
            nil
          end
        end

        res
      end
    end
  end
end

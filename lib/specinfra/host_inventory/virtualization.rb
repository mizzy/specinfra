module Specinfra
  class HostInventory
    class Virtualization < Base
      def get
        res = {}
        ## docker
        if backend.run_command('grep -Eqa \'docker(/|-[0-9a-f]+)\' /proc/1/cgroup||test -e /.dockerinit').success?
          res[:system] = 'docker'
          return res
        end

        ## OpenVZ on Linux
        if backend.run_command('test -d /proc/vz -a ! -d /proc/bc').success?
          res[:system] = 'openvz'
          return res
        end

        cmd = backend.command.get(:get_inventory_system_product_name)
        ret = backend.run_command(cmd)
        if ret.exit_status == 0 and ret.stdout.length > 0
           res[:system] = parse_system_product_name(ret.stdout)
           return res
        end

        ret = backend.run_command('systemd-detect-virt')
        if ret.success?
          res[:system] = parse_systemd_detect_virt_output(ret.stdout)
        end

        res
      end

      def parse_system_product_name(ret)
        product_name = case ret
          when /.*VMware Virtual Platform/
            'vmware'
          when /.*VirtualBox/
            'vbox'
          when /.*KVM/
            'kvm'
          when /.*OpenStack/
            'openstack'
          else
            nil
        end
        product_name
      end

      def parse_systemd_detect_virt_output(ret)
        detected = ret.strip

        case detected
        when 'vmware', 'kvm', 'qemu'
          detected
        when 'oracle'
          'vbox'
        end
      end

    end
  end
end

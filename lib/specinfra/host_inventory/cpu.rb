module Specinfra
  class HostInventory
    class Cpu < Base
      def get
        cmd = backend.command.get(:get_inventory_cpu)
        ret = backend.run_command(cmd)
        if ret.exit_status == 0
           parse(ret.stdout)
        else
           nil
        end
      end
      def parse(cmd_ret)
        cpuinfo = {}
        cpus = cmd_ret.split(/[^^]processor/)
        cpuinfo['total'] = cpus.length.to_s
        cpus.each_with_index do |cpu, idx|
          idx = idx.to_s
          cpuinfo[idx] = {}
          cpu.each_line do |line|
            case line
            when /^vendor_id\s*:\s+(.+)$/
              cpuinfo[idx]['vendor_id'] = $1
            when /^cpu family\s*:\s+(\d+)$/
              cpuinfo[idx]['cpu_family'] = $1
            when /^model\s*:\s+(\d+)$/
              cpuinfo[idx]['model'] = $1
            when /^model\sname\s*:\s+(.+)$/
              cpuinfo[idx]['model_name'] = $1
            when /^stepping\s*:\s+(\d+)$/
              cpuinfo[idx]['stepping'] = $1
            when /^microcode\s*:\s+(.+)$/
              cpuinfo[idx]['microcode'] = $1
            when /^cpu MHz\s*:\s+(.+)$/
              cpuinfo[idx]['cpu_mhz'] = $1
            when /^cache size\s*:\s+(\d+) (.+)$/
              cpuinfo[idx]['cache_size'] = "#{$1}#{$2}"
            when /^physical id\s*:\s+(\d+)$/
              cpuinfo[idx]['physical_id'] = $1
            when /^siblings\s*:\s+(\d+)$/
              cpuinfo[idx]['siblings'] = $1
            when /^core id\s*:\s+(\d+)$/
              cpuinfo[idx]['core_id'] = $1
            when /^cpu cores\s*:\s+(\d+)$/
              cpuinfo[idx]['cpu_cores'] = $1
            when /^apicid\s*:\s+(\d+)$/
              cpuinfo[idx]['apicid'] = $1
            when /^initial apicid\s*:\s+(\d+)$/
              cpuinfo[idx]['initial_apicid'] = $1
            when /^fpu\s*:\s+(.+)$/
              cpuinfo[idx]['fpu'] = $1
            when /^fpu_exception\s*:\s+(.+)$/
              cpuinfo[idx]['fpu_exception'] = $1
            when /^cpuid level\s*:\s+(\d+)$/
              cpuinfo[idx]['cpuid_level'] = $1
            when /^wp\s*:\s+(.+)$/
              cpuinfo[idx]['wp'] = $1
            when /^flags\s*:\s+(.+)$/
              cpuinfo[idx]['flags'] = $1.split(/\s/)
            when /^bogomips\s*:\s+(.+)$/
              cpuinfo[idx]['bogomips'] = $1
            when /^clflush size\s*:\s+(\d+)$/
              cpuinfo[idx]['clflush_size'] = $1
            when /^cache_alignment\s*:\s+(\d+)$/
              cpuinfo[idx]['cache_alignment'] = $1
            when /^address sizes\s*:\s+(.+)$/
              cpuinfo[idx]['address_sizes'] = $1
            when /^power management\s*:\s+(.*)$/
              cpuinfo[idx]['power_management'] = $1
            end
          end
        end
        cpuinfo
      end
    end
  end
end

module Specinfra
  class HostInventory
    class Memory < Base
      def get
        cmd = backend.command.get(:get_inventory_memory)
        ret = backend.run_command(cmd)
        if ret.exit_status == 0
          parse(ret.stdout)
        else
          nil
        end
      end
      def parse(ret)
        memory = { 'swap' => {} }
        ret.each_line do |line|
          case line
          when /^SwapCached:\s+(\d+) (.+)$/
            memory['swap']['cached'] = "#{$1}#{$2}"
          when /^SwapTotal:\s+(\d+) (.+)$/
            memory['swap']['total'] = "#{$1}#{$2}"
          when /^SwapFree:\s+(\d+) (.+)$/
            memory['swap']['free'] = "#{$1}#{$2}"
          when /^MemTotal:\s+(\d+) (.+)$/
            memory['total'] = "#{$1}#{$2}"
          when /^MemFree:\s+(\d+) (.+)$/
            memory['free'] = "#{$1}#{$2}"
          when /^Buffers:\s+(\d+) (.+)$/
            memory['buffers'] = "#{$1}#{$2}"
          when /^Cached:\s+(\d+) (.+)$/
            memory['cached'] = "#{$1}#{$2}"
          when /^Active:\s+(\d+) (.+)$/
            memory['active'] = "#{$1}#{$2}"
          when /^Inactive:\s+(\d+) (.+)$/
            memory['inactive'] = "#{$1}#{$2}"
          when /^Dirty:\s+(\d+) (.+)$/
            memory['dirty'] = "#{$1}#{$2}"
          when /^Writeback:\s+(\d+) (.+)$/
            memory['writeback'] = "#{$1}#{$2}"
          when /^AnonPages:\s+(\d+) (.+)$/
            memory['anon_pages'] = "#{$1}#{$2}"
          when /^Mapped:\s+(\d+) (.+)$/
            memory['mapped'] = "#{$1}#{$2}"
          when /^Slab:\s+(\d+) (.+)$/
            memory['slab'] = "#{$1}#{$2}"
          when /^SReclaimable:\s+(\d+) (.+)$/
            memory['slab_reclaimable'] = "#{$1}#{$2}"
          when /^SUnreclaim:\s+(\d+) (.+)$/
            memory['slab_unreclaim'] = "#{$1}#{$2}"
          when /^PageTables:\s+(\d+) (.+)$/
            memory['page_tables'] = "#{$1}#{$2}"
          when /^NFS_Unstable:\s+(\d+) (.+)$/
            memory['nfs_unstable'] = "#{$1}#{$2}"
          when /^Bounce:\s+(\d+) (.+)$/
            memory['bounce'] = "#{$1}#{$2}"
          when /^CommitLimit:\s+(\d+) (.+)$/
            memory['commit_limit'] = "#{$1}#{$2}"
          when /^Committed_AS:\s+(\d+) (.+)$/
            memory['committed_as'] = "#{$1}#{$2}"
          when /^VmallocTotal:\s+(\d+) (.+)$/
            memory['vmalloc_total'] = "#{$1}#{$2}"
          when /^VmallocUsed:\s+(\d+) (.+)$/
            memory['vmalloc_used'] = "#{$1}#{$2}"
          when /^VmallocChunk:\s+(\d+) (.+)$/
            memory['vmalloc_chunk'] = "#{$1}#{$2}"
          when /^AnonHugePages:\s+(\d+) (.+)$/
            memory['annon_huge_pages'] = "#{$1}#{$2}"
          when /^HugePages_Total:\s+(\d+)$/
            memory['huge_pages_total'] = "#{$1}"
          when /^HugePages_Free:\s+(\d+)$/
            memory['huge_pages_free'] = "#{$1}"
          when /^HugePages_Rsvd:\s+(\d+)$/
            memory['huge_pages_rsvd'] = "#{$1}"
          when /^HugePages_Surp:\s+(\d+)$/
            memory['huge_pages_surp'] = "#{$1}"
          when /^Hugepagesize:\s+(\d+) (.+)$/
            memory['huge_page_size'] = "#{$1}#{$2}"
          end
        end
        memory
      end
    end
  end
end

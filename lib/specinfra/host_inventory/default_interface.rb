module Specinfra
  class HostInventory
    class DefaultInterface < Base
      def get
        cmd   = backend.command.get(:get_ipv4_default_interface)
        ret   = backend.run_command(cmd)
        inet  = parse(ret) 
        cmd   = backend.command.get(:get_ipv6_default_interface)
        ret   = backend.run_command(cmd)
        inet6 = parse(ret)
        res   = { :inet => inet, :inet6 => inet6 }.delete_if { |k,v| v == nil }
        res.empty? ? nil : res
      end

      def parse(ret) 
         device = nil                   
         ret.each_line do |line| 
           if line =~ /.*default.*?dev\s+(.*?)\s+.*/x
             device = $1
             ## return after the first match 
             ## this if vor ipv6 where the first entry
             ## marks the default one
             return device 
           end 
         end 
         device   
      end 

    end
  end
end


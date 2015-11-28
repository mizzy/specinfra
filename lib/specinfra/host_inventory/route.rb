module Specinfra
  class HostInventory
    class Route < Base
      def get
        begin 
          route = {} 
          cmd   = backend.command.get(:get_inventory_ipv4_routing_table)
          ret   = backend.run_command(cmd)
          inet  = parse_inet(ret.stdout)
          cmd   = backend.command.get(:get_inventory_ipv6_routing_table)
          ret   = backend.run_command(cmd)
          inet6 = parse_inet6(ret.stdout)
          { :inet => inet, :inet6 => inet6 }.delete_if { |k,v| v == nil }
        rescue
          nil
        end
      end

      def parse_inet(ret) 
         routes = []                  
         ret.each_line do |line| 
           if line =~ /(?:(unicast|nat|unreachable|prohibit|blackhole|throw)\s+)?
                       (default|(?:\d{1,3}\.){3}\d{1,3}(?:\/\d{1,2})?)\s+
                       (?:via\s+(.*?)\s+)?
                       (?:dev\s+(.*?)\s+)?
                       (?:proto\s+(.*?)\s+)?
                       (?:scope\s+(.*?)\s+)?
                       (?:src\s+(.*?)\s+)?
                       (?:metric\s+(\d{1,})\s+)?
                      /x
              routes.push( 
                { 
                  :type        => ($1 ? $1 : 'unicast'),
                  :destination => $2, 
                  :next_hop    => $3,
                  :device      => $4,
                  :proto       => $5,
                  :scope       => $6, 
                  :source      => $7, 
                  :metric      => $8, 
                  :family      => 'inet' 
                }.delete_if { |k,v| v == nil } 
              )
           end 
         end 
         routes 
      end 

      def parse_inet6(ret) 
         routes = []                  
         ret.each_line do |line| 
           if line =~ /(?:(unicast|nat|unreachable|prohibit|blackhole|throw)\s+)?
                       (default|(?:[0-9a-fA-F:.]{2,39}(?:\/\d{1,3})?))\s+
                       (?:via\s+(.*?)\s+)?
                       (?:dev\s+(.*?)\s+)?
                       (?:proto\s+(.*?)\s+)?
                       (?:metric\s+(\d{1,})\s+)?
                       (?:(?:error|expires)\s+.*?\s+)?
                       (?:mtu\s+(\d{1,})\s+)?
                       (?:advmss\s+(\d{1,})\s+)?
                       (?:hoplimit\s+(\d{1,})\s+)?
                      /x 
              routes.push( 
                { 
                  :type        => ($1 ? $1 : 'unicast'),
                  :destination => $2, 
                  :next_hop    => $3,
                  :device      => $4,
                  :proto       => $5,
                  :metric      => $6,
                  :mtu         => $7,
                  :advmss      => $8,
                  :hoplimit    => $9,
                  :family      => 'inet6'
                }.delete_if { |k,v| v == nil } 
              )
           end 
         end 
         routes 
      end 
    end
  end
end

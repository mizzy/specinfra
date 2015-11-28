module Specinfra
  class HostInventory
    class Network < Base
      def get
        cmd = backend.command.get(:get_inventory_interfaces)
        ret = backend.run_command(cmd)
        if ret.exit_status == 0
          ## currently linux only 
          res = parse_interfaces(ret.stdout)
          cmd = backend.command.get(:get_inventory_ipv4_routing_table)
          ret = backend.run_command(cmd)
          res.merge!(parse_ipv4_routing_table(ret.stdout))
          cmd = backend.command.get(:get_inventory_ipv6_routing_table)
          ret = backend.run_command(cmd)
          res.merge!(parse_ipv6_routing_table(ret.stdout))
          res 
        else
          nil
        end
      end

      def parse_ipv4_routing_table(ret) 
         routes = {}                  
         routes[:routes] = []                  
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
              routes[:routes].push( 
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
              routes[:default_inet_interface] = $4 if $2 == 'default'
           end 
         end 
         routes 
      end 

      def parse_ipv6_routing_table(ret) 
         routes = {}                  
         routes[:routes] = []                  
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
              routes[:routes].push( 
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
              routes[:default_inet6_interface] = $4 if $2 == 'default'
           end 
         end 
         routes 
      end 

      def parse_interfaces(ret)
        interfaces = {}
        @device    = nil
        @address = nil
        ret.each_line do |line|
          if line =~ /^\d+:\s+([\w\d]+):?\s+
                      <([A-Z\d_,]+)>\s+
                      mtu\s+(\d+?)\s+
                      qdisc\s+([\d\w]+?)\s+
                      state\s+([A-Z]+)\s+
                      (?:qlen\s+(\d+)\s+)?
                      .*?
                     /x 

            @device= $1.to_s
            interfaces[@device]        ||= {}
            interfaces[@device][:mtu]    = $3
            interfaces[@device][:qdisc]  = $4
            interfaces[@device][:state]  = $5.to_s.downcase
            interfaces[@device][:qlen]   = $6 if $6 != nil 
            ## must process at end the result is skewed!
            interfaces[@device][:flags]  = $2.to_s.split(',') 

          elsif line =~ /^\s+link\/(\w+?)\s+(?:([A-Fa-f0-9:]+)\s+brd\s+([A-Fa-f0-9:]+))?/x 
            interfaces[@device][:encapsulation]  = ($1 == 'ether' ? 'ethernet' : $1.to_s)
            interfaces[@device][:addresses] ||= {}
            interfaces[@device][:addresses][$2.to_s.upcase] = { :family => 'lladdr' } if $2 

          elsif line =~ /^\s+
                         (inet6?)\s+([a-fA-F\d:.]+)\/(\d+)\s+
                         (?:brd\s+([\d.]+)\s+)?
                         scope\s+(\w+?)\s+
                         (?:((?:(?:temporary|permanent|dynamic|secondary|primary|tentative|deprecated)\s+)+))?
                         (?:(#{@device}.*?)(?:\s+|$))?
                        /x
            @address = $2
            interfaces[@device][:addresses] ||= {}
            interfaces[@device][:addresses][@address] = {
              :family    => $1,
              :prefixlen => $3,
              :broadcast => $4,
              :scope     => $5,
              :label     => $7,
              ## must process at end the result is skewed!
              :flags     => ($6.to_s.empty? ? nil : $6.split(/\s+/)) 
            }.delete_if { |k,v| v == nil } 

          elsif line =~ /^\s+
                         valid_lft\s+([\w\d]+)\s+
                         preferred_lft\s+([\w\d]+)\s+
                        /x

            interfaces[@device][:addresses][@address].merge!(
              { :valid_lft     => $1,
                :preferred_lft => $2
              }.delete_if { |k,v| v == nil } 
            )
          end
        end
        { :interfaces => interfaces } 
      end
    end
  end
end

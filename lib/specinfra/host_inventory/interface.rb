module Specinfra
  class HostInventory
    class Interface < Base
      def get
        begin 
          cmd = backend.command.get(:get_inventory_interfaces)
          ret = backend.run_command(cmd)
          parse(ret)
        rescue
          nil
        end
      end

      def parse(ret)
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
        interfaces
      end
    end
  end
end

module Specinfra
  module Command
    module Module
      module Ss
        def check_is_listening(port, options={})
          pattern = ":#{port} "
          pattern = " #{inaddr_any_to_asterisk(options[:local_address])}#{pattern}" if options[:local_address]
          "ss #{command_options(options[:protocol])} | grep -- #{escape(pattern)}"
        end

        private

        # WORKAROUND:
        #   ss displays "*" instead of "0.0.0.0".
        #   But serverspec validates IP address by `valid_ip_address?` method:
        #     https://github.com/serverspec/serverspec/blob/master/lib/serverspec/type/port.rb
        def inaddr_any_to_asterisk(local_address)
          if local_address == '0.0.0.0'
            '*'
          else
            local_address
          end
        end

        def command_options(protocol)
          case protocol
            when /\Atcp/
              if protocol == 'tcp'
                "-tnl4"
              else
                "-tnl6"
              end
          when /\Audp/
            if protocol == 'udp'
              "-unl4"
            else
              "-unl6"
            end
          else
            "-tunl"
          end
        end
      end
    end
  end
end

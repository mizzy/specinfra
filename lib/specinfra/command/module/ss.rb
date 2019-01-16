module Specinfra
  module Command
    module Module
      module Ss
        def check_is_listening(port, options={})
          if options[:local_address]
            pattern = inaddr_any_to_asterisk(options[:local_address]).map { |l| " #{l}:#{port} " }
            pattern = pattern.join('|')
          else
            pattern = ":#{port} "
          end
          "ss #{command_options(options[:protocol])} | grep -E -- #{escape(pattern)}"
        end

        private

        # WORKAROUND:
        #   Older ss versions display "*" instead of "0.0.0.0".
        #   But serverspec validates IP address by `valid_ip_address?` method:
        #     https://github.com/serverspec/serverspec/blob/master/lib/serverspec/type/port.rb
        def inaddr_any_to_asterisk(local_address)
          if local_address == '0.0.0.0'
            [ '\*' , '0\.0\.0\.0' ]
          else
            [ local_address ]
          end
        end

        def command_options(protocol)
          case protocol.to_s
          when 'tcp'  then "-tnl4"
          when 'tcp6' then "-tnl6"
          when 'udp'  then "-unl4"
          when 'udp6' then "-unl6"
          when ''     then "-tunl"
          else
            raise ArgumentError, "Unknown protocol [#{protocol}]"
          end
        end
      end
    end
  end
end

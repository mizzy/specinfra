class Specinfra::Command::Linux::Base::Port < Specinfra::Command::Base::Port
  class << self
    def check_is_listening(port, options = {})
      options[:local_address] = '*' unless options[:local_address]
      laddr = "#{options[:local_address]}:#{port}"
      if options[:protocol] == 'tcp'
        "ss -tnl | awk 'BEGIN {c=0} $4 == \"#{laddr}\" {c++} END { if (c>0) {exit(0)}; exit(1) }'"
      elsif options[:protocol] == 'udp'
        "ss -unl | awk 'BEGIN {c=0} $4 == \"#{laddr}\" {c++} END { if (c>0) {exit(0)}; exit(1) }'"
      else
        "ss -nl | awk 'BEGIN {c=0} $5 == \"#{laddr}\" {c++} END { if (c>0) {exit(0)}; exit(1) }'"
      end
    end
  end
end

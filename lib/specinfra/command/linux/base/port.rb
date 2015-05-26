class Specinfra::Command::Linux::Base::Port < Specinfra::Command::Base::Port
  class << self
    def check_is_listening(port, options = {})
      options[:local_address] = '*' unless options[:local_address]
      laddr = "#{options[:local_address]}:#{port}"
      awk = "awk 'BEGIN {c=0} $6 == \"#{laddr}\" {c++} END { if (c>0) {exit(0)}; exit(1) }'"
      if options[:protocol] == 'tcp'
        "ss -tnl | #{awk}"
      elsif options[:protocol] == 'udp'
        "ss -unl | #{awk}"
      else
        "ss -nl | #{awk}"
      end
    end
  end
end

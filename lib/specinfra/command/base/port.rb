class Specinfra::Command::Base::Port < Specinfra::Command::Base
  def check_is_listening(port, options = {})
    pattern = ":#{port}"
    pattern = " #{options[:local_address]}#{pattern}" if options[:local_address]
    pattern = "^#{options[:protocol]} .*#{pattern}" if options[:protocol]
    "netstat -tunl | grep -- #{escape(pattern)}"
  end

  def check_is_listening_with_protocol(port, protocol)
    check_listening port, {:protocol => protocol}
  end
end

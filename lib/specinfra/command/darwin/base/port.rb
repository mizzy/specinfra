class Specinfra::Command::Darwin::Base::Port < Specinfra::Command::Base::Port
  class << self
    def check_is_listening(port, options={})
      regexp = ".*:#{port}"
      regexp = ".*#{options[:local_address]}#{regexp}" if options[:local_address]
      regexp = "#{options[:protocol]}#{regexp}" if options[:protocol]
      "lsof -nP | grep --ignore-case --extended-regexp -- '#{regexp}'"
    end
  end
end

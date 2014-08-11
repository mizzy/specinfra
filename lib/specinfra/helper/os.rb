require 'specinfra/helper/detect_os'

module Specinfra::Helper::Os
  def os
    property[:os_by_host] = {} if ! property[:os_by_host]
    host_port = current_host_and_port

    if property[:os_by_host][host_port]
      os_by_host = property[:os_by_host][host_port]
    else
      # Set command object explicitly to avoid `stack too deep`
      os_by_host = detect_os
      property[:os_by_host][host_port] = os_by_host
    end
    os_by_host
  end

  private

  # put this in a module for better reuse
  def current_host_and_port
    if Specinfra.configuration.ssh
      "#{Specinfra.configuration.ssh.host}:#{Specinfra.configuration.ssh.options[:port]}"
    elsif Specinfra.configuration.ssh_options
          
      "#{Specinfra.configuration.host}:#{Specinfra.configuration.ssh_options[:port]}"
    else
      "#{Specinfra.configuration.host}:0"
    end
  end

  def detect_os
    return Specinfra.configuration.os if Specinfra.configuration.os
    Specinfra::Helper::DetectOs.subclasses.each do |c|
      res = c.detect
      if res
        res[:arch] ||= Specinfra.backend.run_command('uname -m').stdout.strip
        return res
      end
    end
  end
end

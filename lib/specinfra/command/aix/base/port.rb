class Specinfra::Command::Aix::Base::Port < Specinfra::Command::Base::Port
  class << self
    def check_is_listening(port, options={})
      regexp = "*.#{port} "
      "netstat -an -f inet | awk '{print $4}' | grep  -- #{regexp}"
    end
  end
end

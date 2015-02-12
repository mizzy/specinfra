class Specinfra::Command::Linux::Base::Bond < Specinfra::Command::Base::Bond
  class << self
    def check_exists(name)
      "ip link show #{name}"
    end

    def have_interface(name, interface)
      "awk '/Slave Interface: #{interface}/' /proc/net/bonding/#{name}"
    end
  end
end

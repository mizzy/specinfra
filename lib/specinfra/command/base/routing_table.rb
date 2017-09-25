class Specinfra::Command::Base::RoutingTable < Specinfra::Command::Base
  class << self
    def check_has_entry(destination)
      if destination == "default"
        destination = "0.0.0.0/0"
      end
      "ip route show #{destination}"
    end

    alias :get_entry :check_has_entry
  end
end

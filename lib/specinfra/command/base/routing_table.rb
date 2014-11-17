class Specinfra::Command::Base::RoutingTable < Specinfra::Command::Base
  class << self
    def check_has_entry(destination)
      "ip route | grep -E '^#{destination} '"
    end

    alias :get_entry :check_has_entry
  end
end

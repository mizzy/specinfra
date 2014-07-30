class Specinfra::Command::Base::RoutingTable < Specinfra::Command::Base
  def check_has_entry(destination)
    "ip route | grep -E '^#{destination} |^default '"
  end

  alias :get_entry :check_has_entry
end

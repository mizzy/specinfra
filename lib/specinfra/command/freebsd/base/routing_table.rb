class Specinfra::Command::Freebsd::Base::RoutingTable < Specinfra::Command::Base::RoutingTable
  class << self
    def check_has_entry(destination)
      %Q{netstat -rnW | grep #{destination} | awk '{print $1, "via", $2, "dev", $6, " "}'}
    end

    alias :get_entry :check_has_entry
  end
end

class Specinfra::Command::Openbsd::Base::RoutingTable < Specinfra::Command::Base::RoutingTable
  class << self
    def check_has_entry(destination)
      "route -n show -gateway | egrep '^#{destination}' | head -1"
    end

    alias :get_entry :check_has_entry
  end
end

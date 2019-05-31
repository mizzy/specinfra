class Specinfra::Command::Aix::Base::RoutingTable < Specinfra::Command::Base::RoutingTable
  class << self
    def check_has_entry(destination)
      if os[:arch] == 'vios'
        "netstat -routtable | grep #{destination}"
      else
        "netstat -r | grep #{destination}"
      end
    end

    alias :get_entry :check_has_entry
  end
end

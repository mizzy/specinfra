class Specinfra::Command::Linux::Base::Inventory < Specinfra::Command::Base::Inventory
  class << self
    def get_memory
      'cat /proc/meminfo'
    end
  end
end

class Specinfra::Command::Base::Inventory < Specinfra::Command::Base
  class << self
    def get_user
      'getent passwd'
    end
  end
end

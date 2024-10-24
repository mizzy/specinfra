module Specinfra
  module Command
    module Module
      module Runit
        include Specinfra::Command::Module::Service::Runit
        extend  Specinfra::Command::Module::Service::Delegator
        def_delegator_service_under :runit
      end
    end
  end
end

module Specinfra
  module Command
    module Module
      module OpenRC
        include Specinfra::Command::Module::Service::OpenRC
        extend  Specinfra::Command::Module::Service::Delegator
        def_delegator_service_under :openrc
      end
    end
  end
end

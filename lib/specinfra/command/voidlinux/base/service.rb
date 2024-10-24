class Specinfra::Command::Voidlinux::Base::Service < Specinfra::Command::Linux::Base::Service
  class << self
    include Specinfra::Command::Module::Runit
  end
end

class Specinfra::Command::Arch::Base::Service < Specinfra::Command::Linux::Base::Service
  class << self
    include Specinfra::Command::Module::Systemd
  end
end

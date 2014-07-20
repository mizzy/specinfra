class Specinfra::Command::Arch::Base::Service < Specinfra::Command::Linux::Base::Service
  include Specinfra::Command::Module::Systemd
end

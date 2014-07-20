class Specinfra::Command::Nixos::Base::Service < Specinfra::Command::Linux::Base::Service
  include Specinfra::Command::Module::Systemd
end

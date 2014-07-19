require 'specinfra/command/module/systemd'

class Specinfra::Command::Redhat::V7::Service < Specinfra::Command::Redhat::Base::Service
  include Specinfra::Command::Module::Systemd
end

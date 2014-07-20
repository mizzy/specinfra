require 'specinfra/command/module/systemd'

class Specinfra::Command::Fedora::V15::Service < Specinfra::Command::Fedora::Base::Service
  include Specinfra::Command::Module::Systemd
end

class Specinfra::Command::Fedora::V15::Service < Specinfra::Command::Fedora::Base::Service
  class << self
    include Specinfra::Command::Module::Systemd
  end
end

class Specinfra::Command::Debian::V8::Service < Specinfra::Command::Debian::Base::Service
  class << self
    include Specinfra::Command::Module::Systemd
  end
end

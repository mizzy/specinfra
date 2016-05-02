class Specinfra::Command::Ubuntu::V16::Service < Specinfra::Command::Ubuntu::Base::Service
  class << self
    include Specinfra::Command::Module::Systemd
  end
end

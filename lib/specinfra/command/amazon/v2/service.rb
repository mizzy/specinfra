class Specinfra::Command::Amazon::V2::Service < Specinfra::Command::Amazon::Base::Service
  class << self
    include Specinfra::Command::Module::Systemd
  end
end

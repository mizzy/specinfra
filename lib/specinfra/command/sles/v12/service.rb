class Specinfra::Command::Sles::V12::Service < Specinfra::Command::Sles::Base::Service
  class << self
    include Specinfra::Command::Module::Systemd
  end
end

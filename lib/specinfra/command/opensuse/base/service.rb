class Specinfra::Command::Opensuse::Base::Service < Specinfra::Command::Suse::Base::Service
  class << self
    include Specinfra::Command::Module::Systemd
  end
end

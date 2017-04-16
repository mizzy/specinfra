class Specinfra::Command::Freebsd::Base::Zfs < Specinfra::Command::Base::Zfs
  class << self
    include Specinfra::Command::Module::Zfs
  end
end

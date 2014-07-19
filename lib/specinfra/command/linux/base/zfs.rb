require 'specinfra/command/module/zfs'

class Specinfra::Command::Linux::Base::Zfs < Specinfra::Command::Base::Zfs
  include Specinfra::Command::Module::Zfs
end

class Specinfra::Command::Debian::Base::Port < Specinfra::Command::Base::Port
  class << self
    include Specinfra::Command::Module::Ss
  end
end

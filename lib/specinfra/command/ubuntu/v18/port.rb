class Specinfra::Command::Ubuntu::Base::V18::Port < Specinfra::Command::Ubuntu::Base::Port
  class << self
    include Specinfra::Command::Module::Ss
  end
end

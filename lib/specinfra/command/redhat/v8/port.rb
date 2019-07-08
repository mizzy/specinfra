class Specinfra::Command::Redhat::V8::Port < Specinfra::Command::Redhat::Base::Port
  class << self
    include Specinfra::Command::Module::Ss
  end
end

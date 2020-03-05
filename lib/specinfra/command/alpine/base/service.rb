class Specinfra::Command::Alpine::Base::Service < Specinfra::Command::Linux::Base::Service
  class << self
    include Specinfra::Command::Module::OpenRC
  end
end

class Specinfra::Command::Freebsd::Base::KernelModule < Specinfra::Command::Base::KernelModule
  class << self
    def check_is_loaded(name)
      "kldstat -q -m #{name}"
    end
  end
end

class Specinfra::Command::Solaris::Base::KernelModule < Specinfra::Command::Base::KernelModule
  class << self
    def check_is_loaded(name)
      "modinfo -c | awk '$3 == \"#{escape(name)}\" { print $4 }' | grep ^LOADED"
    end
  end
end

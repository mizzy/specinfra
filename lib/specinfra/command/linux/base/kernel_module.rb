class Specinfra::Command::Linux::Base::KernelModule < Specinfra::Command::Base::KernelModule
  def check_is_loaded(name)
    "lsmod | grep ^#{name}"
  end
end

class Specinfra::Command::Base::KernelModule < Specinfra::Command::Base
  def check_is_loaded(name)
    raise NotImplementedError.new
  end
end

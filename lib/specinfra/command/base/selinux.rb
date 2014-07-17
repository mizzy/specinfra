class Specinfra::Command::Base::Selinux < Specinfra::Command::Base
  def check_mode(mode)
    raise NotImplementedError.new
  end
end

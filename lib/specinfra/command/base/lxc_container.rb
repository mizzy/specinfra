class Specinfra::Command::Base::LxcContainer < Specinfra::Command::Base
  def check_exists(container)
    raise NotImplementedError.new
  end

  def check_is_running(container)
    raise NotImplementedError.new
  end
end

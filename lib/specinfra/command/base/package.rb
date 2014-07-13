class Specinfra::Command::Base::Package < Specinfra::Command::Base
  def check_installed(name, version=nil)
    raise NotImplementedError.new
  end
end


class Specinfra::Command::Base::Interface < Specinfra::Command::Base
  def get_speed_of(name)
    raise NotImplementedError.new
  end

  def check_ipv4_address(interface, ip_address)
    raise NotImplementedError.new
  end
end

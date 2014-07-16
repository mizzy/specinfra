class Specinfra::Command::Base::Iptables < Specinfra::Command::Base
  def check_has_rule(rule, table=nil, chain=nil)
    raise NotImplementedError.new
  end
end

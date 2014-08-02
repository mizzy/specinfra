class Specinfra::Command::Solaris::Base::Ipfilter < Specinfra::Command::Base::Ipfilter
  class << self
    def check_has_rule(rule)
      "ipfstat -io 2> /dev/null | grep -- #{escape(rule)}"
    end
  end
end

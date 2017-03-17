class Specinfra::Command::Linux::Base::Selinux < Specinfra::Command::Base::Selinux
  class << self
    def check_has_mode(mode, policy = nil)

      cmd =  ""

      # If disabled, then the absence of /etc/selinux/config is sufficient
      cmd += "test ! -f /etc/selinux/config || " if mode == "disabled"

      # If disabled, wrap the rest of the test in parentheses
      # i.e. only test this stuff if /etc/selinux/config exists
      cmd += "( ( " if mode == "disabled"

      # Does getenforce return the same value as we are checking for?
      cmd += "(getenforce | grep -i -- #{escape(mode)})"

      # If disabled, then permissive is considered a pass
      cmd += " || (getenforce | grep -i -- #{escape('permissive')}) )" if mode == "disabled"

      # Ensure that /etc/selinux/config contains the mode we specify
      cmd += %Q{ && grep -iE -- '^\\s*SELINUX=#{escape(mode)}\\>' /etc/selinux/config}

      # If we have specified a policy, ensure that is included in /etc/selinux/config
      cmd += %Q{ && grep -iE -- '^\\s*SELINUXTYPE=#{escape(policy)}\\>' /etc/selinux/config} if policy != nil

      # End parenthesis for tests when /etc/selinux/config exists
      cmd += ")" if mode == "disabled"

      cmd
    end
  end
end

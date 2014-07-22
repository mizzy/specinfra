class Specinfra::Command::Base::Package < Specinfra::Command::Base
  def check_is_installed_by_gem(name, version=nil)
    regexp = "^#{name}"
    cmd = "gem list --local | grep -w -- #{escape(regexp)}"
    cmd = "#{cmd} | grep -w -- #{escape(version)}" if version
    cmd
  end

  def check_is_installed_by_npm(name, version=nil)
    cmd = "npm ls #{escape(name)} -g"
    cmd = "#{cmd} | grep -w -- #{escape(version)}" if version
    cmd
  end

  def check_is_installed_by_pecl(name, version=nil)
    regexp = "^#{name}"
    cmd = "pecl list | grep -w -- #{escape(regexp)}"
    cmd = "#{cmd} | grep -w -- #{escape(version)}" if version
    cmd
  end

  def check_is_installed_by_pear(name, version=nil)
    regexp = "^#{name}"
    cmd = "pear list | grep -w -- #{escape(regexp)}"
    cmd = "#{cmd} | grep -w -- #{escape(version)}" if version
    cmd
  end

  def check_is_installed_by_pip(name, version=nil)
    regexp = "^#{name}"
    cmd = "pip list | grep -w -- #{escape(regexp)}"
    cmd = "#{cmd} | grep -w -- #{escape(version)}" if version
    cmd
  end

  def check_is_installed_by_cpan(name, version=nil)
    regexp = "^#{name}"
    cmd = "cpan -l | grep -w -- #{escape(regexp)}"
    cmd = "#{cmd} | grep -w -- #{escape(version)}" if version
    cmd
  end
end


class Specinfra::Command::Linux::Base::File < Specinfra::Command::Base::File
  def check_access_by_user(file, user, access)
    "su -s /bin/sh -c \"test -#{access} #{file}\" #{user}"
  end

  def check_is_immutable(file)
    check_attribute(file, 'i')
  end

  def check_attribute(file, attribute)
    "lsattr -d #{escape(file)} 2>&1 | awk '$1~/^-*#{escape(attribute)}-*$/ {exit 0} {exit 1}'"
  end
end

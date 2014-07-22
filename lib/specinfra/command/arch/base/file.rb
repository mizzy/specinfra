class Specinfra::Command::Arch::Base::File < Specinfra::Command::Linux::Base::File
  def check_access_by_user(file, user, access)
    "runuser -s /bin/sh -c \"test -#{access} #{file}\" #{user}"
  end
end

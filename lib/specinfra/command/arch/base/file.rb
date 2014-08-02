class Specinfra::Command::Arch::Base::File < Specinfra::Command::Linux::Base::File
  class << self
    def check_is_accessible_by_user(file, user, access)
      "runuser -s /bin/sh -c \"test -#{access} #{file}\" #{user}"
    end
  end
end








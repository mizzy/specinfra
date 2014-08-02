class Specinfra::Command::Solaris::V10::Group < Specinfra::Command::Solaris::Base::Group
  class << self
    def check_exists(group)
      "getent group | grep -w -- #{escape(group)}"
    end
  end
end

class Specinfra::Command::Solaris::V10::Group < Specinfra::Command::Solaris::Base::Group
  def check_exists(group)
    "getent group | grep -w -- #{escape(group)}"
  end
end

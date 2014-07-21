class Specinfra::Command::Solaris::V10::User < Specinfra::Command::Solaris::Base::User
  def check_is_belonging_to_group(user, group)
    "id -ap #{escape(user)} | grep -- #{escape(group)}"
  end

  def check_has_authorized_key(user, key)
    key.sub!(/\s+\S*$/, '') if key.match(/^\S+\s+\S+\s+\S*$/)
    "grep -- #{escape(key)} ~#{escape(user)}/.ssh/authorized_keys"
  end
end







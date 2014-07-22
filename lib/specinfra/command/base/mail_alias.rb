class Specinfra::Command::Base::MailAlias < Specinfra::Command::Base
  def check_is_aliased_to(recipient, target)
    target = "[[:space:]]#{target}"
    "getent aliases #{escape(recipient)} | grep -- #{escape(target)}$"
  end
end

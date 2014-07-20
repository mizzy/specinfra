class Specinfra::Command::Openbsd::Base::MailAlias < Specinfra::Command::Base::MailAlias
  def check_is_aliased_to(recipient, target)
    "egrep '^#{escape(recipient)}:.*#{escape(target)}' /etc/mail/aliases"
  end
end

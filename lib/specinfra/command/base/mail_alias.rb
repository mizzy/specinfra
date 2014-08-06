class Specinfra::Command::Base::MailAlias < Specinfra::Command::Base
  class << self
    def check_is_aliased_to(mail_alias, recipient)
      recipient = "[[:space:]]#{recipient}"
      "getent aliases #{escape(mail_alias)} | grep -- #{escape(recipient)}$"
    end

    def add(mail_alias, recipient)
      "echo #{mail_alias}: #{recipient} >> /etc/aliases"
    end
  end
end

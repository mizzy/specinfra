class Specinfra::Command::Openbsd::Base::MailAlias < Specinfra::Command::Base::MailAlias
  class << self
    def check_is_aliased_to(recipient, target)
      target = %Q{([[:space:]]|,)["']?#{escape(target)}["']?(,|$)}
      "egrep ^#{escape(recipient)}:.*#{escape(target)} /etc/mail/aliases"
    end
  end
end

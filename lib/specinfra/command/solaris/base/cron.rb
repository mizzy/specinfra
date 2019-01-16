class Specinfra::Command::Solaris::Base::Cron < Specinfra::Command::Base::Cron
  class << self
    def check_has_entry(user, entry)
      entry_escaped = entry.gsub(/\*/, '\\*').gsub(/\[/, '\\[').gsub(/\]/, '\\]').gsub(/\%/, '\\%')
      if user.nil?
        "crontab -l | grep -- #{escape(entry_escaped)}"
      else
        "crontab -l #{escape(user)} | grep -- #{escape(entry_escaped)}"
      end
    end
  end
end

class Specinfra::Command::Base::Cron < Specinfra::Command::Base
  class << self
    def check_has_entry(user, entry)
      entry_escaped = entry.gsub(/\*/, '\\*').gsub(/\[/, '\\[').gsub(/\]/, '\\]')
      if user.nil?
        "crontab -l | grep -v \"#\" -- | grep -- #{escape(entry_escaped)}"
      else
        "crontab -u #{escape(user)} -l | grep -v \"#\" | grep -- #{escape(entry_escaped)}"
      end
    end
  end
end

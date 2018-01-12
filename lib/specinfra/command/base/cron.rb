class Specinfra::Command::Base::Cron < Specinfra::Command::Base
  class << self
    def check_has_entry(user, entry)
      entry_escaped = entry.gsub(/\\/, '\\\\\\').gsub(/\*/, '\\*').gsub(/\[/, '\\[').gsub(/\]/, '\\]')
      grep_command = "grep -v '^[[:space:]]*#' | grep -- ^#{escape(entry_escaped)}$"
      if user.nil?
        "crontab -l | #{grep_command}"
      else
        "crontab -u #{escape(user)} -l | #{grep_command}"
      end
    end

    def get_table
      'cat /etc/cron.d/* /etc/crontab /var/spool/cron/* /var/spool/cron/crontabs/* 2> /dev/null'
    end
  end
end

class Specinfra::Command::Base::Cron < Specinfra::Command::Base
  class << self
    def check_has_entry(user, entry)
      if entry.is_a? Regexp
        grep_expr = entry.to_s
        grep_opt = '-P'
      else
        entry_escaped = entry.gsub(/\*/, '\\*').gsub(/\[/, '\\[').gsub(/\]/, '\\]')
        grep_expr = "^#{escape(entry_escaped)}$"
        grep_opt = ''
      end
      grep_command = "grep -v '^[[:space:]]*#' | grep #{grep_opt} -- '#{grep_expr}'"
      if user.nil?
        "crontab -l | #{grep_command}"
      else
        "crontab -u #{escape(user)} -l | #{grep_command}"
      end
    end
  end
end

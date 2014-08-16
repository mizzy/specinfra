class Specinfra::Command::Solaris::Base::File < Specinfra::Command::Base::File
  class << self
    def check_contains_within(file, expected_pattern, from=nil, to=nil)
      from ||= '1'
      to ||= '$'
      sed = "sed -n #{escape(from)},#{escape(to)}p #{escape(file)}"
      sed_end = "sed -n 1,#{escape(to)}p"
      checker_with_regexp = check_contains_with_regexp("/dev/stdin", expected_pattern)
      checker_with_fixed  = check_contains_with_fixed_strings("/dev/stdin", expected_pattern)
      "#{sed} | #{sed_end} | #{checker_with_regexp}|| #{sed} | #{sed_end} | #{checker_with_fixed}"
    end

    def check_is_accessible_by_user(file, user, access)
      # http://docs.oracle.com/cd/E23823_01/html/816-5166/su-1m.html
      ## No need for login shell as it seems that behavior as superuser is favorable for us, but needs
      ## to be better tested under real solaris env
      "su #{user} -c \"test -#{access} #{file}\""
    end
  end
end

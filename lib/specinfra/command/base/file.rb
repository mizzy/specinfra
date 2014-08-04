class Specinfra::Command::Base::File < Specinfra::Command::Base
  class << self
    def check_is_file(file)
      "test -f #{escape(file)}"
    end

    def check_is_directory(directory)
      "test -d #{escape(directory)}"
    end

    def check_is_socket(file)
      "test -S #{escape(file)}"
    end

    def check_contains(file, expected_pattern)
      "#{check_file_contains_with_regexp(file, expected_pattern)} || #{check_file_contains_with_fixed_strings(file, expected_pattern)}"
    end

    def check_is_grouped(file, group)
      regexp = "^#{group}$"
      "stat -c %G #{escape(file)} | grep -- #{escape(regexp)}"
    end

    def check_is_owned_by(file, owner)
      regexp = "^#{owner}$"
      "stat -c %U #{escape(file)} | grep -- #{escape(regexp)}"
    end

    def check_has_mode(file, mode)
      regexp = "^#{mode}$"
      "stat -c %a #{escape(file)} | grep -- #{escape(regexp)}"
    end

    def check_contains_within(file, expected_pattern, from=nil, to=nil)
      from ||= '1'
      to ||= '$'
      sed = "sed -n #{escape(from)},#{escape(to)}p #{escape(file)}"
      checker_with_regexp = check_file_contains_with_regexp("-", expected_pattern)
      checker_with_fixed  = check_file_contains_with_fixed_strings("-", expected_pattern)
      "#{sed} | #{checker_with_regexp} || #{sed} | #{checker_with_fixed}"
    end

    def check_contains_lines(file, expected_lines, from=nil, to=nil)
      require 'digest/md5'
      from ||= '1'
      to ||= '$'
      sed = "sed -n #{escape(from)},#{escape(to)}p #{escape(file)}"
      head_line = expected_lines.first.chomp
      lines_checksum = Digest::MD5.hexdigest(expected_lines.map(&:chomp).join("\n") + "\n")
      afterwards_length = expected_lines.length - 1
      "#{sed} | grep -A #{escape(afterwards_length)} -F -- #{escape(head_line)} | md5sum | grep -qiw -- #{escape(lines_checksum)}"
    end

    def check_contains_with_regexp(file, expected_pattern)
      "grep -q -- #{escape(expected_pattern)} #{escape(file)}"
    end

    def check_contains_with_fixed_strings(file, expected_pattern)
      "grep -qF -- #{escape(expected_pattern)} #{escape(file)}"
    end

    def check_has_md5checksum(file, expected)
      regexp = "^#{expected}"
      "md5sum #{escape(file)} | grep -iw -- #{escape(regexp)}"
    end

    def check_has_sha256checksum(file, expected)
      regexp = "^#{expected}"
      "sha256sum #{escape(file)} | grep -iw -- #{escape(regexp)}"
    end

    def get_content(file)
      "cat #{file} 2> /dev/null || echo -n"
    end

    def check_is_mounted(path)
      regexp = "on #{path}"
      "mount | grep -w -- #{escape(regexp)}"
    end

    def get_mode(file)
      "stat -c %a #{escape(file)}"
    end

    def check_is_linked_to(link, target)
      "stat -c %N #{escape(link)} | egrep -e \"-> .#{escape(target)}.\""
    end

    def get_mtime(file)
      "stat -c %Y #{escape(file)}"
    end

    def get_size(file)
      "stat -c %s #{escape(file)}"
    end

    def change_mode(file, mode)
      "chmod #{mode} #{escape(file)}"
    end

    def change_owner(file, owner, group=nil)
      owner = "#{owner}:#{group}" if group
      "chown #{owner} #{escape(file)}"
    end

    def change_group(file, group)
      "chgrp #{group} #{escape(file)}"
    end
  end
end

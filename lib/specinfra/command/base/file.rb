class Specinfra::Command::Base::File < Specinfra::Command::Base
  def check_is_file(file)
    "test -f #{escape(file)}"
  end

  def check_is_directory(directory)
    "test -d #{escape(directory)}"
  end

  def check_is_socket(file)
    "test -S #{escape(file)}"
  end

  def check_contain(file, expected_pattern)
    "#{check_file_contain_with_regexp(file, expected_pattern)} || #{check_file_contain_with_fixed_strings(file, expected_pattern)}"
  end

  def check_is_grouped(file, group)
    regexp = "^#{group}$"
    "stat -c %G #{escape(file)} | grep -- #{escape(regexp)}"
  end

  def check_is_owned_by(file, owner)
    regexp = "^#{owner}$"
    "stat -c %U #{escape(file)} | grep -- #{escape(regexp)}"
  end

  def check_mode(file, mode)
    regexp = "^#{mode}$"
    "stat -c %a #{escape(file)} | grep -- #{escape(regexp)}"
  end

  def check_contain_within(file, expected_pattern, from=nil, to=nil)
    from ||= '1'
    to ||= '$'
    sed = "sed -n #{escape(from)},#{escape(to)}p #{escape(file)}"
    checker_with_regexp = check_file_contain_with_regexp("-", expected_pattern)
    checker_with_fixed  = check_file_contain_with_fixed_strings("-", expected_pattern)
    "#{sed} | #{checker_with_regexp} || #{sed} | #{checker_with_fixed}"
  end

  def check_contain_lines(file, expected_lines, from=nil, to=nil)
    require 'digest/md5'
    from ||= '1'
    to ||= '$'
    sed = "sed -n #{escape(from)},#{escape(to)}p #{escape(file)}"
    head_line = expected_lines.first.chomp
    lines_checksum = Digest::MD5.hexdigest(expected_lines.map(&:chomp).join("\n") + "\n")
    afterwards_length = expected_lines.length - 1
    "#{sed} | grep -A #{escape(afterwards_length)} -F -- #{escape(head_line)} | md5sum | grep -qiw -- #{escape(lines_checksum)}"
  end

  def check_contain_with_regexp(file, expected_pattern)
    "grep -q -- #{escape(expected_pattern)} #{escape(file)}"
  end

  def check_contain_with_fixed_strings(file, expected_pattern)
    "grep -qF -- #{escape(expected_pattern)} #{escape(file)}"
  end

  def check_md5checksum(file, expected)
    regexp = "^#{expected}"
    "md5sum #{escape(file)} | grep -iw -- #{escape(regexp)}"
  end

  def check_sha256checksum(file, expected)
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

  def check_access_by_user(file, user, access)
    raise NotImplementedError.new
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
end

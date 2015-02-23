class Specinfra::Command::Base::File < Specinfra::Command::Base
  class << self
    def check_is_file(file)
      "test -f #{escape(file)}"
    end

    def check_is_directory(directory)
      "test -d #{escape(directory)}"
    end

    def check_is_pipe(file)
      "test -p #{escape(file)}"
    end

    def check_is_socket(file)
      "test -S #{escape(file)}"
    end

    def check_is_symlink(file)
      "test -L #{escape(file)}"
    end

    def check_contains(file, expected_pattern)
      "#{check_contains_with_regexp(file, expected_pattern)} || #{check_contains_with_fixed_strings(file, expected_pattern)}"
    end

    def check_is_grouped(file, group)
      regexp = "^#{group}$"
      if group.is_a?(Numeric) || (group =~ /\A\d+\z/ ? true : false)
        "stat -c %g #{escape(file)} | grep -- #{escape(regexp)}"
      else
        "stat -c %G #{escape(file)} | grep -- #{escape(regexp)}"
      end
    end

    def check_is_owned_by(file, owner)
      regexp = "^#{owner}$"
      if owner.is_a?(Numeric) || (owner =~ /\A\d+\z/ ? true : false)
        "stat -c %u #{escape(file)} | grep -- #{escape(regexp)}"
      else
        "stat -c %U #{escape(file)} | grep -- #{escape(regexp)}"
      end
    end

    def check_has_mode(file, mode)
      regexp = "^#{mode}$"
      "stat -c %a #{escape(file)} | grep -- #{escape(regexp)}"
    end

    def check_contains_within(file, expected_pattern, from=nil, to=nil)
      from ||= '1'
      to ||= '$'
      sed = "sed -n #{escape(from)},#{escape(to)}p #{escape(file)}"
      sed += " | sed -n 1,#{escape(to)}p" if from != '1' and to != '$'
      checker_with_regexp = check_contains_with_regexp("-", expected_pattern)
      checker_with_fixed = check_contains_with_fixed_strings("-", expected_pattern)
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
      "grep -qs -- #{escape(expected_pattern)} #{escape(file)}"
    end

    def check_contains_with_fixed_strings(file, expected_pattern)
      "grep -qFs -- #{escape(expected_pattern)} #{escape(file)}"
    end

    def get_md5sum(file)
      "md5sum #{escape(file)} | cut -d ' ' -f 1"
    end

    def get_sha256sum(file)
      "sha256sum #{escape(file)} | cut -d ' ' -f 1"
    end

    def get_content(file)
      "cat #{escape(file)} 2> /dev/null || echo -n"
    end

    def check_is_mounted(path)
      regexp = "on #{path} "
      "mount | grep -- '#{escape(regexp)}'"
    end

    def get_mode(file)
      "stat -c %a #{escape(file)}"
    end

    def get_owner_user(file)
      "stat -c %U #{escape(file)}"
    end

    def get_owner_group(file)
      "stat -c %G #{escape(file)}"
    end

    def check_is_linked_to(link, target)
      "stat -c %N #{escape(link)} | egrep -e \"-> .#{escape(target)}.\""
    end

    def check_is_link(link)
      "test -L #{escape(link)}"
    end

    def get_link_target(link)
      "readlink -f #{escape(link)}"
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

    def create_as_directory(file)
      "mkdir -p #{escape(file)}"
    end

    def copy(src, dest)
      "cp #{escape(src)} #{escape(dest)}"
    end

    def move(src, dest)
      "mv #{escape(src)} #{escape(dest)}"
    end

    def link_to(link, target)
      "ln -s #{escape(target)} #{escape(link)}"
    end

    def remove(file)
      "rm -rf #{escape(file)}"
    end
  end
end

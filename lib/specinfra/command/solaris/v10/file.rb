class Specinfra::Command::Solaris::V10::File < Specinfra::Command::Solaris::Base::File
  class << self
    # reference: http://perldoc.perl.org/functions/stat.html
    def check_has_mode(file, mode)
      regexp = "^#{mode}$"
      "perl -e 'printf \"%o\", (stat shift)[2]&07777' #{escape(file)}  | grep -- #{escape(regexp)}"
    end

    # reference: http://perldoc.perl.org/functions/stat.html
    #            http://www.tutorialspoint.com/perl/perl_getpwuid.htm
    def check_is_owned_by(file, owner)
      regexp = "^#{owner}$"
      "perl -e 'printf \"%s\", getpwuid((stat(\"#{escape(file)}\"))[4])' | grep -- #{escape(regexp)}"
    end

    # reference: http://perldoc.perl.org/functions/stat.html
    #            http://www.tutorialspoint.com/perl/perl_getgrgid.htm
    def check_is_grouped(file, group)
      regexp = "^#{group}$"
      "perl -e 'printf \"%s\", getgrgid((stat(\"#{escape(file)}\"))[5])'  | grep -- #{escape(regexp)}"
    end

    # reference: http://www.tutorialspoint.com/perl/perl_readlink.htm
    def check_is_linked_to(link, target)
      regexp = "^#{target}$"
      "perl -e 'printf \"%s\", readlink(\"#{escape(link)}\")' | grep -- #{escape(regexp)}"
    end

    def check_contain(file, expected_pattern)
      "grep -- #{escape(expected_pattern)} #{escape(file)}"
    end

    def get_md5sum(file)
      "digest -a md5 -v #{escape(file)} | cut -d '=' -f 2 |  cut -c 2-"
    end

    # reference: http://perldoc.perl.org/functions/stat.html
    def get_mode(file)
      "perl -e 'printf \"%o\", (stat shift)[2]&07777' #{escape(file)}"
    end
  end
end

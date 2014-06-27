module Specinfra
  module Helper
    %w(Base AIX Arch Darwin Debian Fedora FreeBSD FreeBSD10
       Gentoo NixOS OpenBSD Plamo RedHat RedHat7 SuSE OpenSUSE
       SmartOS Solaris Solaris10 Solaris11 Ubuntu Windows).each do |os|
      eval <<-EOF
        module #{os}
          def commands
            Specinfra::Command::#{os}.new
          end
        end
      EOF
    end
  end
end

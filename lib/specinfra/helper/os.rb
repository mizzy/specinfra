module SpecInfra
  module Helper
    [
      'Base',
      'AIX',
      'Arch',
      'Darwin',
      'Debian',
      'Fedora',
      'FreeBSD',
      'FreeBSD10',
      'Gentoo',
      'NixOS',
      'OpenBSD',
      'Plamo',
      'RedHat',
      'RedHat7',
      'SuSE',
      'OpenSUSE',
      'SmartOS',
      'Solaris',
      'Solaris10',
      'Solaris11',
      'Ubuntu',
      'Windows',
    ].each do |os|
      eval <<-EOF
        module #{os}
          def commands
            SpecInfra::Command::#{os}.new
          end
        end
      EOF
    end
  end
end

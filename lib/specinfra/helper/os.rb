module SpecInfra
  module Helper
    [
      'Base',
      'AIX',
      'Arch',
      'Darwin',
      'Debian',
      'FreeBSD',
      'FreeBSD10',
      'Gentoo',
      'OpenBSD',
      'Plamo',
      'RedHat',
      'RedHat7',
      'SuSE',
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

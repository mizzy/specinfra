module SpecInfra
  module Helper
    [
     'Base',
     'AIX',
     'Darwin',
     'Debian',
     'FreeBSD',
     'Gentoo',
     'Plamo',
     'RedHat',
     'SmartOS',
     'Solaris',
     'Solaris10',
     'Solaris11',
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

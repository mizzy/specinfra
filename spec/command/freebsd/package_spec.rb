require 'spec_helper'


describe 'command/freebsd/package works correctly' do
  before do
    property[:os] = nil
  end

  context 'freebsd-base' do
    before do
      set :os, :family => 'freebsd'
    end
    describe 'get_command(:check_package_is_installed, "figlet")' do
      it { expect(get_command(:check_package_is_installed, 'figlet')).to match /^pkg +info +-e +figlet$/ }
    end
    describe 'get_command(:check_package_is_installed, "figlet", "1.2.3")' do
      it { expect(get_command(:check_package_is_installed, 'figlet', '1.2.3')).to match /^pkg +query +%v +figlet *\| *grep -- 1.2.3$/ }
    end
    describe 'get_command(:install_package, "figlet")' do
      it { expect(get_command(:install_package, 'figlet')).to match /^pkg +install +-y +figlet$/ }
    end
  end

  context 'freebsd-6' do
    before do
      set :os, :family => 'freebsd', :release => '6'
    end
    describe 'get_command(:check_package_is_installed, "figlet")' do
      it { expect(get_command(:check_package_is_installed, 'figlet')).to match /^pkg_info +-Ix +figlet$/ }
    end
    describe 'get_command(:check_package_is_installed, "figlet", "1.2.3")' do
      it { expect(get_command(:check_package_is_installed, 'figlet', '1.2.3')).to match /^pkg_info +-I +figlet-1.2.3$/ }
    end
    describe 'get_command(:install_package, "figlet")' do
      it { expect(get_command(:install_package, 'figlet')).to match /^pkg_add +-r +figlet$/ }
    end
  end

  context 'freebsd-7' do
    before do
      set :os, :family => 'freebsd', :release => '7'
    end
    describe 'get_command(:check_package_is_installed, "figlet")' do
      it { expect(get_command(:check_package_is_installed, 'figlet')).to match /^pkg_info +-Ix +figlet$/ }
    end
    describe 'get_command(:check_package_is_installed, "figlet", "1.2.3")' do
      it { expect(get_command(:check_package_is_installed, 'figlet', '1.2.3')).to match /^pkg_info +-I +figlet-1.2.3$/ }
    end
    describe 'get_command(:install_package, "figlet")' do
      it { expect(get_command(:install_package, 'figlet')).to match /^pkg_add +-r +figlet$/ }
    end
  end

  context 'freebsd-8' do
    before do
      set :os, :family => 'freebsd', :release => '8'
    end
    let(:cond) do
      %r{TMPDIR=/dev/null +ASSUME_ALWAYS_YES=1 +PACKAGESITE=file:///nonexist +pkg +info +-x +'pkg\(-devel\)\?\$' *> */dev/null +2>&1}
    end
    describe 'get_command(:check_package_is_installed, "figlet")' do
      st = /pkg +info +-e +figlet/
      sf = /pkg_info +-Ix +\\\^figlet-\\\[0-9\\\]\\\[0-9a-zA-Z_\.,\\\]\\\*\\\$/
      it { expect(get_command(:check_package_is_installed, 'figlet')).
           to match /^if +#{cond} *; *then +#{st} *; *else +#{sf} *; *fi$/ }
    end
    describe 'get_command(:check_package_is_installed, "figlet", "1.2.3")' do
      st = /pkg +query +%v +figlet *\| *grep -- 1.2.3/
      sf = /pkg_info +-I +figlet-1.2.3/
      it { expect(get_command(:check_package_is_installed, 'figlet', '1.2.3')).
           to match /^if +#{cond} *; *then +#{st} *; *else +#{sf} *; *fi$/ }
    end
    describe 'get_command(:install_package, "figlet")' do
      st = /pkg +install +-y +figlet/
      sf = /pkg_add +-r +figlet/
      it { expect(get_command(:install_package, 'figlet')).
           to match /^if +#{cond} *; *then +#{st} *; *else +#{sf} *; *fi$/ }
    end
    describe 'get_command(:get_package_version, "figlet")' do
      st = /pkg +query +%v +figlet/
      sf = /pkg_info +-Ix +\\\^figlet-\\\[0-9\\\]\\\[0-9a-zA-Z_\.,\\\]\\\*\\\$ *\| *cut +-f +1 +-w *\| *sed +-n +'s\/\^figlet-\/\/p'/
      it { expect(get_command(:get_package_version, 'figlet')).
           to match /if +#{cond} *; *then +#{st} *; *else +#{sf} *; *fi/ }
    end
  end

  context 'freebsd-9' do
    before do
      set :os, :family => 'freebsd', :release => '9'
    end
    let(:cond) do
      %r{TMPDIR=/dev/null +ASSUME_ALWAYS_YES=1 +PACKAGESITE=file:///nonexist +pkg +info +-x +'pkg\(-devel\)\?\$' *> */dev/null +2>&1}
    end
    describe 'get_command(:check_package_is_installed, "figlet")' do
      st = /pkg +info +-e +figlet/
      sf = /pkg_info +-Ix +\\\^figlet-\\\[0-9\\\]\\\[0-9a-zA-Z_\.,\\\]\\\*\\\$/
      it { expect(get_command(:check_package_is_installed, 'figlet')).
           to match /^if +#{cond} *; *then +#{st} *; *else +#{sf} *; *fi$/ }
    end
    describe 'get_command(:check_package_is_installed, "figlet", "1.2.3")' do
      st = /pkg +query +%v +figlet *\| *grep -- 1.2.3/
      sf = /pkg_info +-I +figlet-1.2.3/
      it { expect(get_command(:check_package_is_installed, 'figlet', '1.2.3')).
           to match /^if +#{cond} *; *then +#{st} *; *else +#{sf} *; *fi$/ }
    end
    describe 'get_command(:install_package, "figlet")' do
      st = /pkg +install +-y +figlet/
      sf = /pkg_add +-r +figlet/
      it { expect(get_command(:install_package, 'figlet')).
           to match /^if +#{cond} *; *then +#{st} *; *else +#{sf} *; *fi$/ }
    end
    describe 'get_command(:get_package_version, "figlet")' do
      st = /pkg +query +%v +figlet/
      sf = /pkg_info +-Ix +\\\^figlet-\\\[0-9\\\]\\\[0-9a-zA-Z_\.,\\\]\\\*\\\$ *\| *cut +-f +1 +-w *\| *sed +-n +'s\/\^figlet-\/\/p'/
      it { expect(get_command(:get_package_version, 'figlet')).
           to match /if +#{cond} *; *then +#{st} *; *else +#{sf} *; *fi/ }
    end
  end

  context 'freebsd-10' do
    before do
      set :os, :family => 'freebsd', :release => '10'
    end
    describe 'get_command(:check_package_is_installed, "figlet")' do
      it { expect(get_command(:check_package_is_installed, 'figlet')).to match /^pkg +info +-e +figlet$/ }
    end
    describe 'get_command(:check_package_is_installed, "figlet", "1.2.3")' do
      it { expect(get_command(:check_package_is_installed, 'figlet', '1.2.3')).to match /^pkg +query +%v +figlet *\| *grep -- 1.2.3$/ }
    end
    describe 'get_command(:install_package, "figlet")' do
      it { expect(get_command(:install_package, 'figlet')).to match /^pkg +install +-y +figlet$/ }
    end
  end

  context 'freebsd-11' do
    before do
      set :os, :family => 'freebsd', :release => '11'
    end
    describe 'get_command(:check_package_is_installed, "figlet")' do
      it { expect(get_command(:check_package_is_installed, 'figlet')).to match /^pkg +info +-e +figlet$/ }
    end
    describe 'get_command(:check_package_is_installed, "figlet", "1.2.3")' do
      it { expect(get_command(:check_package_is_installed, 'figlet', '1.2.3')).to match /^pkg +query +%v +figlet *\| *grep -- 1.2.3$/ }
    end
    describe 'get_command(:install_package, "figlet")' do
      it { expect(get_command(:install_package, 'figlet')).to match /^pkg +install +-y +figlet$/ }
    end
  end
end

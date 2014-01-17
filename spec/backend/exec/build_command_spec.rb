require 'spec_helper'

include SpecInfra::Helper::Exec

describe SpecInfra::Backend::Exec do
  describe '#build_command' do
    context 'with simple command' do
      it 'should escape spaces' do
        expect(backend.build_command('test -f /etc/passwd')).to eq '/bin/sh -c test\ -f\ /etc/passwd'
      end
    end

    context 'with complex command' do
      it 'should escape special chars' do
        expect(backend.build_command('test ! -f /etc/selinux/config || (getenforce | grep -i -- disabled && grep -i -- ^SELINUX=disabled$ /etc/selinux/config)')).to eq '/bin/sh -c test\ \!\ -f\ /etc/selinux/config\ \|\|\ \(getenforce\ \|\ grep\ -i\ --\ disabled\ \&\&\ grep\ -i\ --\ \^SELINUX\=disabled\$\ /etc/selinux/config\)'
      end
    end

    context 'with custom shell' do
      before do
        RSpec.configure {|c| c.shell = '/usr/local/bin/tcsh' }
      end

      after do
        RSpec.configure {|c| c.shell = nil }
      end

      it 'should use custom shell' do
        expect(backend.build_command('test -f /etc/passwd')).to eq '/usr/local/bin/tcsh -c test\ -f\ /etc/passwd'
      end
    end

    context 'with custom shell that needs escaping' do
      before do
        RSpec.configure {|c| c.shell = '/usr/test & spec/bin/sh' }
      end

      after do
        RSpec.configure {|c| c.shell = nil }
      end

      it 'should use custom shell' do
        expect(backend.build_command('test -f /etc/passwd')).to eq '/usr/test\ \&\ spec/bin/sh -c test\ -f\ /etc/passwd'
      end
    end

    context 'with custom path' do
      before do
        RSpec.configure {|c| c.path = '/opt/bin:/opt/foo/bin' }
      end

      after do
        RSpec.configure {|c| c.path = nil }
      end

      it 'should use custom path' do
        expect(backend.build_command('test -f /etc/passwd')).to eq 'env PATH=/opt/bin:/opt/foo/bin:"$PATH" /bin/sh -c test\ -f\ /etc/passwd'
      end
    end

    context 'with custom path that needs escaping' do
      before do
        RSpec.configure {|c| c.path = '/opt/bin:/opt/test & spec/bin' }
      end

      after do
        RSpec.configure {|c| c.path = nil }
      end

      it 'should use custom path' do
        expect(backend.build_command('test -f /etc/passwd')).to eq 'env PATH=/opt/bin:/opt/test\ \&\ spec/bin:"$PATH" /bin/sh -c test\ -f\ /etc/passwd'
      end
    end
  end
end


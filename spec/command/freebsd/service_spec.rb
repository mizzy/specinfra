require 'spec_helper'

describe 'command/freebsd/service works correctly' do
  before do
    property[:os] = nil
  end

  context 'freebsd-base' do
    before do
      set :os, :family => 'freebsd'
    end
    describe 'get_command(:check_service_is_enabled, "httpd")' do
      it { expect(get_command(:check_service_is_enabled, 'httpd')).to eq 'service httpd enabled' }
    end
  end

  context 'freebsd-6' do
    before do
      set :os, :family => 'freebsd', :release => '6'
    end
    describe 'get_command(:check_service_is_enabled, "httpd")' do
      it { expect(get_command(:check_service_is_enabled, 'httpd')).to eq 'service -e | grep -- /httpd$' }
    end
  end

  context 'freebsd-7' do
    before do
      set :os, :family => 'freebsd', :release => '7'
    end
    describe 'get_command(:check_service_is_enabled, "httpd")' do
      it { expect(get_command(:check_service_is_enabled, 'httpd')).to eq 'service -e | grep -- /httpd$' }
    end
  end

  context 'freebsd-8' do
    before do
      set :os, :family => 'freebsd', :release => '8'
    end
    describe 'get_command(:check_service_is_enabled, "httpd")' do
      it { expect(get_command(:check_service_is_enabled, 'httpd')).to eq 'service -e | grep -- /httpd$' }
    end
  end

  context 'freebsd-9' do
    before do
      set :os, :family => 'freebsd', :release => '9'
    end
    describe 'get_command(:check_service_is_enabled, "httpd")' do
      it { expect(get_command(:check_service_is_enabled, 'httpd')).to eq 'service -e | grep -- /httpd$' }
    end
  end

  context 'freebsd-10' do
    before do
      set :os, :family => 'freebsd', :release => '10'
    end
    describe 'get_command(:check_service_is_enabled, "httpd")' do
      it { expect(get_command(:check_service_is_enabled, 'httpd')).to eq 'service httpd enabled' }
    end
  end

  context 'freebsd-11' do
    before do
      set :os, :family => 'freebsd', :release => '11'
    end
    describe 'get_command(:check_service_is_enabled, "httpd")' do
      it { expect(get_command(:check_service_is_enabled, 'httpd')).to eq 'service httpd enabled' }
    end
  end
end


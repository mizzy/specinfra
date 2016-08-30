require 'spec_helper'
require 'specinfra/helper/detect_os/debian'

describe Specinfra::Helper::DetectOs::Debian do
  darwin = Specinfra::Helper::DetectOs::Debian.new(Specinfra.backend)

  it 'Should return debian 8.5 when jessie is installed.' do
    allow(debian).to receive(:run_command).with('cat /etc/debian_version') {
      CommandResult.new(:stdout => "8.5\n", :exit_status => 0)
    }
    expect(darwin.detect).to include(
      :family  => 'debian',
      :release => '8.5'
    )
  end
end


require 'spec_helper'
require 'specinfra/helper/detect_os/suse'

describe Specinfra::Helper::DetectOs::Suse do
  suse = Specinfra::Helper::DetectOs::Suse.new(:exec)
  it 'Should return opensuse 13 when openSUSE 13.2 is installed.' do
    allow(suse).to receive(:run_command) {
        CommandResult.new(:stdout => 'openSUSE 13.2 (x86_64)', :exit_status => 0)
    }
    expect(suse.detect).to include(
      :family  => 'opensuse',
      :release => '13.2'
    )
  end
  it 'Should return sles 12 when SUSE Linux Enterprise Server 12 is installed.' do
    allow(suse).to receive(:run_command) {
      CommandResult.new(:stdout => 'SUSE Linux Enterprise Server 12', :exit_status => 0)
    }
    expect(suse.detect).to include(
      :family  => 'sles',
      :release => '12'
    )
  end
end

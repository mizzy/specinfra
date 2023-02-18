require 'spec_helper'
require 'specinfra/helper/detect_os/guix'

describe Specinfra::Helper::DetectOs::Guix do
  guix = Specinfra::Helper::DetectOs::Guix.new(:exec)
  it 'Should return guix when Guix is installed.' do
    allow(guix).to receive(:run_command) {
      CommandResult.new(:stdout => "NAME=\"Guix System\" \nID=guix\nPRETTY_NAME=\"Guix System\" \nLOGO=guix-icon\nHOME_URL=\"https://guix.gnu.org\" \nDOCUMENTATION_URL=\"https://guix.gnu.org/en/manual\" \nSUPPORT_URL=\"https://guix.gnu.org/en/help\" \nBUG_REPORT_URL=\"https://lists.gnu.org/mailman/listinfo/bug-guix\"", :exit_status => 0)
    }
    expect(guix.detect).to include(
      :family => 'guix',
      :release => nil
    )
  end
end

require 'spec_helper'
require 'specinfra/helper/detect_os/suse'

describe Specinfra::Helper::DetectOs::Suse do
  suse = Specinfra::Helper::DetectOs::Suse.new(:exec)
  it 'Should return opensuse 42.2 when openSUSE 42.2 is installed.' do
    allow(suse).to receive(:run_command) {
        CommandResult.new(:stdout => "NAME=\"openSUSE Leap\"\nVERSION=\"42.2\"\nID=opensuse\nID_LIKE=\"suse\"\nVERSION_ID=\"42.2\"\nPRETTY_NAME=\"openSUSE Leap 42.2\"\nANSI_COLOR=\"0;32\"\nCPE_NAME=\"cpe:/o:opensuse:leap:42.2\"\nBUG_REPORT_URL=\"https://bugs.opensuse.org\"\nHOME_URL=\"https://www.opensuse.org/\"\n", :exit_status => 0)
    }
    expect(suse.detect).to include(
      :family  => 'opensuse',
      :release => '42.2'
    )
  end
  it 'Should return opensuse 13.2 when openSUSE 13.2 is installed.' do
    allow(suse).to receive(:run_command) {
        CommandResult.new(:stdout => "NAME=openSUSE\nVERSION=\"13.2 (Harlequin)\"\nVERSION_ID=\"13.2\"\nPRETTY_NAME=\"openSUSE 13.2 (Harlequin) (x86_64)\"\nID=opensuse\nANSI_COLOR=\"0;32\"\nCPE_NAME=\"cpe:/o:opensuse:opensuse:13.2\"\nBUG_REPORT_URL=\"https://bugs.opensuse.org\"\nHOME_URL=\"https://opensuse.org/\"\nID_LIKE=\"suse\"\n", :exit_status => 0)
    }
    expect(suse.detect).to include(
      :family  => 'opensuse',
      :release => '13.2'
    )
  end
  it 'Should return sles 12.2 when SUSE Linux Enterprise Server 12.2 is installed.' do
    allow(suse).to receive(:run_command) {
      CommandResult.new(:stdout => "NAME=\"SLES\"\nVERSION=\"12.2\"\nVERSION_ID=\"12.2\"\nPRETTY_NAME=\"SUSE Linux Enterprise Server 12\"\nID=\"sles\"\nANSI_COLOR=\"0;32\"\nCPE_NAME=\"cpe:/o:suse:sles:12\"\n", :exit_status => 0)
    }
    expect(suse.detect).to include(
      :family  => 'sles',
      :release => '12.2'
    )
  end
  it 'Should return sles 11.4 when SUSE Linux Enterprise Server 11.4 is installed.' do
    allow(suse).to receive(:run_command) {
      CommandResult.new(:stdout => "NAME=\"SLES\"\nVERSION=\"11.4\"\nVERSION_ID=\"11.4\"\nPRETTY_NAME=\"SUSE Linux Enterprise Server 11 SP4\"\nID=\"sles\"\nANSI_COLOR=\"0;32\"\nCPE_NAME=\"cpe:/o:suse:sles:11:4\"", :exit_status => 0)
    }
    expect(suse.detect).to include(
      :family  => 'sles',
      :release => '11.4'
    )
  end
end

require 'spec_helper'

## Output from 'df -k'
str = <<-EOH
Filesystem     1K-blocks      Used Available Use% Mounted on
none             4015168         0   4015168   0% /dev
/dev/sda3      235797392 184584640  39162064  83% /
/dev/sda1         523248      3640    519608   1% /boot/efi
tmpfs            4025296      1052   4024244   1% /dev/shm
none             4025292        44   4025248   1% /run/systemd
none             4025292         0   4025292   0% /run/user
cgroup           4025292         0   4025292   0% /sys/fs/cgroup
none             4025292         0   4025292   0% /var/cache/fontconfig
none             4025292       684   4024608   1% /var/lib/gdm
tmpfs             805056        44    805012   1% /run/user/1000
EOH

describe Specinfra::HostInventory::Filesystem do
  let(:host_inventory) { nil }
  describe 'Example of Guix' do
    ret = Specinfra::HostInventory::Filesystem.new(host_inventory).parse(str)
    example "/dev/sda3" do
      expect(ret["/dev/sda3"]).to include(
        "kb_available" => "39162064",
        "kb_size"      => "235797392",
        "mount"        => "/",
        "percent_used" => "83%",
        "kb_used"      => "184584640"
      )
    end
    example "/dev/sda1" do
      expect(ret["/dev/sda1"]).to include(
        "kb_available" => "519608",
        "kb_size"      => "523248",
        "mount"        => "/boot/efi",
        "percent_used" => "1%",
        "kb_used"      => "3640"
      )
    end
    example "cgroup" do
      expect(ret["cgroup"]).to include(
        "kb_available" => "4025292",
        "kb_size"      => "4025292",
        "mount"        => "/sys/fs/cgroup",
        "percent_used" => "0%",
        "kb_used"      => "0"
      )
    end
  end 
end

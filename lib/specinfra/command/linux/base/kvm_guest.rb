class Specinfra::Command::Linux::Base::KvmGuest < Specinfra::Command::Base::KvmGuest
  class << self
    def check_exists(guest)
      "virsh -c qemu:///system list --all --name | grep -w '^#{escape(guest)}$'"
    end

    def check_is_running(guest)
      "virsh -c qemu:///system list --name | grep -w '^#{escape(guest)}$'"
    end

    def check_is_enabled(guest)
      "virsh -c qemu:///system dominfo #{escape(guest)} | grep -E '^Autostart:\s+enable$'"
    end
  end
end

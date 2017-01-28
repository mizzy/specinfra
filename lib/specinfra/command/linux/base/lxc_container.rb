class Specinfra::Command::Linux::Base::LxcContainer < Specinfra::Command::Base::LxcContainer
  class << self
    def check_exists(container)
      [
       "lxc-ls -1 | grep -w #{escape(container)}",
       "virsh -c lxc:/// list --all --name | grep -w '^#{escape(container)}$'"
      ].join(' || ')
    end

    def check_is_running(container)
      [
       "lxc-info -n #{escape(container)} -s | grep -w RUNNING",
       "virsh -c lxc:/// list --all --name --state-running | grep -w '^#{escape(container)}$'"
      ].join(' || ')
    end
  end
end

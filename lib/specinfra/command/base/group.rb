class Specinfra::Command::Base::Group < Specinfra::Command::Base
  class << self
    def check_exists(group)
      "getent group #{escape(group)}"
    end

    def check_has_gid(group, gid)
      "getent group #{escape(group)} | cut -f 3 -d ':' | grep -w -- #{escape(gid)}"
    end

    def check_is_system_group(group)
      exists = "getent group #{escape(group)} > /dev/null 2>&1"
      gid = "getent group #{escape(group)} | cut -f 3 -d ':'"
      sys_gid_min = "awk 'BEGIN{sys_gid_min=101} {if($1~/^SYS_GID_MIN/){sys_gid_min=$2}} END{print sys_gid_min}' /etc/login.defs"
      sys_gid_max = "awk 'BEGIN{sys_gid_max=0;gid_min=1000} {if($1~/^SYS_GID_MAX/){sys_gid_max=$2}if($1~/^GID_MIN/){gid_min=$2}} END{if(sys_gid_max!=0){print sys_gid_max}else{print gid_min-1}}' /etc/login.defs"
      %Q|#{exists} && test "$(#{gid})" -ge "$(#{sys_gid_min})" && test "$(#{gid})" -le "$(#{sys_gid_max})"|
    end

    def get_gid(group)
      "getent group #{escape(group)} | cut -f 3 -d ':'"
    end

    def update_gid(group, gid)
      "groupmod -g #{escape(gid)} #{escape(group)}"
    end

    def add(group, options)
      command = ['groupadd']
      command << '-g' << escape(options[:gid])  if options[:gid]
      command << '-r' if options[:system_group]
      command << escape(group)
      command.join(' ')
    end
  end
end

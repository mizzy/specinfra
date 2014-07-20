class Specinfra::Command::Aix::Base::Group < Specinfra::Command::Base::Group
  def check_has_gid(group, gid)
    regexp = "^#{group}"
    "cat etc/group | grep -w -- #{escape(regexp)} | cut -f 3 -d ':' | grep -w -- #{escape(gid)}"
  end
end

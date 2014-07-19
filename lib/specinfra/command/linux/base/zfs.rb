class Specinfra::Command::Linux::Base::Zfs < Specinfra::Command::Base::Zfs
  def check_exists(zfs)
      "zfs list -H #{escape(zfs)}"
  end

  def check_has_property(zfs, property=nil)
    commands = []
    property.sort.each do |key, value|
      regexp = "^#{value}$"
      commands << "zfs list -H -o #{escape(key)} #{escape(zfs)} | grep -- #{escape(regexp)}"
    end
    commands.join(' && ')
  end
end

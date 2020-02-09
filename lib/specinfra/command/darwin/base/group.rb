class Specinfra::Command::Darwin::Base::Group < Specinfra::Command::Base::Group
  class << self

    def get_gid(group)
      "dscl . -read /Groups/#{escape(group)} PrimaryGroupID | awk '{ print $2 }'" 
    end

    def update_gid(group, gid)
      "dscl . -create /Groups/#{escape(group)} PrimaryGroupID #{escape(gid)}"
    end
    def add(group, options)
      group_name = escape(group)
                      
      record_path = "/Groups/#{group_name}"
      dscl_create = "dscl . -create #{record_path}"
      command = [dscl_create]
      command << "#{dscl_create} PrimaryGroupID #{escape(options[:gid])}"    if options[:gid]
      command << "#{dscl_create} RecordName #{escape(options[:groupname])}"  if options[:groupname]
      command.join(' && ')
    end
  end
end

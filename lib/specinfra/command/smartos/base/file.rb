class Specinfra::Command::Smartos::Base::File < Specinfra::Command::Solaris::Base::File
  class << self
    def get_md5sum(file)
      "/usr/bin/digest -a md5 -v #{escape(file)} | cut -d '=' -f 2 |  cut -c 2-"
    end
    
    def get_sha256sum(file)
      "/usr/bin/digest -a sha256 -v #{escape(file)} | cut -d '=' -f 2 |  cut -c 2-"
    end
  end
end

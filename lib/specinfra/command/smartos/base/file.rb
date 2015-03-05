class Specinfra::Command::Smartos::Base::File < Specinfra::Command::Solaris::Base::File
  class << self
    def get_md5sum(file)
      "digest -a md5 -v #{escape(file)} | cut -d '=' -f 2 |  cut -c 2-"
    end
    
    def get_sha256sum((file)
      "digest -a sha256 -v #{escape(file)} | cut -d '=' -f 2 |  cut -c 2-"
    end
  end
end

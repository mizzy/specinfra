class Specinfra::Command::Freebsd::Base::File < Specinfra::Command::Base::File
  class << self
    def check_has_mode(file, mode)
      regexp = "^#{mode}$"
      "stat -f%Lp #{escape(file)} | grep -- #{escape(regexp)}"
    end

    def get_mode(file)
      "stat -f%Lp #{escape(file)}"
    end
  end
end

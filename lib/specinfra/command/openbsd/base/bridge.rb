class Specinfra::Command::Openbsd::Base::Bridge < Specinfra::Command::Base::Bridge
  class << self
    def check_exists(name)
      "ifconfig #{name}"
    end

    def check_has_interface(name, interface)
      "ifconfig #{name} | grep -o #{interface}"
    end
  end
end

class Specinfra::Command::Cumuluslinux::Base::Ppa < Specinfra::Command::Debian::Base::Ppa
  class << self
    def check_exists(package)
      %Q{find /etc/apt/ -name \*.list | xargs grep -o "deb +http://repo.cumulusnetworks.com/#{to_apt_line_uri(package)}"}
    end

    def check_is_enabled(package)
      %Q{find /etc/apt/ -name \*.list | xargs grep -o "^deb +http://repo.cumulusnetworks.com/#{to_apt_line_uri(package)}"}
    end

    private

    def to_apt_line_uri(repo)
      escape(repo.gsub(/^ppa:/,''))
    end
  end
end

class Specinfra::Command::Cumulusnetworks::Base::Ppa < Specinfra::Command::Cumuluslinux::Base::Ppa
end

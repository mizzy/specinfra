module Specinfra
  module Command
    class Ubuntu < Debian
      def check_running(service)
        "service #{escape(service)} status && service #{escape(service)} status | grep 'running'"
      end

      def check_ppa(package)
        %Q{find /etc/apt/ -name \*.list | xargs grep -o "deb http://ppa.launchpad.net/#{to_apt_line_uri(package)}"}
      end

      def check_ppa_enabled(package)
        %Q{find /etc/apt/ -name \*.list | xargs grep -o "^deb http://ppa.launchpad.net/#{to_apt_line_uri(package)}"}
      end

      private

      def to_apt_line_uri(repo)
        escape(repo.gsub(/^ppa:/,''))
      end
    end
  end
end

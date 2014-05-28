module SpecInfra
  module Command
    class Ubuntu < Debian
      def check_running(service)
        "service #{escape(service)} status && service #{escape(service)} status | grep 'running'"
      end

      def check_ppa(package)
        repo_name = to_apt_line_uri(package)
        "find /etc/apt/ -name \*.list | xargs grep -o \"deb http://ppa.launchpad.net/#{escape(repo_name)}\""
      end

      def check_ppa_enabled(package)
        repo_name = to_apt_line_uri(package)
        "find /etc/apt/ -name \*.list | xargs grep -o \"^deb http://ppa.launchpad.net/#{escape(repo_name)}\""
      end

      private

      def to_apt_line_uri(repo)
        regexp = /^ppa:/
        return repo.gsub("ppa:","") if repo =~ regexp
        repo
      end
    end
  end
end

class Specinfra::Command::Alpine::Base::Process < Specinfra::Command::Base
  class << self
    def get(process, opts)
      col = opts[:format].chomp('=')
      if col == 'args'
        "ps -o #{col} | grep #{escape(process)} | head -1"
      else
        "ps -o #{col},args | grep -E '\\s+#{process}' | awk '{ print $1 }' | head -1"
      end
    end

    def check_is_running(process)
      "ps -ocomm | grep -w -- #{escape(process)} | grep -qv grep"
    end

    def check_count(process, count)
      "test $(ps -ocomm | grep -w -- #{escape(process)} | grep -v grep | wc -l) -eq #{escape(count)}"
    end
  end
end

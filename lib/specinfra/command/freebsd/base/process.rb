class Specinfra::Command::Freebsd::Base::Process < Specinfra::Command::Base::Process
  class << self
    def get(process, opts)
      "ps -p `pgrep -xn #{escape(process)}` -o #{opts[:format]}"
    end

    def count(process)
      "pgrep #{escape(process)} | wc -l"
    end

    def check_is_running(process)
      "pgrep -q #{escape(process)}"
    end

    def check_count(process,count)
      "test `pgrep #{escape(process)} | wc -l` -eq #{escape(count)}"
    end
  end
end

class Specinfra::Command::Darwin::Base::Process < Specinfra::Command::Base::Process
  class << self
    def get(process, opts)
      "pgrep -x #{escape(process)} | head -1"
    end

    def count(process)
      "pgrep -x #{escape(process)} | wc -l"
    end

    def check_is_running(process)
      "pgrep -q -x #{escape(process)}"
    end

    def check_count(process,count)
      "test $(pgrep -x #{escape(process)} | wc -l) -eq #{escape(count)}"
    end
  end
end

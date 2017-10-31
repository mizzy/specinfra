class Specinfra::Command::Base::Process < Specinfra::Command::Base
  class << self
    def get(process, opts)
      "pidof -s #{escape(process)}"
    end

    def count(process)
      "pidof #{escape(process)} | wc -w"
    end

    def check_is_running(process)
      "pidof #{escape(process)}"
    end

    def check_count(process,count)
      "test $(pidof #{escape(process)} | wc -w) -eq #{escape(count)}"
    end
  end
end

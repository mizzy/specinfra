class Specinfra::Command::Base::EnvironmentVariable < Specinfra::Command::Base
  class << self
    def check_exists(key)
      ENV.has_key?(key)
    end
    def get_value(key)
      ENV[key]
    end
  end
end

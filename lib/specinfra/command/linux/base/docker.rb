class Specinfra::Command::Linux::Base::Docker < Specinfra::Command::Base::Docker
  class << self
    def check_inspect_noerr(id)
      "docker inspect #{id} >/dev/null"
    end

    def get_inspect(id, key)
      format_spec = "\'{{ #{transform_key(key)} }}\'"
      "docker inspect -f #{format_spec} #{id}"
    end

    private
    # transform from _ to ., prepend . if needed, i.e.
    # Config_NetworkDisabled becomes .Config.NetworkDisabled
    def transform_key(key)
      return key if key =~ /^\./
      ".#{key.split('_').map { |x| "#{x[0].upcase}#{x[1..-1]}" }.join('.')}"
    end
  end
end

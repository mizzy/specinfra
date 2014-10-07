# -*- coding: utf-8 -*-
module Specinfra
  class Ec2Metadata
    def initialize
      @base_uri = 'http://169.254.169.254/latest/meta-data/'
    end

    def get(path='')
      metadata = {}

      keys = Specinfra::Runner.run_command("curl #{@base_uri}#{path}").stdout.split("\n")

      keys.each do |key|
        if key =~ %r{/$}
          metadata[key[0..-2]] = get(path + key)
        else
          if key =~ %r{=}
            key = key.split('=')[0] + '/'
            metadata[key[0..-2]] = get(path + key)
          else
            ret = get_endpoint(path)
            metadata[key] = get_endpoint(path + key) if ret
          end
        end
      end

      metadata
    end

    def get_endpoint(path)
      ret = Specinfra::Runner.run_command("curl #{@base_uri}#{path}")
      if ret.success?
        ret.stdout
      else
        nil
      end
    end

  end
end

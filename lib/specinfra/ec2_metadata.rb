# -*- coding: utf-8 -*-
module Specinfra
  class Ec2Metadata
    def initialize(host_inventory)
      @host_inventory = host_inventory

      @base_uri = 'http://169.254.169.254/latest/meta-data/'
      @token_uri = 'http://169.254.169.254/latest/api/token'
      @token = ''
      @metadata = {}
    end

    def get
      @token = get_token
      @metadata = get_metadata
      self
    end

    def [](key)
      if key.is_a?(Symbol)
        key = key.to_s
      end
      if @metadata[key].nil?
        begin
          require "specinfra/ec2_metadata/#{key}"
          inventory_class = Specinfra::Ec2Metadata.const_get(key.to_s.to_camel_case)
          @metadata[key] = inventory_class.new(@host_inventory).get
        rescue LoadError
          @metadata[key] = nil
        end
      end

      @metadata[key]
    end

    def empty?
      @metadata.empty?
    end

    def each
      keys.each do |k|
        yield k, @metadata[k]
      end
    end

    def each_key
      keys.each do |k|
        yield k
      end
    end

    def each_value
      keys.each do |k|
        yield @metadata[k]
      end
    end

    def keys
      @metadata.keys
    end

    def inspect
      @metadata
    end

    private
    def get_metadata(path='')
      metadata = {}

      keys = @host_inventory.backend.run_command("curl -H \"X-aws-ec2-metadata-token: #{@token}\" -s #{@base_uri}#{path}").stdout.split("\n")

      keys.each do |key|
        if key =~ %r{/$}
          metadata[key[0..-2]] = get_metadata(path + key)
        else
          if key =~ %r{=}
            key = key.split('=')[0] + '/'
            metadata[key[0..-2]] = get_metadata(path + key)
          else
            ret = get_endpoint(path)
            metadata[key] = get_endpoint(path + key) if ret
          end
        end
      end

      metadata
    end

    def get_endpoint(path)
      ret = @host_inventory.backend.run_command("curl -H \"X-aws-ec2-metadata-token: #{@token}\" -s #{@base_uri}#{path}")
      if ret.success?
        ret.stdout
      else
        nil
      end
    end

    def get_token
      ret = @host_inventory.backend.run_command("curl -X PUT -H \"X-aws-ec2-metadata-token-ttl-seconds: 21600\" -s #{@token_uri}")
      if ret.success?
        ret.stdout
      else
        nil
      end
    end

  end
end

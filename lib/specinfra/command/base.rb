require 'shellwords'

class Specinfra::Command::Base
  attr_accessor :types

  class NotImplementedError < Exception; end

  def escape(target)
    str = case target
          when Regexp
            target.source
          else
            target.to_s
          end

    Shellwords.shellescape(str)
  end

  def method_missing(meth, *args)
    action, resource_type, subaction = breakdown(meth)
    method =  action
    method += "_#{subaction}" if subaction
    command_object = command_class(resource_type).new
    if command_object.respond_to?(method)
      command_object.send(method, *args)
    else
      raise NotImplementedError.new
    end
  end

  def command_class(resource_type)
    family  = os[:family]
    version = os[:release] ? "V#{os[:release].to_i}" : nil

    common_class = self.class.const_get('Specinfra').const_get('Command')
    base_class   = common_class.const_get('Base')
    os_class     = family.nil? ? base_class : common_class.const_get(family.capitalize)

    if family && version
      version_class = os_class.const_get(version)
    elsif family.nil?
      version_class = os_class
    elsif family != 'base' && version.nil?
      version_class = os_class.const_get('Base')
    end

    begin
      command_class = version_class.const_get(resource_type.to_camel_case)
    rescue
      command_class = base_class.const_get(resource_type.to_camel_case)
    end
    command_class
  end

  private
  def breakdown(meth)
    types = resource_types.map {|t| t.to_snake_case }.join('|')
    md = meth.to_s.match(/^([^_]+)_(#{types})_(.+)$/)
    return md[1], md[2], md[3]
  end

  def resource_types
    if @types.nil?
      @types = []
      Specinfra::Command::Base.subclasses.each do |s|
        @types << s.to_s.split(':')[-1]
      end
      @types.uniq!
    end
    @types
  end
end

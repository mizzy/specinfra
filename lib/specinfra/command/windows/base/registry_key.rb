class Specinfra::Command::Windows::Base::RegistryKey < Specinfra::Command::Windows::Base
  class << self
    REGISTRY_KEY_TYPES = {
      :type_string       => 'String',
      :type_binary       => 'Binary',
      :type_dword        => 'DWord',
      :type_qword        => 'QWord',
      :type_multistring  => 'MultiString',
      :type_expandstring => 'ExpandString'
    }

    def check_exists(key_name)
      cmd = "(Get-Item 'Registry::#{key_name}') -ne $null"
      create_command cmd
    end

    def check_has_property(key_name, key_property)
      cmd = "(Get-Item 'Registry::#{key_name}').GetValueKind('#{key_property[:name]}') -eq '#{get_key_type(key_property[:type])}'"
      create_command cmd
    end

    def check_has_value(key_name, key_property)
      value = convert_key_property_value key_property
      cmd = "(Compare-Object (Get-Item 'Registry::#{key_name}').GetValue('#{key_property[:name]}') #{value}) -eq $null"
      create_command cmd
    end

    private
    def do_not_convert?(key_type)
      key_type.to_s =~ /_converted/i
    end

    def get_key_type(key_type)
       REGISTRY_KEY_TYPES[key_type.to_s.gsub("_converted",'').to_sym]
    end

    def convert_key_property_value property
      return property[:value] if do_not_convert? property[:type]
      case property[:type]
      when :type_binary
        byte_array = [property[:value]].pack('H*').bytes.to_a
        "([byte[]] #{byte_array.join(',')})"
      when :type_dword
        [property[:value].rjust(8, '0').scan(/[0-9a-f]{2}/i).reverse.join].pack("H*").unpack("l").first
      when :type_qword
        property[:value].hex
      else
        string_array = property[:value].split("\n").map {|s| "'#{s}'"}.reduce {|acc, s| "#{acc},#{s}"}
        "@(#{string_array})"
      end
    end
  end
end

module SpecInfra
  module Command
    class Windows
      class NotSupportedError < Exception; end
      REGISTRY_KEY_TYPES = {
        :type_string       => 'String',
        :type_binary       => 'Binary',
        :type_dword        => 'DWord',
        :type_qword        => 'QWord',
        :type_multistring  => 'MultiString',
        :type_expandstring => 'ExpandString'
      }

      def method_missing method, *args
        raise NotSupportedError.new "#{method} currently not supported in Windows os" if method.to_s =~ /^check_.+/
        super(method, *args)
      end

      def check_file(file)
        cmd = item_has_attribute file, 'Archive'
        Backend::PowerShell::Command.new do
          exec cmd
        end
      end

      def check_file_hidden(file)
        cmd = item_has_attribute file, 'Hidden'
        Backend::PowerShell::Command.new do
          exec cmd
        end
      end

      def check_file_readonly(file)
        cmd = item_has_attribute file, 'ReadOnly'
        Backend::PowerShell::Command.new do
          exec cmd
        end
      end

      def check_file_system(file)
        cmd = item_has_attribute file, 'System'
        Backend::PowerShell::Command.new do
          exec cmd
        end
      end

      def check_directory(dir)
        cmd = item_has_attribute dir, 'Directory'
        Backend::PowerShell::Command.new do
          exec cmd
        end
      end

      def check_file_contain(file, pattern)
        Backend::PowerShell::Command.new do
          exec "[Io.File]::ReadAllText('#{file}') -match '#{convert_regexp(pattern)}'"
        end
      end

      def check_file_contain_within file, pattern, from=nil, to=nil
        from ||= '^'
        to ||= '$'
        Backend::PowerShell::Command.new do
          using 'crop_text.ps1'
          exec %Q[(CropText -text ([Io.File]::ReadAllText('#{file}')) -fromPattern '#{convert_regexp(from)}' -toPattern '#{convert_regexp(to)}') -match '#{pattern}']
        end
      end

      def check_access_by_user(file, user, access)
        case access
        when 'r'
          check_readable(file, user)
        when 'w'
          check_writable(file, user)
        when 'x'
          check_executable(file, user)
        end
      end

      def check_readable(file, by_whom)
        Backend::PowerShell::Command.new do
          using 'check_file_access_rules.ps1'
          exec "CheckFileAccessRules -path '#{file}' -identity '#{get_identity by_whom}' -rules @('FullControl', 'Modify', 'ReadAndExecute', 'Read', 'ListDirectory')"
        end
      end

      def check_writable(file, by_whom)
        Backend::PowerShell::Command.new do
          using 'check_file_access_rules.ps1'
          exec "CheckFileAccessRules -path '#{file}' -identity '#{get_identity by_whom}' -rules @('FullControl', 'Modify', 'Write')"
        end
      end

      def check_executable(file, by_whom)
        Backend::PowerShell::Command.new do
          using 'check_file_access_rules.ps1'
          exec "CheckFileAccessRules -path '#{file}' -identity '#{get_identity by_whom}' -rules @('FullControl', 'Modify', 'ReadAndExecute', 'ExecuteFile')"
        end
      end

      def check_installed(package, version=nil)
        version_selection = version.nil? ? "" : "-appVersion '#{version}'"
        Backend::PowerShell::Command.new do
          using 'find_installed_application.ps1'
          exec "(FindInstalledApplication -appName '#{package}' #{version_selection}) -eq $true"
        end
      end

      def check_service_installed(service)
        Backend::PowerShell::Command.new do
          using 'find_service.ps1'
          exec "@(FindService -name '#{service}').count -gt 0"
        end
      end

      def check_service_start_mode(service, mode)
        Backend::PowerShell::Command.new do
          using 'find_service.ps1'
          exec  "'#{mode}' -match (FindService -name '#{service}').StartMode -and (FindService -name '#{service}') -ne $null"
        end
      end

      def check_enabled(service, level=nil)
        Backend::PowerShell::Command.new do
          using 'find_service.ps1'
          exec "(FindService -name '#{service}').StartMode -eq 'Auto'"
        end
      end

      def check_running(service)
        Backend::PowerShell::Command.new do
          using 'find_service.ps1'
          exec "(FindService -name '#{service}').State -eq 'Running'"
        end
      end

      def check_process(process)
        Backend::PowerShell::Command.new do
          exec "(Get-Process '#{process}') -ne $null"
        end
      end

      def check_listening(port)
        Backend::PowerShell::Command.new do
          using 'is_port_listening.ps1'
          exec "IsPortListening -portNumber #{port}"
        end
      end

      def check_listening_with_protocol(port, protocol)
        Backend::PowerShell::Command.new do
          using 'is_port_listening.ps1'
          exec "IsPortListening -portNumber #{port} -protocol '#{protocol}'"
        end
      end

      def check_user(user)
        user_id, domain = windows_account user
        Backend::PowerShell::Command.new do
          using 'find_user.ps1'
          exec "(FindUser -userName '#{user_id}'#{domain.nil? ? "" : " -domain '#{domain}'"}) -ne $null"
        end
      end

      def check_group(group)
        group_id, domain = windows_account group
        Backend::PowerShell::Command.new do
          using 'find_group.ps1'
          exec "(FindGroup -groupName '#{group_id}'#{domain.nil? ? "" : " -domain '#{domain}'"}) -ne $null"
        end
      end

      def check_belonging_group(user, group)
        user_id, user_domain = windows_account user
        group_id, group_domain = windows_account group
        Backend::PowerShell::Command.new do
          using 'find_user.ps1'
          using 'find_group.ps1'
          using 'find_usergroup.ps1'
          exec "(FindUserGroup -userName '#{user_id}'#{user_domain.nil? ? "" : " -userDomain '#{user_domain}'"} -groupName '#{group_id}'#{group_domain.nil? ? "" : " -groupDomain '#{group_domain}'"}) -ne $null"
        end
      end

      def check_registry_key(key_name, key_property = {})
        if key_property.empty?
          cmd = "(Get-Item 'Registry::#{key_name}') -ne $null"
        else
          if key_property.key? :value
            value = convert_key_property_value key_property
            cmd = "(Compare-Object (Get-Item 'Registry::#{key_name}').GetValue('#{key_property[:name]}') #{value}) -eq $null"
          else
            cmd = "(Get-Item 'Registry::#{key_name}').GetValueKind('#{key_property[:name]}') -eq '#{REGISTRY_KEY_TYPES[key_property[:type]]}'"
          end
        end
        Backend::PowerShell::Command.new { exec cmd }
      end

      def check_resolvable(name, type)
        if type == "hosts"
            cmd = "@(Select-String -path (Join-Path -Path $($env:windir) -ChildPath 'system32/drivers/etc/hosts') -pattern '#{name}\\b').count -gt 0"
        else
            cmd = "@([System.Net.Dns]::GetHostAddresses('#{name}')).count -gt 0"
        end
        Backend::PowerShell::Command.new { exec cmd }
      end

      def check_reachable(host, port, proto, timeout)
          if port.nil?
             Backend::PowerShell::Command.new do
              exec "(New-Object System.Net.NetworkInformation.Ping).send('#{host}').Status -eq 'Success'"
             end
          else
            Backend::PowerShell::Command.new do
             using 'is_remote_port_listening.ps1'
             exec"(IsRemotePortListening -hostname #{host} -port #{port} -timeout #{timeout} -proto #{proto}) -eq $true"
            end
          end
      end

      def check_windows_feature_enabled(name,provider)

        if provider.nil?
          cmd =  "@(ListWindowsFeatures -feature #{name}).count -gt 0"
        else
          cmd =  "@(ListWindowsFeatures -feature #{name} -provider #{provider}).count -gt 0"
        end

        Backend::PowerShell::Command.new do
          using 'list_windows_features.ps1'
          exec cmd
        end
      end

      def check_file_version(name,version)
        cmd = "((Get-Command '#{name}').FileVersionInfo.ProductVersion -eq '#{version}') -or ((Get-Command '#{name}').FileVersionInfo.FileVersion -eq '#{version}')"
        Backend::PowerShell::Command.new { exec cmd }
      end

      def check_iis_website_enabled(name)
        Backend::PowerShell::Command.new do
          using 'find_iis_component.ps1'
          exec "(FindIISWebsite -name '#{name}').serverAutoStart -eq $true"
        end
      end

      def check_iis_website_installed(name)
        Backend::PowerShell::Command.new do
          using 'find_iis_component.ps1'
          exec "@(FindIISWebsite -name '#{name}').count -gt 0"
        end
      end

      def check_iis_website_running(name)
        Backend::PowerShell::Command.new do
          using 'find_iis_component.ps1'
          exec "(FindIISWebsite -name '#{name}').state -eq 'Started'"
        end
      end

      def check_iis_website_app_pool(name, app_pool)
        Backend::PowerShell::Command.new do
          using 'find_iis_component.ps1'
          exec "(FindIISWebsite -name '#{name}').applicationPool -match '#{app_pool}'"
        end
      end

      def check_iis_website_path(name, path)
        Backend::PowerShell::Command.new do
          using 'find_iis_component.ps1'
          exec "[System.Environment]::ExpandEnvironmentVariables( ( FindIISWebsite -name '#{name}' ).physicalPath ).replace('\\', '/' ) -eq ('#{path}'.trimEnd('/').replace('\\', '/'))"
        end
      end

      def check_iis_app_pool(name)
        Backend::PowerShell::Command.new do
          using 'find_iis_component.ps1'
          exec "@(FindIISAppPool -name '#{name}').count -gt 0"
        end
      end

      def check_iis_app_pool_dotnet(name, dotnet)
        Backend::PowerShell::Command.new do
          using 'find_iis_component.ps1'
          exec "(FindIISAppPool -name '#{name}').managedRuntimeVersion -match 'v#{dotnet}'"
        end
      end

      private

      def item_has_attribute item, attribute
        "((Get-Item -Path '#{item}' -Force).attributes.ToString() -Split ', ') -contains '#{attribute}'"
      end

      def convert_key_property_value property
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

      def windows_account account
        match = /((.+)\\)?(.+)/.match account
        domain = match[2]
        name = match[3]
        [name, domain]
      end
    end
  end
end

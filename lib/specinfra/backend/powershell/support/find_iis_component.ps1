function FindIISWebsite 
{
    param($name)

    Import-Module WebAdministration

    Try {
        Get-Item "IIS:\Sites\$name" -Erroraction silentlycontinue
    }
    Catch [System.IO.FileNotFoundException] {
        Get-Item "IIS:\Sites\$name" -Erroraction silentlycontinue
    }
}

function FindIISAppPool
{
    param($name)
    
    Import-Module WebAdministration

    Try {
        Get-Item "IIS:\AppPools\$name" -Erroraction silentlycontinue
    }
    Catch [System.IO.FileNotFoundException] {
        Get-Item "IIS:\AppPools\$name" -Erroraction silentlycontinue

    }
}

function FindSiteBindings
{
    param($name, $protocol, $hostHeader, $port, $ipAddress)

    Import-Module WebAdministration
    Try {
        Get-WebBinding -Name $name -Protocol $protocol -HostHeader $hostHeader -Port $port -IPAddress $ipAddress
    }
    Catch [System.IO.FileNotFoundException] {
        Get-WebBinding -Name $name -Protocol $protocol -HostHeader $hostHeader -Port $port -IPAddress $ipAddress
    }
}

function FindSiteVirtualDir
{
    param($name, $vdir, $path)

    Import-Module WebAdministration

    $webVirtDirPath = [string]::Format('IIS:\Sites\{0}\{1}',$name, $vdir);
    if (Test-Path $webVirtDirPath)
    {
        if ([string]::IsNullOrEmpty($path))
        {
            $true
        }
        else
        {
            (Get-Item $webVirtDirPath).physicalPath -eq $path
        }
    }
    else
    {
        $false
    }
}

function FindSiteApplication
{
    param($name, $app, $pool, $physicalPath)

    Import-Module WebAdministration

    $path = "IIS:\Sites\${name}\${app}"
    $result = $false
    if (Test-Path $path)
    {
        $result = $true
        if ([string]::IsNullOrEmpty($pool) -eq $false)
        {
            $result = $result -and (Get-Item $path).applicationPool -eq $pool
        }

        if ([string]::IsNullOrEmpty($physicalPath) -eq $false)
        {
            $result = $result -and (Get-Item $path).physicalPath -eq $physicalPath
        }
    }

    $result
}

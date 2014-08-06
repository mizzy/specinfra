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
    
    Get-Item "IIS:\AppPools\$name" -Erroraction silentlycontinue
}

function FindSiteBindings
{
    param($name, $protocol, $hostHeader, $port, $ipAddress)
  
    Import-Module WebAdministration
  
    Get-WebBinding -Name $name -Protocol $protocol -HostHeader $hostHeader -Port $port -IPAddress $ipAddress
}

function FindSiteVirtualDir
{
    param($name, $vdir, $path)
    
    Import-Module WebAdministration
    
    $webVirtDirPath = [string]::Format('IIS:\Sites\{0}\{1}',$name, $vdir);
    if (Test-Path $webVirtDirPath) {
        (Get-Item $webVirtDirPath).physicalPath -eq $path
    }
    else {
        $false
    }
}
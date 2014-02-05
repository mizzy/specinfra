function ListWindowsFeatures
{    

param(
        [string]$feature,
        [string]$provider="dism"
         )

    $cachepath =  "${env:temp}/ListWindowsFeatures-${provider}.xml"
    $maxAge = 2

    $cache =  Get-Item $cachepath -erroraction SilentlyContinue

    if($cache -ne $null -and ((get-date) - $cache.LastWriteTime).minutes -lt $maxage){
        $features = Import-Clixml $cachepath |  Select *| Where-Object {(($_.name -like $feature) -or ($_.displayName -like $feature)) -and (($_.installed -eq $true) -or ($_.state -eq "Enabled"))}
        return $features
    }
    else{

        switch($provider)
        {
            "dism" { return features_dism | Select * | Where-Object {($_.name -eq $feature) -and ($_.state -eq "Enabled")}  }
            "powershell" { return features_powershell | Select * | Where-Object {(($_.name -like $feature) -or ($_.displayName -like $feature)) -and ($_.installed -eq $true)} }
            default {throw "Unsupported provider"}
        }

    }
}

function features_dism{
      try
        {
            $out = DISM /Online /Get-Features /Format:List | Where-Object {$_}     

            if($LASTEXITCODE -ne 0)
            {
                Write-Error $out
                Break
            }

            $f = $out[4..($out.length-2)]
            $features = for($i=0; $i -lt $f.length;$i+=2)
            {
                $tmp = $f[$i],$f[$i+1] -replace '^([^:]+:\s)'
                
                New-Object PSObject -Property @{
                    Name = $tmp[0]
                    State = $tmp[1]
                }
            }

            $features | Export-Clixml $cachepath

            return $features
        }
        catch
        {
            Throw
        }
}

function features_powershell{
    $ProgressPreference = "SilentlyContinue"
     import-module servermanager
     $features = Get-WindowsFeature
     $features | Export-Clixml $cachepath
     return Get-WindowsFeature 
}
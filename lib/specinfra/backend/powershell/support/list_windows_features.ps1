function ListWindowsFeatures
{    
    $cachepath =  "${env:temp}/ListWindowsFeatures.xml"
    $maxAge = 2

    $cache =  Get-Item $cachepath -erroraction SilentlyContinue

    if($cache -ne $null -and ((get-date) - $cache.LastWriteTime).minutes -lt $maxage){
        return Import-Clixml $cachepath
    }
    else{
        try
        {
            $dism = DISM /Online /Get-Features /Format:List | Where-Object {$_}     

            if($LASTEXITCODE -ne 0)
            {
                Write-Error $dism
                Break
            }

            $f = $dism[4..($dism.length-2)]
            $feature = for($i=0; $i -lt $f.length;$i+=2)
            {
                $tmp = $f[$i],$f[$i+1] -replace '^([^:]+:\s)'
                
                New-Object PSObject -Property @{
                    Name = $tmp[0]
                    State = $tmp[1]
                }
            }

            $feature | Export-Clixml $cachepath

            return $feature
        }
        catch
        {
            Throw
        }

    }
}
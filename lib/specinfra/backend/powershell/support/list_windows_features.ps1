function ListWindowsFeatures
{    
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

            return $feature
        }
        catch
        {
            Throw
        }

}
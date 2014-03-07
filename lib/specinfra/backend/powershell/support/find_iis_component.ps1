function FindIISWebsite 
{
    param($name)
    import-module WebAdministration
    Get-Website | Where { $_.name -match $name }
}

function FindIISAppPool
{
    param($name)
    import-module WebAdministration
    Get-Item "IIS:\AppPools\$name" -Erroraction silentlycontinue
}
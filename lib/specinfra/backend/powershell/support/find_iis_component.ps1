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
    import-module WebAdministration
    Get-Item "IIS:\AppPools\$name" -Erroraction silentlycontinue
}
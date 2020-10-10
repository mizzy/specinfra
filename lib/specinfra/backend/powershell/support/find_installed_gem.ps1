function FindInstalledGem
{
  param($gemName, $gemVersion)

  $nameVer = $(Invoke-Expression "gem list --local" | Select-String "^$gemName").Line
  if ($nameVer.StartsWith($gemName)) {
    if ($gemVersion) {
      $versions = ($nameVer -split { $_ -eq "(" -or $_ -eq ")"})[1].split(" ")
      if ($versions.Contains($gemVersion)) {
        $true
      } else {
        $false
      }
    } else {
      $true
    }
  } else {
    $false
  }
}


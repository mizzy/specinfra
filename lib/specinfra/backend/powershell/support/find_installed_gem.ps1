function FindInstalledGem
{
  param($gemName, $gemVersion)

  $nameVer = $(Invoke-Expression "gem list --local" | Select-String "$gemName").Line
  if ($nameVer.StartsWith($gemName)) {
    if ($gemVersion) {
      if ($nameVer.EndsWith("$gemVersion)")) {
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


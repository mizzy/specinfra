function FindInstalledApplication
{
  param($appName, $appVersion)
    
  if ((Get-WmiObject win32_operatingsystem).OSArchitecture -notmatch '64')  
  { 
    $keys= (Get-ItemProperty 'HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall\*')
    $possible_path= 'HKCU:\Software\Microsoft\Windows\CurrentVersion\Uninstall\*'
    if (Test-Path $possible_path)
    {
      $keys+= (Get-ItemProperty $possible_path)
    }
  }  
    else  
  { 
    $keys = (Get-ItemProperty 'HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall\*','HKLM:\SOFTWARE\Wow6432Node\Microsoft\Windows\CurrentVersion\Uninstall\*')
    $possible_path= 'HKCU:\Software\Microsoft\Windows\CurrentVersion\Uninstall\*'
    if (Test-Path $possible_path)
    {
      $keys+= (Get-ItemProperty $possible_path)
    }
    $possible_path= 'HKCU:\Software\Wow6432Node\Microsoft\Windows\CurrentVersion\Uninstall\*'
    if (Test-Path $possible_path)
    {
      $keys+= (Get-ItemProperty $possible_path)
    }
  }

  if ($appVersion -eq $null) { 
    @($keys | Where-Object {$_.DisplayName -like $appName -or $_.PSChildName -like $appName}).Length -gt 0
  }
  else{
    @($keys | Where-Object {$_.DisplayName -like $appName -or $_.PSChildName -like $appName  } | Where-Object {$_.DisplayVersion -eq $appVersion} ).Length -gt 0
  }

}


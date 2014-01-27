function FindInstalledApplication
{
  param($appName, $appVersion)
    
  if ((Get-WmiObject win32_operatingsystem).OSArchitecture -notlike '64-bit')  
  { 
      $keys= (Get-ItemProperty 'HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall\*') 
  }  
    else  
  { 
      $keys = (Get-ItemProperty 'HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall\*','HKLM:\SOFTWARE\Wow6432Node\Microsoft\Windows\CurrentVersion\Uninstall\*') 
  }   

  if ($appVersion -eq $null) { 
   $keys | Where-Object {$_.name -like $appName -or $_.PSChildName -like $appName}
  }
  else{
   $keys | Where-Object {$_.name -like $appName -or $_.PSChildName -like $appName  } | Where-Object {$_.DisplayVersion -eq $appVersion}
  }
}


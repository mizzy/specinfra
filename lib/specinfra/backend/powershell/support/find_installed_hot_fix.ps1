function FindInstalledHotFix
{
  param($description, $hotFixId)

Write-Host "Num Args:" $args.Length;
foreach ($arg in $args)
{
  Write-Host "Arg: $arg";
}

  Write-Host $description
  Write-Host $hotFixId

  $keys= (Get-WmiObject -Class WIN32_QuickFixEngineering)
  
  @($keys | Where-Object {$_.HotFixID -like $hotFixId}).Length -gt 0

}

function FindScheduledTask
{
  param($name)

  $task = schtasks /query /v /fo csv /TN "$name" | ConvertFrom-CSV
  return $task
}
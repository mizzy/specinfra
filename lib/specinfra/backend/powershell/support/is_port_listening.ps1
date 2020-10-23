function IsPortListening
{
  param($portNumber, $protocol)
  $netstatOutput = netstat -an | Out-String
  $networkIPs = (Get-WmiObject Win32_NetworkAdapterConfiguration | ? {$_.IPEnabled}) | %{ $_.IPAddress[0] }
  [array] $networkIPs += "0.0.0.0"
  [array] $networkIPs += "127.0.0.1"
  [array] $networkIPs += "[::1]"
  [array] $networkIPs += "[::]"
  foreach ($ipaddress in $networkIPs)
  {
    $matchExpression = ("$ipaddress" + ":" + $portNumber + ".*(LISTENING|\*:\*)")
    if ($protocol) { $matchExpression = ($protocol.toUpper() + "\s+$matchExpression") }
    if ($netstatOutput -match $matchExpression) { return $true }
  }
  $false
}

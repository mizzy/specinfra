function IsRemotePortListening{
	param(
		[string]$hostname,
		[string]$proto="tcp",
		[int]$port,
		[int]$timeout)


	If ($proto -eq "tcp") {     
		$tcpobject = new-Object system.Net.Sockets.TcpClient                   
		$connect = $tcpobject.BeginConnect($hostname,$port,$null,$null)   
		$wait = $connect.AsyncWaitHandle.WaitOne($timeout * 1000,$false)   
		#If timeout   
		If(!$wait) {   
				$tcpobject.Close()   
				return $false
			} 
			else{    
				$result = $tcpobject.Connected
				$tcpobject.Close()
				return $result
			}      
		}       
		elseif ($proto -eq "udp") {                               
			$udpobject = new-Object system.Net.Sockets.Udpclient 
			$udpobject.client.ReceiveTimeout = $timeout  * 1000
			$udpobject.Connect($hostname,$port)  
			$a = new-object system.text.asciiencoding  
			$byte = $a.GetBytes("$(Get-Date)")  
			[void]$udpobject.Send($byte,$byte.length)  
			$remoteendpoint = New-Object system.net.ipendpoint([system.net.ipaddress]::Any,0)  
			try{
				#Blocks until a message returns on this socket from a remote host.  
				$receivebytes = $udpobject.Receive([ref]$remoteendpoint)  
				[string]$returndata = $a.GetString($receivebytes) 
				If ($returndata) { 
					$udpobject.close()    
					return $true
				} 
				else{
					return $false
				}                        
			}
			catch{
				return $false
			}
		}         
		else{
			throw "Protocol ${proto} not supported"
		}                          
	}   
function Utilities
{
     param (
           [string]$Title = 'Utilities Menu'
     )
     cls
     Write-Host "================ $Title ================"
    
     Write-Host "1: Press '1' for Stop xStore"
     Write-Host "2: Press '2' for Stop xEnvironment"
	 Write-Host "3: Press '3' for Start xEnvironment"
     Write-Host "4: Press '4' for Check ssl certs"
	 Write-Host "5: Press '5' for EPSON printer installation"
	 Write-Host "6: Press '6' for Check corporate connectivity"
     Write-Host "Q: Press 'Q' to Go back"
}
do
{
     Utilities
     $input = Read-Host "Please make a selection"
     switch ($input)
     {
           '1' { 	'You chose option #1'
					$xs = test-path C:\xstore\tmp
					if($xs -eq $True)
					{	Remove-item C:\xstore\tmp\* -recurse
						write-host "XSTORE has been stopped" -ForegroundColor Green
					}
					if($xs -eq $False)
					{	
						write-host "XSTORE is not present on this system" -ForegroundColor Red
					}
                
           } '2' {	'You chose option #2'
					$xe = test-path C:\environment\tmp
					if($xe -eq $True)
					{	Remove-item C:\environment\tmp\* -recurse
						write-host "xenvironment has been stopped" -ForegroundColor Green
					}
					if($xe -eq $False)
					{	
						write-host "xenvironment is not present on this system" -ForegroundColor Red
					}
           } '3' {
					'You chose option #3'
					$xen = test-path C:\environment\start_eng.bat
					if($xen -eq $True)
					{	echo "Starting XEnvironment..."
						C:\environment\start_eng.bat
					}
					if($xen -eq $False)
					{	
						write-host "xenvironment is not present on this system" -ForegroundColor Red
					} 
           } '4' {	
					'You chose option #4'
					openssl s_client -connect localhost:9096
           } '5' {	
					'You chose option #5'
					C:\setup\Scripts\Install_printer.ps1
           } '6' {	
					'You chose option #6'
					echo "No code present for this operation !"
           } 'q' {
					C:\setup\Scripts\Menu\Menu.ps1
           }		
     }
     pause
}
until ($input -eq 'q')
function Show-Menu
{
     param (
           [string]$Title = 'Tech Arch - My Menu'
     )
     cls
     Write-Host "================ $Title ================"
    
     Write-Host "1: Press '1' for Install Software" -ForegroundColor Yellow
     Write-Host "2: Press '2' for Update Configurations" -ForegroundColor Yellow
     Write-Host "3: Press '3' for Utilities" -ForegroundColor Yellow
	 Write-Host "4: Press '4' for Uninstall Software" -ForegroundColor Yellow
     Write-Host "Q: Press 'Q & Enter' to quit." -ForegroundColor Yellow
}
do
{
     Show-Menu
     $input = Read-Host "Please make a selection"
     switch ($input)
     {
           '1' { 	'You chose option #1'
					C:\setup\Scripts\Menu\Install.ps1
                
           } '2' {
					'You chose option #2'
					C:\setup\Scripts\Menu\Update.ps1
           } '3' {
					'You chose option #3'
					C:\setup\Scripts\Menu\Utilities.ps1
		   } 
			 '4' { 'You chose option #4'
					C:\setup\Scripts\Menu\Uninstall.ps1
           }	
			 
     }
     pause
}
until ($input -eq 'q')
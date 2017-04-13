function Update
{
     param (
           [string]$Title = 'Update Configurations'
     )
     cls
     Write-Host "================ $Title ================"
    
     Write-Host "1: Press '1' for Update xStore"
     Write-Host "2: Press '2' for Update xEnvironment"
     Write-Host "3: Press '3' for Update Hosts file"
     Write-Host "Q: Press 'Q' to Go back"
}
do
{
     Update
     $input = Read-Host "Please make a selection"
     switch ($input)
     {
           '1' { 'You chose option #1'
				 notepad C:\setup\Scripts\Properties\values.env
				 pause
				 CD C:\setup\Scripts\Properties
				 .\Configuration.ps1
				 ECHO Properties files has been updated.
				 
				} '2' {
					#xenvironment salt update
					$saltNewValue = $MasterProps."customerId.salt"
					$oldValue = Read-Host "Enter the old key & value"
					$newValue = Read-Host "Enter the new key & value"
					..\replaceText.ps1 -fileName "C:\environment\updates\base-xstore.properties" -oldValue "$oldValue" -newValue "$newValue"
					c:\environment\configure.bat
					..\replaceText.ps1 -fileName "C:\environment\system.properties" -oldValue "dtv.env.access.customercode=" -newValue "dtv.env.access.customercode=$saltNewValue"
           } '3' {
					'You chose option #3'
					echo Option 3
		   } 'q' {
					C:\setup\Scripts\Menu\Menu.ps1
           }
     }
     pause
}
until ($input -eq 'q')
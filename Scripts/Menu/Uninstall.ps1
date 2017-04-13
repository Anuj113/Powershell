function Unistallation-menu
{
     param (
           [string]$Title = 'Software Uninstallation Menu'
     )
     cls
     Write-Host "================ $Title ================"
    
     Write-Host "1: Press '1' for Uninstall 7Zip"
     Write-Host "2: Press '2' for Uninstall Notepad++"
	 Write-Host "3: Press '3' for Uninstall OracleDB & delete Xstore DB"
     Write-Host "4: Press '4' for Uninstall Xstore"
	 Write-Host "5: Press '5' for Uninstall Xenvironment"
	 Write-Host "6: Press '6' for Uninstall Java"
     Write-Host "Q: Press 'Q' to Go back"
}
do
{
     Unistallation-menu
     $input = Read-Host "Please make a selection"
     switch ($input)
     {
           '1' {
					'You chose option #1'
					C:\setup\Scripts\Rollback\7zip_uninstall.ps1
         } '2' {
					'You chose option #2'
					C:\setup\Scripts\Rollback\NPP_uninstall.ps1
         } '3' {
					'You chose option #3'
					C:\setup\Scripts\Rollback\OracleDB_uninstall.ps1
         } '4' {
					'You chose option #4'
					Remove-item C:\xstore -recurse
					Remove-item C:\xstoredb -recurse
					Remove-item C:\xstore-genkeys -recurse
					Remove-item C:\xstoreinstall -recurse
					Remove-item C:\BACKUPxstore -recurse
				
		 }	'5' {
					'You chose option #5'
					Remove-item C:\environment -recurse
		}   '6' {
					'You chose option #6'
					$JRE = test-path C:\jre
					if($JRE -eq $True)
					{	
						Remove-item C:\jre -recurse
						write-host "Java has been removed" -ForegroundColor Green
					}
					if($JRE -eq $False)
					{	
						write-host "Java is not present" -ForegroundColor Red
					}
				
		}  'q' {
                C:\setup\Scripts\Menu\Menu.ps1
           }
     }
     pause
}
until ($input -eq 'q')
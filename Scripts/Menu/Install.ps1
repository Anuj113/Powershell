function Installation-menu
{
     param (
           [string]$Title = 'Software Installation Menu'
     )
     cls
     Write-Host "================ $Title ================"
    
     Write-Host "1: Press '1' for Install PreRequisites" -ForegroundColor Yellow
	 Write-Host "2: Press '2' for Install Java" -ForegroundColor Yellow
     Write-Host "3: Press '3' for Install Oracle db Software" -ForegroundColor Yellow
     Write-Host "4: Press '4' for Install xStore database" -ForegroundColor Yellow
	 Write-Host "5: Press '5' for Install xStore" -ForegroundColor Yellow
     Write-Host "6: Press '6' for Install xEnvironment - Lead" -ForegroundColor Yellow
     Write-Host "7: Press '7' for Install xEnvironment - Non-Lead" -ForegroundColor Yellow
     Write-Host "Q: Press 'Q' to Go back"
}

#Functions

function TEMPfolder()
{
$Temp = test-path C:\TEMP
					if ($TEMP -eq $True)
					{
						remove-item C:\TEMP -Recurse
						write-host "TEMP folder cleaned up" -ForegroundColor Green
					}
}

do
{
     Installation-menu
     $input = Read-Host "Please make a selection"
     switch ($input)
     {
           '1' {
					'You chose option #1'
					mkdir c:\TEMP
					C:\setup\Scripts\7zip_Install.ps1
					C:\setup\Scripts\Notepad_pp_Install.ps1
					cd c:\
					remove-item TEMP -Recurse
         } '2' {
					'You chose option #2'
					$Java = test-path C:\jre\bin
					if ($Java -eq $True)
					{
						write-host "Java is already installed" -ForegroundColor Red
					}
					if ($Java -eq $False)
					{
						write-host "Installing JRE" -ForegroundColor Green
						C:\setup\Scripts\java_Unzip.ps1
					}		
         } '3' {
					'You chose option #3'
					$Ora = test-path C:\app\oracle\product\12.1.0\dbhome_1\deinstall\deinstall.bat
					if ($Ora -eq $True)
					{
						write-host "Oracle is already installed in this system" -ForegroundColor Red
					}
					if ($Ora -eq $False)
					{
						write-host "Installing Oracle DB" -ForegroundColor Green
						mkdir c:\TEMP
						mkdir C:\app\oracle\product\12.1.0\dbhome_1
						write-host "Hold on for 4-5 minutes...." -ForegroundColor Green
						C:\setup\Scripts\OracleDB_Install.ps1
						TIMEOUT /T 450
						TEMPfolder
					}
					
					
         } '4' {
					'You chose option #4'
					C:\app\oracle\product\12.1.0\dbhome_1\BIN\netca -silent -responseFile C:\setup\Scripts\lsnr.rsp
					cd C:\setup\Scripts\DB\xstore
					C:\setup\Scripts\DB\xstore\XSTORE.bat
         } '5' {
					'You chose option #4'
					$xstoreinstall = test-path C:\xstoreinstall\software
					if ($xstoreinstall -eq $True)
					{
						write-host "xstoreinstall folder is available, installing xstore" -ForegroundColor Green
					}
					if ($xstoreinstall -eq $False)
					{
						write-host "xstoreinstall is not available, running extraction from installer & installing xstore" -ForegroundColor Red
						mkdir c:\TEMP
						mkdir C:\xstoreinstall\software
						mkdir C:\xstoreinstall\Tools\genkeys
						C:\setup\Scripts\ExtractXstore.ps1
					}
					C:\setup\Scripts\generate-ant-install.ps1
					C:\setup\Scripts\xstore.ps1
					TEMPfolder
		}  '6' {
					<# 'You chose option #6'
					$xstoreinstall = test-path C:\xstoreinstall\software
					if ($xstoreinstall -eq $True)
					{
						write-host "xstoreinstall folder is available, installing xenvironment" -ForegroundColor Green
					}
					if ($xstoreinstall -eq $False)
					{
						write-host "xstoreinstall is not available, running extraction from installer & installing xenvironment" -ForegroundColor Red
						mkdir c:\TEMP
						mkdir C:\xstoreinstall\software
						mkdir C:\xstoreinstall\Tools\genkeys
						C:\setup\Scripts\ExtractXstore.ps1
					}
					C:\setup\Scripts\generate-ant-install.ps1
					C:\setup\Scripts\xenvironment.ps1
					TEMPfolder #>
					
		}  '7' {
					'You chose option #7'
					$xstoreinstall = test-path C:\xstoreinstall\software
					if ($xstoreinstall -eq $True)
					{
						write-host "xstoreinstall folder is available, installing xenvironment" -ForegroundColor Green
					}
					if ($xstoreinstall -eq $False)
					{
						write-host "xstoreinstall is not available, running extraction from installer & installing xenvironment" -ForegroundColor Red
						mkdir c:\TEMP
						mkdir C:\xstoreinstall\software
						mkdir C:\xstoreinstall\Tools\genkeys
						C:\setup\Scripts\ExtractXstore.ps1
					}
					C:\setup\Scripts\generate-ant-install.ps1
					C:\setup\Scripts\xenvironment.ps1
					TEMPfolder
		}  'q' {
                C:\setup\Scripts\Menu\Menu.ps1
           }
     }
     pause
}
until ($input -eq 'q')
# #############################################################################
# ACCENTURE For TJX Inc. - SCRIPT - POWERSHELL
# 
# AUTHOR_Primary :  anuj.l.kumar@accenture.com
# AUTHOR_Secondary : s.vijaykumar.kothari@accenture.com
# DATE:  2016/05/10
# 
# COMMENT:  This script will install 7zip in the system.
#
# VERSION HISTORY
# Initial version 1.0
#
# #############################################################################


Measure-Command{
	ForEach-Object{
				try{
				$source = "C:\setup\Installers\7z1602-x64.zip"
				$destination = "C:\TEMP\7z1602-x64.zip"
 
				Copy-item -path $source -Destination $destination -Force

				$shell = New-Object -ComObject shell.application
				$zip = $shell.NameSpace("C:\TEMP\7z1602-x64.zip")
				MkDir("C:\TEMP\7Zip")
				foreach ($item in $zip.items()) {
				$shell.Namespace("C:\TEMP\7Zip").CopyHere($item)
						}
								cd C:\TEMP\7Zip
								function install-7zip()
									{
										$install="C:\TEMP\7Zip\7z1602-x64.exe"
										Start-Process -FilePath $install -ArgumentList '/InstallDirectoryPath:"C:\Program Files"','/S'  -Wait -Verb RunAs  
    
									}
										##### This is Windows calling the function to install the script
										install-7zip
										Write-Host "7zip has been installed." -ForegroundColor Green
										
			}
				
	
			catch {
				Write-Warning "7zip Installation is failed"
					}
}
cd..
#remove-item 7Zip -Recurse
#remove-item 7z1602-x64.zip

}  
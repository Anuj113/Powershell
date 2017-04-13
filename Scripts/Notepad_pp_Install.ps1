# #############################################################################
# ACCENTURE For TJX Inc. - SCRIPT - POWERSHELL
# 
# AUTHOR_Primary :  anuj.l.kumar@accenture.com
# AUTHOR_Secondary : s.vijaykumar.kothari@accenture.com
# DATE:  2016/05/10
# 
# COMMENT:  This script will install Notepad++ in the system.
#
# VERSION HISTORY
# Initial version 1.0
#
# #############################################################################

Measure-Command {
	ForEach-Object {
				try {
				$source = "C:\setup\Installers\npp.6.9.2.Installer.zip"
				$destination = "C:\TEMP\npp.6.9.2.Installer.zip"
 
				Copy-item -path $source -Destination $destination -Force

				$shell = New-Object -ComObject shell.application
				$zip = $shell.NameSpace("C:\TEMP\npp.6.9.2.Installer.zip")
				MkDir("C:\TEMP\NPP")
				foreach ($item in $zip.items()) {
				$shell.Namespace("C:\TEMP\NPP").CopyHere($item)
						}
								cd C:\TEMP\NPP
								function install-NPP()
									{
										$install="C:\TEMP\NPP\npp.6.9.2.Installer.exe"
										Start-Process -FilePath $install -ArgumentList '/InstallDirectoryPath:"C:\Program Files"','/S'  -Wait -Verb RunAs  
    
									}
										##### This is Windows calling the function to install the script
										install-NPP
										Write-Host "Notepad++ has been installed." -ForegroundColor Green
										
			}
				
	
			catch {
				Write-Warning "Notepad++ Installation is failed"
					}
}
cd..
remove-item NPP -Recurse
remove-item npp.6.9.2.Installer.zip

}  
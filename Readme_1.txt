This script pack includes following - 
1.Installer Folder : Contains all the installers in the zip format which will get executed once SoftwareInstall.bat file run.

2. Scripts Folder : Contains all the scripts which wil be running with this pack.

Script structure - 
Master.bat > SoftwareInstall.bat > AppInstall.bat
Master.bat call every other common/central bat/ps1 files in the scripts folder.

SoftwareInstall.bat/AppInstall.bat - Calls all installers and application setup respectively. 
-----------------------------------------------------------------------------------------------------------------------------------
Content Description :

$source = "C:\setup\Installers\7z1602-x64.zip" - The location from where the dump is present.
$destination = "C:\TEMP\7z1602-x64.zip" - Temporary location for copyinf the dump file and install it after extraction.

'/InstallDirectoryPath:"C:\Program Files"','/S' - Installtion directory for product.

*** Sofwareinstall .bat file format ***
echo "7zip - In Progress..." - Comments
::Installing Example with powershell script. - Comments
PowerShell Drive:\-path-\Example_install.ps1 >> Drive:\path-Log\Example_log.txt - Calling powershell/batch script and creating logs in text file.
echo "7zip Done!" - Comment
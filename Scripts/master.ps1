#Changing the execution policy of powershell to run powershell script in bypass/unrestricted mode.
Set-ExecutionPolicy -Scope CurrentUser -ExecutionPolicy bypass -Force
$starttime = get-date
echo "Execution policy changed to bypass for current user"

# #############################################################################
# ACCENTURE For TJX Inc. - SCRIPT - POWERSHELL
# 
# AUTHOR_Primary :  anuj.l.kumar@accenture.com
# AUTHOR_Secondary : s.vijaykumar.kothari@accenture.com
# DATE:  2016/05/10
# 
# COMMENT:  This script will configure the OS level settings and call the installation/configuration scripts.
#
# VERSION HISTORY
# Initial version 1.0
#
# #############################################################################

#Changing the virtual memory settings
REG add "HKLM\SYSTEM\CurrentControlSet\Control\Session Manager\Memory Management" /v "PagingFiles" /t REG_MULTI_SZ /d "C:\pagefile.sys 0 0" /f
echo "Virtual memory settings has been changed to - system managed size."

echo "Turning off UAC..."
.\UAC_Off.ps1
echo "UAC turned off"

#Not required since generateMasterCofnig takes care of this
#echo "Pick correct master-config.env based on hostname & place at c:\setup\config..."
#$hostname = hostname
#$masterConfig = "C:\setup\config\Generate\master-config_" + $hostname + ".env" 
#if (Test-Path $masterConfig){
#Remove-item c:\setup\config\master-config.env
#Copy-Item $masterConfig c:\setup\config\master-config.env
#echo "Master-config replacement done!"
#}else{
#    echo "No master-config matching hostname found in C:\setup\config\Generate folder, continuing without replacing"
#}

echo "Generate master-config"
cd C:\setup\Scripts
.\generateMasterConfig.ps1
echo "Master-config generation & selection done"

echo "Starting software installation...."
cd C:\setup\Scripts
.\SoftwareInstall.ps1
echo Complete software installation !

echo "Starting Application installation...."
cd C:\setup\Scripts
.\AppInstall.ps1
echo "Complete Application installation !"

cd C:\
echo "Cleaning up the C:\TEMP folder"
Remove-item C:\TEMP -recurse
echo "Temporary folder cleaned up !"

#TIMEOUT /T 30
cd C:\setup\Scripts
./teatime.ps1 30

#Stopping Xstore
echo "Stopping Xstore..."
cd C:\setup\Scripts
./stop_xstore.ps1
echo "Xstore stopped !"
#TIMEOUT /T 10
./teatime.ps1 10

echo "Starting post installation process..."
cd C:\setup\Scripts
./post-installation.ps1

$endtime = get-date
$duration = $endtime - $starttime
write-host "The duration for script run was $($endtime - $starttime) in HH:MM:SS.MS format"
echo "Total Duration for installations = $duration"

#Running Xstore & Xenvironment
echo "Allow some time before starting Xenvironment..."
cd C:\environment
#.\start_eng.bat

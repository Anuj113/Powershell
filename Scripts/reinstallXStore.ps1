#Changing the execution policy of powershell to run powershell script in bypass/unrestricted mode.
Set-ExecutionPolicy -Scope CurrentUser -ExecutionPolicy bypass -Force
$starttime = get-date
echo "Execution policy changed to bypass for current user"

#Uninstall xstore
echo "Uninstalling XStore, xEnvoronment & XSTORE DB instance & listener to default port 1521"
.\unInstallXStore.ps1

echo "Pick correct master-config.env based on hostname & place at c:\setup\config..."
$hostname = hostname
$masterConfig = "C:\setup\config\Generate\master-config_" + $hostname + ".env" 
if (Test-Path $masterConfig){
Remove-item c:\setup\config\master-config.env
Copy-Item $masterConfig c:\setup\config\master-config.env
"Replaced master-config.env with " + $masterConfig | echo
}else{
    echo "No master-config matching hostname found in C:\setup\config\Generate folder, continuing without replacing"
}


echo "updating the ant.install.properties files in genkeys, xstore, xenvironment"
cd C:\setup\Scripts
.\generate-ant-install.ps1


echo "Generating host file..."
cd c:\setup\Scripts
.\generateHost.ps1
echo "Host generated...."

echo "Starting Application installation...."
cd C:\setup\Scripts
.\AppInstall.ps1
echo "Complete Application installation !"

#TIMEOUT /T 30
cd C:\setup\Scripts
./teatime.ps1 30

#Stopping Xstore
echo "Stopping Xstore..."
cd C:\setup\Scripts
./stop_xstore.ps1
echo "Xstore stopped !"
#TIMEOUT /T 10
./teatime.ps1 30

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
TIMEOUT /T 600
.\start_eng.bat

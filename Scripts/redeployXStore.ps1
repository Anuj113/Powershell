# #############################################################################
# ACCENTURE For TJX Inc. - SCRIPT - POWERSHELL
# 
# AUTHOR_Primary :  anuj.l.kumar@accenture.com
# AUTHOR_Secondary : s.vijaykumar.kothari@accenture.com
# DATE:  2016/05/10
# 
# COMMENT:  This script will update the XSTORE installation with the new code drop
#
# VERSION HISTORY
# Initial version 1.0
#
# #############################################################################

#Changing the execution policy of powershell to run powershell script in bypass/unrestricted mode.
Set-ExecutionPolicy -Scope CurrentUser -ExecutionPolicy bypass -Force
$starttime = get-date
echo "Execution policy changed to bypass for current user"

#Load master-config.env into hash table
$masterConfig = "C:\setup\config\master-config.env"
$MasterProps = convertfrom-stringdata ([IO.file]::ReadAllText($masterConfig))

#Stopping Xstore
echo "Stopping Xstore..."
cd C:\setup\Scripts
./stop_xstore.ps1
echo "Xstore stopped !"
./teatime.ps1 10

if ($MasterProps."listenerPort" -ne "1521")
{
	#Update listener to default port 
	lsnrctl stop XSTORE
	echo "Updating listener port to default 1521 ..."
	.\replaceText.ps1 -fileName "E:\\app\\oracle\\product\\12.1.0\\dbhome_1\\NETWORK\\ADMIN\\listener.ora" -oldValue $MasterProps."listenerPort" -newValue "1521"
	lsnrctl start XSTORE
	echo "Updating listener port done"
}
#Generate master-config.env based on hostname
echo "Pick correct master-config.env based on hostname & place at c:\setup\config..."
cd C:\setup\Scripts
./generateMasterConfig.ps1

#ReLoad master-config.env into hash table
$masterConfig = "C:\setup\config\master-config.env"
$MasterProps = convertfrom-stringdata ([IO.file]::ReadAllText($masterConfig))

#Extract code drop
echo "Extracting xstore from code drop"
cd C:\setup\Scripts
#Copying Xstore folder.
.\ExtractCodeDrop.ps1 >> C:\setup\Script_Log\ExtractCodeDrop.txt
echo "Complete!"

#Generate ant-install.properties
echo "updating the ant.install.properties files in xstore"
cd C:\setup\Scripts
.\generate-ant-install.ps1

#Generate Host file
echo "Generating host file..."
cd c:\setup\Scripts
.\generateHost.ps1
echo "Host generated...."

#Redeploying Xstore 
CD C:\setup\Scripts
./xstore.ps1
CD C:\setup\Scripts
./teatime.ps1 30
#Stopping Xstore
echo "Stopping Xstore..."
cd C:\setup\Scripts
./stop_xstore.ps1
echo "Xstore stopped !"
CD C:\setup\Scripts
./teatime.ps1 10
#Post-Installation changes
#echo "Starting post installation process..."
#cd C:\setup\Scripts
#$rtlLocId = $MasterProps."rtlLocId"
#$exactText = (Get-Content C:\environment\updates\base-xstore.properties) -match "installx.rtlLocId"
#if($exactText.Length > 0){
#.\replaceText.ps1 -fileName "C:\environment\updates\base-xstore.properties" -oldValue $exactText -newValue "installx.rtlLocId=$rtlLocId" }
#This update to rtlLocId has to be followed by execution of c:\environment\configure.bat which is executed as part of post-installation script below. Below call is tied to rtlLocId change as well
#./post-installation.ps1

#Replacing truststore & keystore
echo "Replacing truststore & keystore..."
Remove-item D:\xstore\res\ssl\* -recurse
#Remove-item C:\environment\res\ssl\* -recurse
 
#Copy-Item C:\setup\cert\xenv\ssl\* C:\environment\res\ssl
Copy-Item C:\setup\cert\xstore\ssl\* D:\xstore\res\ssl
echo "Replacing truststore & keystore done"

# If default listener port is non-standard, set it to the correct port value
if ($MasterProps."listenerPort" -ne "1521")
{
	#xstore listener port change
	echo "Updating listener port ..."
	cd c:\setup\scripts
	.\updateListenerPort.ps1 -oldValue "1521" -newValue $MasterProps."listenerPort"
	echo "UUpdating listener port done"
}

cd c:\setup\scripts
#Unlock accounts & reset password
echo "Unlocking account & resetting passwords..."
.\acntUnlockResetPwd.ps1
echo "Unlocking account & resetting passwords done"

# TODO: Add logic to reconfigure base-xstore.properties
mkdir d:\xstoredb\backup

icacls d:\xstore /t /q /c /reset
icacls d:\xstoredb /t /q /c /reset

cd c:\setup\scripts
Get-Content granttraining.sql | sqlplus / as sysdba

$hostname = hostname

if($hostname -match "00$")
{
	$storeid = $MasterProps."StoreId"
	cd c:\setup\scripts
	Get-Content PATCH-12-14-16.sql | sqlplus dtv/dtv
	cd c:\setup\config\dataloader
	copy-item "TAX_RATE_HGS_$storeid*" d:\xstore\download
	copy-item "*Hier*" d:\xstore\download
	d:\xstore\dataloader2.bat

}
else
{
	cd c:\setup\config
	copy-item cust_config d:\xstore -recurse
	
	# For PE only
	cd c:\setup\config
	
	$env = Import-Csv .\register-config.csv | where-object { $_.hostname -eq $hostname } | select -expandproperty Environment
	
	if ($env -match "PE")
	{
		cd c:\setup\scripts
		.\ "^#dtv.config.path(.):test:version1\test$"
		
		.\replaceText.ps1 -fileName "D:\xstore\system.properties" -oldValue "^#dtv.config.path.(.*)test$" -newValue 'dtv.config.path.$1test' 

		$exactText = (Get-Content D:\xstore\system.properties) -match "^#dtv.config.path(.)*:test:test/record$"

		.\replaceText.ps1 -fileName "D:\xstore\system.properties" -oldValue "^#dtv.config.path.(.*)record$" -newValue 'dtv.config.path.$1record' 
		
		D:\xstore\baseconfigure.bat
	}

}

$endtime = get-date
$duration = $endtime - $starttime
write-host "The duration for script run was $($endtime - $starttime) in HH:MM:SS.MS format"
echo "Total Duration for installations = $duration"

#Running Xstore & Xenvironment
echo "Allow some time before starting Xenvironment..."
#cd C:\environment

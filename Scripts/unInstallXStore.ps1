# #############################################################################
# ACCENTURE For TJX Inc. - SCRIPT - POWERSHELL
# 
# AUTHOR_Primary :  s.vijaykumar.kothari@accenture.com
# AUTHOR_Secondary : anuj.l.kumar@accenture.com
# DATE:  2016/05/10
# 
# COMMENT:  This script will uninstall XSTORE
#
# VERSION HISTORY
# Initial version 1.0
#
# #############################################################################

echo " Starting xstore reinstall process!"
Set-ExecutionPolicy -Scope CurrentUser -ExecutionPolicy bypass -Force
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

#Delete XSTORE DB instance
.\deleteDBXStore.ps1


#Update listener to default port
echo "Updating listener port to default 1521 ..."
lsnrctl stop XSTORE
.\replaceText.ps1 -fileName "D:\\app\\oracle\\product\\12.1.0\\dbhome_1\\NETWORK\\ADMIN\\listener.ora" -oldValue $MasterProps."listenerPort" -newValue "1521"
lsnrctl start XSTORE
echo "UUpdating listener port done"


#Remove XStore & xEnvironment
echo "Removing xstore & xenvironment"
Remove-item D:\xstore -recurse
Remove-item D:\xstoredb -recurse
Remove-item C:\BACKUPxstore -recurse



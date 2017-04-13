# #############################################################################
# ACCENTURE For TJX Inc. - SCRIPT - POWERSHELL
# 
# AUTHOR_Primary :  s.vijaykumar.kothari@accenture.com
# AUTHOR_Secondary : anuj.l.kumar@accenture.com
# DATE:  2016/05/10
# 
# COMMENT:  This script will update the listener port from default to required values
#
# VERSION HISTORY
# Initial version 1.0
#
# #############################################################################

param (
    [Parameter(Mandatory=$true)][string]$oldValue,
    [Parameter(Mandatory=$true)][string]$newValue
 )
lsnrctl stop XSTORE
.\replaceText.ps1 -fileName "E:\\app\\oracle\\product\\12.1.0\\dbhome_1\\NETWORK\\ADMIN\\listener.ora" -oldValue $oldValue -newValue $newValue
lsnrctl start XSTORE
"ALTER SYSTEM SET LOCAL_LISTENER =`"(ADDRESS = (PROTOCOL = TCP)(HOST = $env:COMPUTERNAME)(PORT = $newValue))`";
shutdown;
startup;
"| sqlplus / as sysdba

.\replaceText.ps1 -fileName "D:\\xstore\\updates\\base-xstore.properties" -oldValue $oldValue -newValue $newValue
D:\xstore\baseconfigure.bat

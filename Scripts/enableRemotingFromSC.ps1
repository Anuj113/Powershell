# #############################################################################
# ACCENTURE For TJX Inc. - SCRIPT - POWERSHELL
# 
# AUTHOR_Primary :  anuj.l.kumar@accenture.com
# AUTHOR_Secondary : s.vijaykumar.kothari@accenture.com
# DATE:  2016/05/10
# 
# COMMENT:  This script will enable the remote connection between store controller & registers
#
# VERSION HISTORY
# Initial version 1.0
#
# #############################################################################

$hostName = HOSTNAME.EXE
$registerIPList=""
#Check if store controller
if ($hostName -like "TJH*00")
{
#this is a store controller
$registerIPList = .\fetchRegistersInStore.ps1
$regCSVList = ""
foreach ($reg in $registerIPList){
$regCSVList = $regCSVList +$reg +","
}
$registerIPList =$regCSVList.TrimEnd(",")

Enable-PSRemoting -Force
Set-Item -Path WSMan:\localhost\Client\TrustedHosts -Value $registerIPList -Force
Get-Item WSMan:\localhost\Client\TrustedHosts
Enable-WSManCredSSP -Role Client –DelegateComputer * -Force
}
else{
# This a register
$storeController = $hostName.substring(0,$hostName.length -2) + "00"
$registerIPList = $storeController

Enable-PSRemoting -Force
Set-Item -Path WSMan:\localhost\Client\TrustedHosts -Value $registerIPList -Force
Get-Item WSMan:\localhost\Client\TrustedHosts
Enable-WSManCredSSP -Role Server -Force
}



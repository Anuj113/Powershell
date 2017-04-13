# #############################################################################
# ACCENTURE For TJX Inc. - SCRIPT - POWERSHELL
# 
# AUTHOR_Primary :  anuj.l.kumar@accenture.com
# AUTHOR_Secondary : s.vijaykumar.kothari@accenture.com
# DATE:  2016/05/10
# 
# COMMENT:  This script will configure/edit XSTORE setting/files after the installation
#
# VERSION HISTORY
# Initial version 1.0
#
# #############################################################################

#Load master-config.env into hash table
$masterConfig = "C:\setup\config\master-config.env"
$MasterProps = convertfrom-stringdata ([IO.file]::ReadAllText($masterConfig))

if ($MasterProps."listenerPort" -ne "1521")
{ 
    #xstore listener port change
    echo "Updating listener port ..."
    .\updateListenerPort.ps1 -oldValue "1521" -newValue $MasterProps."listenerPort"
    echo "UUpdating listener port done"
}

#Unlock accounts & reset password
echo "Unlocking account & resetting passwords..."
.\acntUnlockResetPwd.ps1
echo "Unlocking account & resetting passwords done"

mkdir d:\xstoredb\backup

icacls d:\xstore /t /q /c /reset
icacls d:\xstoredb /t /q /c /reset

cd c:\setup\scripts
Get-Content granttraining.sql | sqlplus / as sysdba

#Replacing truststore & keystore
echo "Replacing truststore & keystore..."
Remove-item D:\xstore\res\ssl\* -recurse
Remove-item D:\environment\res\ssl\* -recurse
 
Copy-Item C:\setup\cert\xenv\ssl\* D:\environment\res\ssl
Copy-Item C:\setup\cert\xstore\ssl\* D:\xstore\res\ssl
echo "Replacing truststore & keystore done" 
 
#Remover cipher from xenv and copying from xstore
echo "Replacing xenv cipher..."
Remove-item D:\environment\res\keys\* -recurse
Copy-Item D:\xstore\res\keys\config.cip D:\environment\res\keys
echo "Replacing xenv cipher done"
 
#Update salt in xenv base-xstore.properties 
echo "Updating salt in xenv base-xstore.properties ..."
 
#xenvironment salt update
$saltNewValue = $MasterProps."customerId.salt"
.\replaceText.ps1 -fileName "D:\environment\updates\base-xstore.properties" -oldValue "installx.clientCode.salt=(.)*$" -newValue "installx.clientCode.salt=$saltNewValue"
$ohs = $MasterProps."uploadHttpServerURL"
.\replaceText.ps1 -fileName "D:\environment\updates\base-xstore.properties" -oldValue "installx.uploadHttpServerURL=(.)*$" -newValue "installx.uploadHttpServerURL=https\://$ohs\:443"

# All xenvironment to find xstore in D Drive
$hostname = hostname
copy-item d:\environment\config\application-context.xml "d:\environment\config\application-context.xml.$date" -force
copy-item d:\environment\cust_config\version1\actions.properties "d:\environment\cust_config\version1\actions.properties.$date" -force
copy-item d:\environment\cust_config\version1\environment.properties "d:\environment\cust_config\version1\environment.properties.$date" -force
copy-item c:\setup\config\custom\environment.properties d:\environment\cust_config\version1\environment.properties -force

if ($hostname -match "00$")
{
	# Controller
	copy-item c:\setup\config\custom\controller\application-context.xml d:\environment\config\application-context.xml -force
	copy-item c:\setup\config\custom\controller\actions.properties d:\environment\cust_config\version1\actions.properties -force
	
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
	# Register
	copy-item c:\setup\config\custom\register\actions.properties d:\environment\cust_config\version1\actions.properties -force
	cd c:\setup\config
	copy-item cust_config d:\xstore -recurse
}

D:\environment\configure.bat
#$exactText = (Get-Content D:\environment\system.properties) -match "dtv.env.access.customercode" 
# Deprecated with environment 15.0.1.168c
#if($exactText.Length > 0){
#.\replaceText.ps1 -fileName "C:\environment\system.properties" -oldValue $exactText -newValue "dtv.env.access.customercode=$saltNewValue"}
#echo "Updating salt in xenv base-xstore.properties done" 


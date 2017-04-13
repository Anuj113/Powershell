# #############################################################################
# ACCENTURE For TJX Inc. - SCRIPT - POWERSHELL
# 
# AUTHOR_Primary :  s.vijaykumar.kothari@accenture.com
# AUTHOR_Secondary : anuj.l.kumar@accenture.com
# DATE:  2016/05/10
# 
# COMMENT:  This script will unlock the DB user accounts( Workaround for a defect ) 
#
# VERSION HISTORY
# Initial version 1.0
#
# #############################################################################

#Load master-config.env into hash table
$acntConfig = "C:\setup\config\acntInfo.env"
$acntProps = convertfrom-stringdata ([IO.file]::ReadAllText($acntConfig))

#Unlock locked accounts and set initial password
cd c:\setup\scripts
if (Test-Path c:\setup\scripts\acntUnlock.sql){
    Remove-item c:\setup\scripts\acntUnlock.sql}
""| Set-Content acntUnlock.sql

foreach ($prop in $acntProps.Keys) {
    $val = $acntProps.$prop
    $capsProp = $prop.ToUpper() 
    "    ALTER USER $prop IDENTIFIED BY $val ACCOUNT UNLOCK;"| Add-Content acntUnlock.sql
 }
Get-Content acntUnlock.sql | sqlplus / as sysdba

#Reset password
if (Test-Path c:\setup\scripts\resetPwd.sql){
    Remove-item c:\setup\scripts\resetPwd.sql}

"DECLARE"| Set-Content resetPwd.sql
"    pwd VARCHAR2(2000);" | Add-Content resetPwd.sql
"    statement VARCHAR2(5000);" | Add-Content resetPwd.sql 
"BEGIN" | Add-Content resetPwd.sql

foreach ($prop in $acntProps.Keys) {
    $val = $acntProps.$prop
    $capsProp = $prop.ToUpper() 
    "    SELECT SPARE4 INTO pwd FROM USER$ WHERE NAME='$capsProp';" | Add-Content resetPwd.sql
    "    statement :='ALTER USER $prop IDENTIFIED BY VALUES ''' || pwd || '''';" | Add-Content resetPwd.sql
    "    EXECUTE IMMEDIATE(statement);"| Add-Content resetPwd.sql
    "" | Add-Content resetPwd.sql
} 
"END;" | Add-Content resetPwd.sql

Get-Content resetPwd.sql | sqlplus / as sysdba


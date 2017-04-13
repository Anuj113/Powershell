# #############################################################################
# ACCENTURE For TJX Inc. - SCRIPT - POWERSHELL
# 
# AUTHOR_Primary :  s.vijaykumar.kothari@accenture.com
# AUTHOR_Secondary : anuj.l.kumar@accenture.com
# DATE:  2016/05/10
# 
# COMMENT:  This script will install XSTORE in the system
#
# VERSION HISTORY
# Initial version 1.0
#
# #############################################################################

#Installing XSTORE
$env:ORACLE_SID="XSTORE"
$env:Path+= ";E:\app\oracle\product\12.1.0\dbhome_1\bin;C:\jre\bin;"
#$point = Get-ChildItem -name -include "*point*" -path "C:\xstoreinstall\software"
#$pointdir = "C:\xstoreinstall\software" + $point
#CD $pointdir\15*\pos
$xstoreInstallBasedir = "C:\xstoreinstall\software"
$point = Get-ChildItem -name -include "xstore-*pos*jar" -path "$xstoreInstallBasedir" -recurse | % {Split-Path -Path "$xstoreInstallBasedir\$_.FullName"}
cd $point
Get-ChildItem xstore*.jar | ForEach-Object{$jarfile = $_.Name}
C:\jre\bin\java -jar $jarfile
#mkdir c:\xstoredb\backup
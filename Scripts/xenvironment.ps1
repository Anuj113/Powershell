# #############################################################################
# ACCENTURE For TJX Inc. - SCRIPT - POWERSHELL
# 
# AUTHOR_Primary :  s.vijaykumar.kothari@accenture.com
# AUTHOR_Secondary : anuj.l.kumar@accenture.com
# DATE:  2016/05/10
# 
# COMMENT:  This script will install XENVIRONMENT in the system
#
# VERSION HISTORY
# Initial version 1.0
#
# #############################################################################

#Installing XENVIRONMENT
#$xenv = Get-ChildItem -name -include "*xenvironment*" -path "C:\xstoreinstall\software"
#$xenvDir = "C:\xstoreinstall\software\" + $xenv
#CD $xenvDir
$xstoreInstallBasedir = "C:\xstoreinstall\software"
$xenv = Get-ChildItem -name -include "xenvironment-*jar" -path "$xstoreInstallBasedir" -recurse | % {Split-Path -Path "$xstoreInstallBasedir\$_.FullName"}
cd $xenv
Get-ChildItem xenvironment*.jar | ForEach-Object{$jarfile = $_.Name}
C:\jre\bin\java -jar $jarfile


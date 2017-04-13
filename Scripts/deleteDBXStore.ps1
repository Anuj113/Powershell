# #############################################################################
# ACCENTURE For TJX Inc. - SCRIPT - POWERSHELL
# 
# AUTHOR_Primary :  anuj.l.kumar@accenture.com
# AUTHOR_Secondary : s.vijaykumar.kothari@accenture.com
# DATE:  2016/05/10
# 
# COMMENT:  This script will uninstall only XSTORE DB from the system.
#
# VERSION HISTORY
# Initial version 1.0
#
# #############################################################################

echo "Deleting XSTORE DB instance"
dbca -silent -deleteDatabase -sourceDB XSTORE

Remove-item E:\app\oracle\admin -recurse -force
Remove-item E:\app\oracle\audit -recurse -force
Remove-item E:\app\oracle\fast_recovery_area -recurse -force
Remove-item E:\app\oracle\oradata -recurse -force




echo "Please do not interupt !! Software Uninstalltion is in progress... "
Set-ExecutionPolicy -Scope CurrentUser -ExecutionPolicy bypass -Force

echo "Oracle Database - In Progress..."
#Uninstalling Oracle Database.
cd C:\setup\Scripts\Rollback
./OracleDB_uninstall.ps1
echo "Oracle 12C DB - Done!"

echo "7zip - In Progress..."
cd C:\setup\Scripts\Rollback
#Uninstalling 7zip with powershell script.
PowerShell C:\setup\Scripts\Rollback\7zip_uninstall.ps1
echo "7zip Uninstalled!"

cd C:\Program Files (x86)\
echo "Notepad++ - In Progress..."
cd C:\setup\Scripts\Rollback
#Uninstalling Notepad++ with powershell script.
PowerShell C:\setup\Scripts\Rollback\NPP_uninstall.ps1
echo "Notepad++ Uninstalled!"

Remove-item C:\app -recurse
Remove-item C:\jre -recurse
Remove-item C:\xstore -recurse
Remove-item C:\xstoredb -recurse
Remove-item C:\xstore-genkeys -recurse
Remove-item C:\xstoreinstall -recurse
Remove-item C:\environment -recurse
Remove-item C:\BACKUPxstore -recurse
Remove-item C:\TEMP -recurse
Remove-item "C:\Program Files\Oracle" -recurse
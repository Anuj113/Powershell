function orauninstall()
{
	C:\app\oracle\product\12.1.0\dbhome_1\deinstall\deinstall.bat -silent -paramfile C:\setup\Scripts\Rollback\deinstall.rsp
	remove-item C:\app -recurse
	write-host "Oralce 12c with XSTORE DB unistalled successfully !" -ForegroundColor Green
}
$orac = test-path "C:\app\oracle\product\12.1.0\dbhome_1\deinstall\deinstall.bat"
if($orac -eq $True)
{
	echo "Stopping services..."
	Stop-Service OracleJobSchedulerXSTORE
	Stop-Service OracleOraDB12Home1TNSListener
	Stop-Service OracleRemExecServiceV2
	Stop-Service OracleServiceXSTORE
	Stop-Service OracleVssWriterXSTORE
	echo "Stopped ! Uninstallation is in progress..."
	orauninstall
}
if($orac -eq $False)
{
	write-host "Oralce 12c not present on the system" -ForegroundColor Red
}

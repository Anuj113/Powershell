param (
   [Parameter(Mandatory=$true)][string]$username,
    [Parameter(Mandatory=$true)][string]$password
)
#Changing the execution policy of powershell to run powershell script in bypass/unrestricted mode.
Set-ExecutionPolicy -Scope CurrentUser -ExecutionPolicy bypass -Force
$starttime = get-date
echo "Execution policy changed to bypass for current user"

echo " Fetch IP of registers in this store"
cd c:\setup\scripts
$regIPList = .\fetchRegistersInStore.ps1
$regIPList | set-content c:\setup\config\registers.txt
echo $regList

$SecurePassword = ConvertTo-SecureString "$password" -AsPlainText -Force
$cred = New-Object System.Management.Automation.PSCredential -ArgumentList $username, $SecurePassword
#Establish Remote session with these registers
echo "Establish Remote session with these registers"
$session = New-PSSession -ComputerName (get-content c:\setup\config\registers.txt) -Credential $cred #Administrator -Authentication Credssp
echo "Session established"

#Stop xstore on store controller
echo "Stopping Xstore on this system..."
cd C:\setup\Scripts
./stop_xstore.ps1
echo "Xstore stopped !"
#TIMEOUT /T 10 >$null
#ping 127.0.0.1 -n 11 > $null
./teatime.ps1 10
#Stop xstore on all registers in this store
echo "Stop Xstore on all registers in this store..."
cd C:\setup\Scripts
Invoke-Command -Session $session -FilePath C:\setup\Scripts\stop_xstore.ps1
echo "Xstore stopped on all registers!"
#TIMEOUT /T 10 >$null
#ping 127.0.0.1 -n 11 > $null
./teatime.ps1 10
#Redeploy xstore on this store
echo "Redeploy xstore on this store controller"
./redeployxStore.ps1
echo "Redeployment completed on this store controller"
#TIMEOUT /T 60 >$null
#ping 127.0.0.1 -n 61 > $null
./teatime.ps1 60
#Redeploy xstore on all registers in this store
echo "Redeploy xstore on all registers in this store"
Invoke-Command -Session $session -ScriptBlock {C:\setup\Scripts\redeployxStore.ps1} -AsJob -JobName "RedeployStore"
Wait-Job -Name "RedeployStore"
Receive-Job -Name "RedeployStore" |Write-Host
echo "Redeployment completed on all registers in store "
#TIMEOUT /T 60 >$null
#ping 127.0.0.1 -n 61 > $null
./teatime.ps1 60
$session | Remove-PSSession

$endtime = get-date
$duration = $endtime - $starttime
write-host "The duration for script run was $($endtime - $starttime) in HH:MM:SS.MS format"
echo "Total Duration for installations = $duration"

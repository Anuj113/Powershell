param (
    [Parameter(Mandatory=$true)][string]$sharePath,
    [Parameter(Mandatory=$true)][string]$shareUser,
    [Parameter(Mandatory=$true)][string]$sharePassword
 )

#Changing the execution policy of powershell to run powershell script in bypass/unrestricted mode.
Set-ExecutionPolicy -Scope CurrentUser -ExecutionPolicy bypass -Force
$starttime = get-date
echo "Execution policy changed to bypass for current user"

#Update script package on this store controller
echo "Update script package on this store controller"
.\UpdateScriptPackage.ps1 -sharePath $sharePath -shareUser $shareUser -sharePassword $sharePassword
echo "Script package updated on this store controller!"
#TIMEOUT /T 60
cd C:\setup\Scripts
./teatime.ps1 60


#Enable Remoting for this system
cd c:\setup\scripts
echo "Enable Remoting from this store controller"
.\enableRemotingFromSC.ps1


echo " Fetch IP of registers in this store"
cd c:\setup\scripts
$regIPList = .\fetchRegistersInStore.ps1
$regIPList | set-content c:\setup\config\registers.txt
echo $regIPList

#Establish Remote session with these registers
echo "Establish Remote session with these registers"
$session = New-PSSession -ComputerName (get-content c:\setup\config\registers.txt) -Credential Administrator -Authentication Credssp
echo "Session established"


#Update script package on all registers in this store
echo "Update script package on all registers in this store..."
Invoke-Command -Session $session -FilePath C:\setup\Scripts\UpdateScriptPackage.ps1 -ArgumentList $sharePath,$shareUser,$sharePassword -AsJob -JobName "PackageUpdate"
Wait-Job -Name "PackageUpdate"
Receive-Job -Name "PackageUpdate" |write-host
echo "Script package updated on all registers in this store!"
#TIMEOUT /T 10
cd C:\setup\Scripts
./teatime.ps1 10

$session | Remove-PSSession

$endtime = get-date
$duration = $endtime - $starttime
write-host "The duration for script run was $($endtime - $starttime) in HH:MM:SS.MS format"
echo "Total Duration for installations = $duration"

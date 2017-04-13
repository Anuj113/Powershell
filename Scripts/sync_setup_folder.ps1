param (
    [Parameter(Mandatory=$true)][string]$user,
    [Parameter(Mandatory=$true)][string]$pass
)

$baseDir = (Split-Path $MyInvocation.MyCommand.Definition)

cd C:\Setup\scripts
.\generateMasterConfig.ps1

echo " Fetch IP of registers in this store"
cd $baseDir
$systems = .\fetchRegistersInStore.ps1
$systems | set-content c:\setup\config\registers.txt
echo $systems


$SecurePassword = ConvertTo-SecureString $pass -AsPlainText -Force
$cred = New-Object System.Management.Automation.PSCredential -ArgumentList $user, $SecurePassword

foreach ($server in $systems){
	echo $server
	Invoke-Command -ComputerName $server -ScriptBlock{$date = get-date; $datestr = '{0:yyyyMMddHHMMss}' -f $date; $dest = 'C:\Setup' + $datestr; Rename-Item -path C:\Setup -newname $dest} -Credential $cred
	& $baseDir\network_copy_folder.ps1 "C:\setup" "\\$server\C$" "$server\$user" $pass
}

#Load master-config.env into hash table
#$masterConfig = "C:\setup\config\master-config.env" 
#$MasterProps = convertfrom-stringdata ([IO.file]::ReadAllText($masterConfig))

#$storeControllerIp = $MasterProps."storeControllerIp"
#$storeControllerHostName = $MasterProps."storeprimary.host"

#$storeControllerConfig = $storeControllerIp + "                       " + $storeControllerHostName
#Copy-Item C:\setup\config\template\hosts C:\Windows\System32\drivers\etc\hosts
#Add-Content C:\Windows\System32\drivers\etc\hosts "`n $storeControllerConfig"



$hostName = Hostname
$storeName = $hostName.Substring(0,$hostName.Length -2) + "*" 
$registerConfig = Import-CSV C:\setup\config\register-config.csv
$registerIPList=$registerConfig | Where { ($_.Hostname -like $storeName)} 
Copy-Item C:\setup\config\template\hosts C:\Windows\System32\drivers\etc\hosts -Force
Add-Content C:\Windows\System32\drivers\etc\hosts "`n"
foreach($item in $registerIPList){
$storeControllerConfig = $item.{IP address} + "                       " + $item.{Hostname}
Add-Content C:\Windows\System32\drivers\etc\hosts "$storeControllerConfig"
}

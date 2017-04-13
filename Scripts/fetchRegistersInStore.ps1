$hostName = hostname
$storeName = $hostName.Substring(0,$hostName.Length -2) + "*" 
$registerConfig = Import-CSV C:\setup\config\register-config.csv
$registerIPList=$registerConfig | Where { ($_.Hostname -ne $hostName ) -and ($_.Hostname -like $storeName)} | % {$_.{IP address}}
$registerIPList
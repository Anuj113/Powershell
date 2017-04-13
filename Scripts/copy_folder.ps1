param (
   [Parameter(Mandatory=$true)][string]$source,
   [Parameter(Mandatory=$true)][string]$destination,
   [Parameter(Mandatory=$true)][string]$username,
   [Parameter(Mandatory=$true)][string]$password

 )

$WebClient = New-Object System.Net.WebClient
$WebClient.Credentials = New-Object System.Net.NetworkCredential($Username, $Password)
#net use $source $password /USER:$username
try{
	$remote = test-path $source
	if($remote -eq $TRUE)
			{	
				if((Test-Path $destination) -eq $TRUE)
				{
					write-host "Target ($destination) already exist.Replacing from source..." -ForegroundColor Yellow
					if((Test-Path $destination -PathType Container) -eq $TRUE) {
                        remove-item $destination -recurse -force
                    }
                    Copy-Item -Path $source -Destination $destination -Recurse -Force
					write-host "Target ($destination) replaced successfully" -ForegroundColor Green
				}
				else
				{
					Copy-Item -Path $source -Destination $destination -Recurse
					write-host "Target ($destination) copied successfully from source" -ForegroundColor Green
				}
			}
			

	
	else
		{
			Write-host "No such directory present on:" $source -ForegroundColor Red
		}
	}
catch
{
	Write-host "Encountered some issue while copying... :(" -ForegroundColor Red
}
	

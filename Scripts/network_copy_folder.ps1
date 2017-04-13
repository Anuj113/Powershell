# #############################################################################
# ACCENTURE For TJX Inc. - SCRIPT - POWERSHELL
# 
# AUTHOR_Primary :  anuj.l.kumar@accenture.com
# AUTHOR_Secondary : s.vijaykumar.kothari@accenture.com
# DATE:  2016/05/10
# 
# COMMENT:  This script will copy items from remote location
#
# VERSION HISTORY
# Initial version 1.0
#
# #############################################################################

param (
   [Parameter(Mandatory=$true)][string]$source,
    [Parameter(Mandatory=$true)][string]$destination,
    [Parameter(Mandatory=$true)][string]$user,
    [Parameter(Mandatory=$true)][string]$pass

 )
 
#$Username = $user
#$Password = $pass
#$WebClient = New-Object System.Net.WebClient
#$WebClient.Credentials = New-Object System.Net.NetworkCredential($Username, $Password)

try{
	$remote = test-path $source
	if($remote -eq $TRUE)
			{	
				$testpath = "$destination" + "testshare"
				$folder = test-path $testpath
				
				#deprecated and in clear text...should use something else, but it works
				net use $destination /user:$user $pass
				if($folder -eq $TRUE)
				{
					write-host "Folder already exist. updating the folder..." -ForegroundColor Yellow
					remove-item $testpath -recurse
					Copy-item $source -recurse $destination
					write-host "Folder updated successfully" -ForegroundColor Green
				}
				if($folder -eq $FALSE)
				{
					Copy-item $source -recurse $destination -force
					write-host "Folder Copied successfully" -ForegroundColor Green
				}

			net use /delete $destination				
			}
			

	
	if($remote -eq $FALSE)
		{
			Write-host "No such directory present on:" $source -ForegroundColor Red
		}
	}
catch
{
	Write-host "Encountered some issue with remote copying... :(" -ForegroundColor Red
}
	
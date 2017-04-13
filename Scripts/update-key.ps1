#----taking the 3 parameters
param (
    [Parameter(Mandatory=$true)][string]$filename,
    [Parameter(Mandatory=$true)][string]$key,
    [Parameter(Mandatory=$true)][string]$newvalue
  
 )
 $file = test-path $filename 

#----checking if file is present in location or not

 if ($file -eq $true)
 {

  write-host "File Found !!!!" -Foregroundcolor green
 #----checking if entered key is correct or not

    $fileProps = convertfrom-stringdata ([IO.file]::ReadAllText($filename))

    if($fileProps.ContainsKey($key))
   
	{
        $oldValue = $fileProps.$key	    
        $oldValue | Write-Host
        $oldKeyPair = [string]((Get-Content $filename) -match "$key\s*=\s*$oldValue")
        $oldKeyPair | Write-Host
        .\replaceText.ps1 -fileName $filename -oldValue $oldKeyPair -newValue "$key=$newvalue"
	    write-host "Updating Values...." -Foregroundcolor green

 		
	}
   else
	{

        #----adding a newvalue key

	write-host "Key Not Found !!!!" -Foregroundcolor red
	add-content $filename ($key+" = "+$newvalue)
 	}
 }
 else 
 {
 write-host "file not found" -Foregroundcolor red
 }
 
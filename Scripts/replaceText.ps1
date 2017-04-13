param (
    [Parameter(Mandatory=$true)][string]$fileName,
    [Parameter(Mandatory=$true)][string]$oldValue,
    [Parameter(Mandatory=$true)][string]$newValue
 )

 (Get-Content $fileName) -replace $oldValue, $newValue | Set-Content $fileName

 
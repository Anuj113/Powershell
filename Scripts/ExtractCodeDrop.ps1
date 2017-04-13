function extract{
	
	if (-NOT ([string]::IsNullOrEmpty($code)) -and (Test-Path $source)){
		Get-ChildItem "$installerDir\$code" | % {& "C:\Program Files\7-Zip\7z.exe" "x" $_.fullname "-o$installerDir" "-y"}
		cd $xstoreInstallBasedir
	}
	else{
	
	}

        $xstoreCode = Get-ChildItem -name "$installerDir\OracleRetail*oint*.zip" 
        $xenvCode = Get-ChildItem -name "$installerDir\*vironment*.zip"
	
	if (-NOT ([string]::IsNullOrEmpty($xstoreCode)))
	{
        $xstoreDirName = $xstoreCode -replace '.zip',""
        mkdir $xstoreInstallBasedir\$xstoreDirName
		Get-ChildItem "$installerDir\$xstoreCode" | % {& "C:\Program Files\7-Zip\7z.exe" "x" $_.fullname "-o$xstoreInstallBasedir\$xstoreDirName" "-y"}
		#remove-item $xstoreInstallBasedir\$xstoreCode
		Write-Host "Done !, configuring xstore..." -ForegroundColor Green
	}
	
	if (-NOT ([string]::IsNullOrEmpty($xenvCode)))
	{
        $xenvDirName = $xenvCode -replace '.zip',""
        mkdir $xstoreInstallBasedir\$xenvDirName
		Get-ChildItem "$installerDir\$xenvCode" | % {& "C:\Program Files\7-Zip\7z.exe" "x" $_.fullname "-o$xstoreInstallBasedir\$xenvDirName" "-y"}
		#remove-item $envzip
		Write-Host "Done !, configuring xenvironment..." -ForegroundColor Green
		
	}
		
}			

$installerDir = "C:\setup\Installers"
$code = Get-ChildItem -name "C:\setup\installers\TJX*.*z*"
$xstoreInstallBasedir = "C:\xstoreinstall\software"

try{
	$source = "$installerDir\$code"
	$destination = "$xstoreInstallBasedir\$code"
	
	if((test-path "$xstoreInstallBasedir") -eq $True)
	{
		Write-Host "Folder already exists, replacing with new one..." -ForegroundColor Yellow
		remove-item "C:\xstoreinstall" -recurse -Force
		#remove-item "C:\xstore-genkeys" -recurse
		mkdir $xstoreInstallBasedir
		#mkdir C:\xstoreinstall\Tools\genkeys
		extract
		Write-Host "Complete." -ForegroundColor Green
	}
	else
	{
		Write-Host "Unzipping In-progress..." -ForegroundColor Green
		mkdir $xstoreInstallBasedir
		#mkdir C:\xstoreinstall\Tools\genkeys
		extract
		Write-Host "Complete." -ForegroundColor Green
	}

 } 
catch {
			Write-Warning "XStore unziping has failed"
	}
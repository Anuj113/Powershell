# #############################################################################
# ACCENTURE For TJX Inc. - SCRIPT - POWERSHELL
# 
# AUTHOR_Primary :  anuj.l.kumar@accenture.com
# AUTHOR_Secondary : s.vijaykumar.kothari@accenture.com
# DATE:  2016/05/10
# 
# COMMENT:  This script will unzip the code drop and place it in the appropriate Folder.
#
# VERSION HISTORY
# Initial version 1.0
#
# #############################################################################

$code = Get-ChildItem -name "C:\setup\installers\TJX*.zip"
$xstoreCode = Get-ChildItem -name "C:\setup\installers\OracleRetail*point*.zip"
$xstoreInstallBasedir = "C:\xstoreinstall\software"
$xenvCode = Get-ChildItem -name "C:\setup\installers\*Xenvironment*.zip"

									
function extract{
					
					if (-NOT ([string]::IsNullOrEmpty($code)) -and (Test-Path $source)){
						#Copy-item -path $source -Destination $destination -Force

						#$shell = New-Object -ComObject shell.application
						Get-ChildItem "C:\setup\Installers\$code" | % {& "C:\Program Files\7-Zip\7z.exe" "x" $_.fullname "-o$xstoreInstallBasedir"}
						#$zip = $shell.NameSpace("$xstoreInstallBasedir\" + $code)
						#foreach ($item in $zip.items()) {
						#$shell.Namespace("$xstoreInstallBasedir").CopyHere($item)
						#					}

						cd $xstoreInstallBasedir
						remove-item $code
					}
					else{
						if (-NOT ([string]::IsNullOrEmpty($xstoreCode)))
						{
							Copy-item -path $xstoreSource -Destination $xstoreDestination -Force
						}
						if (-NOT ([string]::IsNullOrEmpty($xenvCode)))
						{
							Copy-item -path $xenvSource -Destination $xenvDestination -Force
						}
						
						#TODO: Add third check where all *code strings are empty

					}
					
					if (-NOT ([string]::IsNullOrEmpty($xstoreCode)))
					{
						#$commonzip = Get-ChildItem -name -include "*common*" -path "$xstoreInstallBasedir"
						#$common = $commonzip -replace '.zip',""
						#$commondir = "$xstoreInstallBasedir\" + $common
						#echo "shell"
						$pointzip = Get-ChildItem -name -include "*point*" -path "$xstoreInstallBasedir"
						$point = $pointzip -replace '.zip',""
						$pointDir = "$xstoreInstallBasedir\" + $point
						
						set-location -path "$xstoreInstallBasedir\"
						#mkdir $common
						#$shell = New-Object -ComObject shell.application
						#$zip = $shell.NameSpace("$xstoreInstallBasedir\" + $commonzip)
						#foreach ($item in $zip.items()) {
						#$shell.Namespace("$xstoreInstallBasedir\" + $common).CopyHere($item)
						#		}

						#mkdir $pointdir
						#$shell = New-Object -ComObject shell.application
						#$zip = $shell.NameSpace("$xstoreInstallBasedir\" + $pointzip)
						#foreach ($item in $zip.items()) {
						#$shell.Namespace("$xstoreInstallBasedir\" + $point).CopyHere($item)
						#	}
							#remove-item $commonzip
						Get-ChildItem "$xstoreInstallBasedir\$pointzip" | % {& "C:\Program Files\7-Zip\7z.exe" "x" $_.fullname "-o$xstoreInstallBasedir"}
						remove-item $pointzip
						Write-Host "Done !, configuring xstore..." -ForegroundColor Green
					}
					
					if (-NOT ([string]::IsNullOrEmpty($xenvCode)))
					{
					
						$envzip = Get-ChildItem -name -include "*Xenvironment**" -path "$xstoreInstallBasedir"
						$env = $envzip -replace '.zip',""
						$envDir = "$xstoreInstallBasedir\" + $env
						
						set-location -path "$xstoreInstallBasedir\"
						
						Get-ChildItem "$xstoreInstallBasedir\$envzip" | % {& "C:\Program Files\7-Zip\7z.exe" "x" $_.fullname "-o$xstoreInstallBasedir"}
						remove-item $envzip
						Write-Host "Done !, configuring xenvironment..." -ForegroundColor Green
						
					}
						
				}
Measure-Command{
				
	ForEach-Object{
				try{
				
					$source = "C:\setup\Installers\$code"
					$destination = "$xstoreInstallBasedir\$code"
					
					$xstoreSource = "C:\setup\Installers\" + $xstoreCode
					$xstoreDestination = "$xstoreInstallBasedir\" + $xstoreCode
					
					$xenvSource = "C:\setup\Installers\" + $xenvCode
					$xenvDestination = "$xstoreInstallBasedir\" + $xenvCode

					$dest = test-path "$xstoreInstallBasedir"
					
					if($dest -eq $True)
					{
						Write-Host "Folder already exists, replacing with new one..." -ForegroundColor Yellow
						remove-item "C:\xstoreinstall" -recurse
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

					

} 
}
				
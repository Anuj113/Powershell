function extract(){
					Get-ChildItem C:\setup\Installers\TJX*.zip | % {& "C:\Program Files\7-Zip\7z.exe" "x" $_.fullname "-oC:\xstoreinstall\software\windows_64_oracle_install,upgrade"}
					
					$commonzip = Get-ChildItem -name -include "*common*" -path "C:\xstoreinstall\software\windows_64_oracle_install,upgrade"
					$common = $commonzip -replace '.zip',""
					$commondir = "C:\xstoreinstall\software\windows_64_oracle_install,upgrade\" + $common
					
					$pointzip = Get-ChildItem -name -include "*point*" -path "C:\xstoreinstall\software\windows_64_oracle_install,upgrade"
					$point = $pointzip -replace '.zip',""
					$pointdir = "C:\xstoreinstall\software\windows_64_oracle_install,upgrade\" + $point
					
					set-location -path "C:\xstoreinstall\software\windows_64_oracle_install,upgrade\"
					mkdir $common
					Get-ChildItem "C:\xstoreinstall\software\windows_64_oracle_install,upgrade\OracleRetailXstoreCommon*.zip" | % {& "C:\Program Files\7-Zip\7z.exe" "x" $_.fullname "-o$commondir"}
					

					mkdir $point
					Get-ChildItem "C:\xstoreinstall\software\windows_64_oracle_install,upgrade\OracleRetailXstorepoint*.zip" | % {& "C:\Program Files\7-Zip\7z.exe" "x" $_.fullname "-o$pointdir"}
					
						remove-item $commonzip
						remove-item $pointzip
						Write-Host "Done !, configuring genkeys..." -ForegroundColor Green
						
						$genkeys = test-path $commondir\15*\tools\genkeys
						if($genkeys -eq $True)
						{
						cd $commondir\15*\tools\genkeys
						Copy-item -path * -Destination C:\xstoreinstall\Tools\genkeys -Force

						cd C:\xstoreinstall\Tools\genkeys\
						Get-ChildItem xstore*.jar | ForEach-Object{$jarfile = $_.Name}
						C:\jre\bin\java -jar $jarfile

						remove-item C:\xstore-genkeys\wrapper\conf\gen-keys.conf
						Copy-item -path C:\setup\Scripts\gen-keys.conf -Destination C:\xstore-genkeys\wrapper\conf\ -Force
						}
						else
						{
							Write-Host "Genkeys is not present in the package" -ForegroundColor Red
						}
				}
Measure-Command{
				
	ForEach-Object{
				try{
					$dest = test-path "C:\xstoreinstall\software\windows_64_oracle_install,upgrade\OracleRetailXstorePointofService*"
					if($dest -eq $True)
					{
						Write-Host "Folder already exists, replacing with new one" -ForegroundColor Yellow
						Write-Host "Please wait..." -ForegroundColor Yellow
						remove-item "C:\xstoreinstall\software\windows_64_oracle_install,upgrade\*" -recurse
						extract
						Write-Host "Complete." -ForegroundColor Green
					}
					else
					{
						Write-Host "No base folder exists, please try with full installation." -ForegroundColor Yellow
					}
 } 
				catch {
							Write-Warning "XStore unziping has failed"
					}

					

} 
}
				
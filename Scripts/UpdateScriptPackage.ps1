param (
    [Parameter(Mandatory=$true)][string]$sharePath,
    [Parameter(Mandatory=$true)][string]$shareUser,
    [Parameter(Mandatory=$true)][string]$sharePassword
 )

 mkdir c:\bootstrap
 Measure-Command{
	ForEach-Object{
				try{
				$source = $sharePath + "\setup.zip"
				$destination = "C:\bootstrap\setup.zip"
 
				Copy-item -path $source -Destination $destination -Force

				$shell = New-Object -ComObject shell.application
				$zip = $shell.NameSpace("C:\bootstrap\setup.zip")
				foreach ($item in $zip.items()) {
				$shell.Namespace("C:\bootstrap\").CopyHere($item)
						}
				Write-Host "Setup folder has been extracted successfully" -ForegroundColor Green
				}
				
	
			catch {
				Write-Warning "setup.zip extraction failed."

					}
}

#remove-item C:\bootstrap\setup.zip -recurse
}
 CD c:\bootstrap 
 $path =  "c:\bootstrap\setup"
 Get-Content  c:\bootstrap\setup\scripts\copy_folder.ps1 | Set-Content c:\bootstrap\copy_folder.ps1
 
 foreach ($item in Get-ChildItem $path){
    if($item.name -ne "Installers"){
    $dst = "c:\setup\"+$item.Name
    .\copy_folder.ps1 -source $item.FullName -destination $dst -username $shareUser -password $sharePassword
    }
 }
 $path = $sharePath+"\TJX*.*z*"
 .\copy_folder.ps1 -source $path -destination C:\setup\Installers\V100335-01_2of2.zip -username $shareUser -password $sharePassword
 $path = $sharePath+"\hosts"
 .\copy_folder.ps1 -source $path -destination C:\setup\config\template\hosts -username $shareUser -password $sharePassword
 $path = $sharePath+"\acntInfo.env"
 .\copy_folder.ps1 -source $path -destination C:\setup\config\acntInfo.env -username $shareUser -password $sharePassword

 cd c:\
 Remove-Item c:\bootstrap -recurse -Force
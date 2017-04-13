function uninstall-7zip()
	{
		$zip = test-path "C:\Program Files\7-Zip\Uninstall.exe"
		if ($zip -eq $True)
			{	$uninstall="C:\Program Files\7-Zip\Uninstall.exe"
				Start-Process -FilePath $uninstall -ArgumentList '/InstallDirectoryPath:"C:\Program Files"','/S'  -Wait -Verb RunAs
				Write-Host "7zip has been Uninstalled." -ForegroundColor Green
			}
		if ($zip -eq $False)
		{	
				
				Write-Host "7zip is not present on this system" -ForegroundColor Red
		}
    
}
uninstall-7zip
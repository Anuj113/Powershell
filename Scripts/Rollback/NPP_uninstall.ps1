function uninstall-NPP()
	{
		$NPP = test-path "C:\Program Files (x86)\Notepad++\Uninstall.exe"
		if ($NPP -eq $True)
			{	$uninstall="C:\Program Files (x86)\Notepad++\Uninstall.exe"
				Start-Process -FilePath $uninstall -ArgumentList '/InstallDirectoryPath:"C:\Program Files"','/S'  -Wait -Verb RunAs
				Write-Host "Notepad++ has been Uninstalled." -ForegroundColor Green
			}
		if ($NPP-eq $False)
		{	
				
				Write-Host "Notepad++ is not present on this system" -ForegroundColor Red
		}
    
}
uninstall-NPP
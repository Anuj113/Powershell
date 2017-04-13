# #############################################################################
# ACCENTURE For TJX Inc. - SCRIPT - POWERSHELL
# 
# AUTHOR_Primary :  anuj.l.kumar@accenture.com
# AUTHOR_Secondary : s.vijaykumar.kothari@accenture.com
# DATE:  2016/05/10
# 
# COMMENT:  This script will install JRE(Customized for XSTORE Installation) in the system.
#
# VERSION HISTORY
# Initial version 1.0
#
# #############################################################################

Measure-Command {
    ForEach-Object{
			        try{

                        $source = "C:\setup\Installers\XST-jre-1.7.0_79-windows_32.zip"
                        $destination = "C:\XST-jre-1.7.0_79-windows_32.zip"
						
						$java = Test-path "C:\jre"
						if($Java -eq $TRUE)
						{
							Write-Host "Java already exists" -ForegroundColor Yellow
						}
						else
						{
							Copy-item -path $source -Destination $destination -Force

							$shell = New-Object -ComObject shell.application
							$zip = $shell.NameSpace("C:\XST-jre-1.7.0_79-windows_32.zip")
							foreach ($item in $zip.items()) {
							$shell.Namespace("C:\").CopyHere($item)
                                                    }
                            Write-Host "Java has been successfully copied to C:\jre" -ForegroundColor Green
                            cd C:\
                            remove-item XST-jre-1.7.0_79-windows_32.zip
						}
                        

                        }
              catch {
						Write-Warning "Java copying has failed"
					}
                   }

}
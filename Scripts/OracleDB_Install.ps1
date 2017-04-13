# #############################################################################
# ACCENTURE For TJX Inc. - SCRIPT - POWERSHELL
# 
# AUTHOR_Primary :  anuj.l.kumar@accenture.com
# AUTHOR_Secondary : s.vijaykumar.kothari@accenture.com
# DATE:  2016/05/10
# 
# COMMENT:  This script will install Oracle 12C DB installer in the system
#
# VERSION HISTORY
# Initial version 1.0
#
# #############################################################################

Measure-Command{
    ForEach-Object{
                    try {
                            $source = "C:\setup\Installers\OracleDB.zip"
                            $destination = "C:\TEMP\OracleDB.zip"
 
                            Copy-Item -Path $source -Destination $destination -Force

                            $shell = New-Object -ComObject shell.application
                            $zip = $shell.NameSpace("C:\TEMP\OracleDB.zip")
                            MkDir("C:\TEMP\OracleDB")
                            foreach ($item in $zip.items()) {
                            $shell.Namespace("C:\TEMP\OracleDB").CopyHere($item, 0x14)
                            }
                            cd C:\TEMP\OracleDB
                            ./setup -silent -ignoresysprereqs -responseFile C:\setup\Scripts\db.rsp

                            cd..
                             remove-item OracleDB.zip
                           }
                    catch {
				                Write-Warning "Oracle Installation has failed !"
					      }

                    }
}
 

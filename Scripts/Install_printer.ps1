# #############################################################################
# ACCENTURE For TJX Inc. - SCRIPT - POWERSHELL
# 
# AUTHOR_Primary :  anuj.l.kumar@accenture.com
# AUTHOR_Secondary : s.vijaykumar.kothari@accenture.com
# DATE:  2016/05/10
# 
# COMMENT:  This script will install printer drivers in the system to support printing for XSTORE.
#
# VERSION HISTORY
# Initial version 1.0
#
# #############################################################################

$programs = Get-ItemProperty HKLM:\Software\Microsoft\Windows\CurrentVersion\Uninstall\* |  Select-Object DisplayName
$text = "EPSON Port Communication Service"
$programs >> findprinter.txt

function printer()
        {
            $install="C:\setup\Installers\hardware\epson\64bit_windows\common\PCS64.msi"
            #Writing a varibale with all argument list
            Invoke-Command -ScriptBlock { & cmd /c "msiexec.exe /i $install" /qn}
        }
		
$find = Select-String -Pattern $text -Path findprinter.txt -Quiet
If ($find)
	{write-host "EPSON printer driver is already present on the system" -ForegroundColor Yellow}

If (-Not $find)
{
	try{
	  #Installing EPSON printer driver
      printer
	  copy-item C:\setup\Scripts\pcs.properties C:\ProgramData\epson\portcommunicationservice\ -force
	  copy-item C:\setup\Installers\EpsUCCvt_32 -recurse "C:\Program Files (x86)\Common Files\epson\"
	  rename-item "C:\Program Files (x86)\Common Files\epson\EpsUCCvt_32" "C:\Program Files (x86)\Common Files\epson\EpsUCCvt"
	  copy-item C:\setup\Installers\EpsUCCvt_64 -recurse "C:\Program Files\Common Files\epson\"
	  rename-item "C:\Program Files\Common Files\epson\EpsUCCvt_64" "C:\Program Files\Common Files\epson\EpsUCCvt"
	  Write-Host "Printer has been installed successfully" -ForegroundColor Green
		}
   #if try block failed
	catch
    {
        Write-Host "Printer installation failed" -ForegroundColor Yellow
    }
}
remove-item findprinter.txt
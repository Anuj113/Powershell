# #############################################################################
# ACCENTURE For TJX Inc. - SCRIPT - POWERSHELL
# 
# AUTHOR_Primary :  anuj.l.kumar@accenture.com
# AUTHOR_Secondary : s.vijaykumar.kothari@accenture.com
# DATE:  2016/05/10
# 
# COMMENT:  This script will install all the prerequisites in the system to support XSTORE installation
#
# VERSION HISTORY
# Initial version 1.0
#
# #############################################################################

echo "Please do not interupt !! Software installtion is in progress..." 


echo "Creating Directories......"
#Creating a temporary location to copy zip files individually and unziping them followed by installing and cleaning the directory.
#mkdir C:\TEMP
#Creating Oracle installtion folder location for JRE.
mkdir E:\app\oracle\product\12.1.0\dbhome_1
#Creating directories for Xstore.
mkdir c:\xstoreinstall\software
#mkdir C:\xstoreinstall\Tools\genkeys

echo "Oracle 12c Database - In Progress..."
#Installing Oracle Database 12c.
.\OracleDB_Install.ps1 >> C:\setup\Script_Log\OracleDB.txt
echo "Oracle 12c Database process continues on another command window..."

echo "7zip - In Progress..."
cd C:\setup\Scripts
#Installing 7zip with powershell script.
.\7zip_install.ps1 >> C:\setup\Script_Log\7zip_log.txt
echo "7zip Done!"

echo "Notepad++ - In Progress..."
cd C:\setup\Scripts
#Installing Notepad++ with powershell script.
.\Notepad_pp_Install.ps1 >> C:\setup\Script_Log\Notepad++.txt
echo "Notepad++ Done!"

echo "JRE - In Progress..."
cd C:\setup\Scripts
#Unziping JRE to C:\Java.
.\Java_Unzip.ps1 >> C:\setup\Script_Log\JRE.txt


echo "Copying Xstore folder..."
cd C:\setup\Scripts
#Copying Xstore folder.
.\ExtractXstore.ps1 >> C:\setup\Script_Log\ExtractXstore.txt
echo "Complete!"

echo "updating the ant.install.properties files in genkeys, xstore, xenvironment"
cd C:\setup\Scripts
.\generate-ant-install.ps1

echo "Waiting for Oracle DB 12c installation to be complete..."
#TIMEOUT /T 1320
cd C:\setup\Scripts
./teatime.ps1 500
echo "Oracle DB 12c installation - Complete !!"
cd C:\setup\Scripts
.\Path_Refresh.ps1

echo "Creating DB listener..."
E:\app\oracle\product\12.1.0\dbhome_1\BIN\netca -silent -responseFile C:\setup\Scripts\lsnr.rsp
echo "Listener created.."

echo "Generating host file..."
cd c:\setup\Scripts
.\generateHost.ps1
echo "Host generated...."

echo "All prerequisites has been installed sucessfully"

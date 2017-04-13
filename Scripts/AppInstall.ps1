# #############################################################################
# ACCENTURE For TJX Inc. - SCRIPT - POWERSHELL
# 
# AUTHOR_Primary :  anuj.l.kumar@accenture.com
# AUTHOR_Secondary : s.vijaykumar.kothari@accenture.com
# DATE:  2016/05/10
# 
# COMMENT:  This script will install XSTORE/Xenvironment & Create XSTORE DB as well.
#
# VERSION HISTORY
# Initial version 1.0
#
# #############################################################################

#Creating XSTORE Database.
CD C:\setup\Scripts\DB\xstore
C:\setup\Scripts\DB\xstore/XSTORE.bat


#Installing Xstore & Xenvironment with truststore & keystore
CD C:\setup\Scripts
./xstore.ps1
CD C:\setup\Scripts
./xenvironment.ps1

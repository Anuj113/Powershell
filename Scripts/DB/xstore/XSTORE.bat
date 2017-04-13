echo on
del "path.sql"
del /Q log
rmdir log
del /Q temp
rmdir temp
for /F "delims=" %%j in ('type "path.properties"') do set %%j
for /F "tokens=*" %%A in (path.properties) do echo define %%A>>path.sql
mkdir temp
copy "%scripts%\tempControl.ctl" temp\
mkdir "%basePath%"
mkdir "%adump%"
mkdir "%dpdump%"
mkdir "%pfile%"
mkdir "%audit%"
mkdir "%dbca%"\XSTORE
mkdir "%fast_recovery_area%"\XSTORE
mkdir "%oradata%"\XSTORE
mkdir "%dbhome_1%"\database
mkdir "%scripts_log%"
set PERL5LIB=%ORACLE_HOME%/rdbms/admin;%PERL5LIB%
set ORACLE_SID=XSTORE
setx /M ORACLE_SID XSTORE
set PATH=%ORACLE_HOME%\bin;%ORACLE_HOME%\perl\bin;%PATH%
"%dbhome_1_bin%"\oradim.exe -new -sid "%ORACLE_SID%" -startmode manual -spfile 
"%dbhome_1_bin%"\oradim.exe -edit -sid "%ORACLE_SID%" -startmode auto -srvcstart system 
"%sqlplus%" /nolog @"%scripts%"\XSTORE.sql


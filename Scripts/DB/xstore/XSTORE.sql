@path.sql
set verify off
--ACCEPT sysPassword CHAR PROMPT 'Enter new password for SYS: ' HIDE
--ACCEPT systemPassword CHAR PROMPT 'Enter new password for SYSTEM: ' HIDE
host &dbhome_1_bin\orapwd.exe file=&dbhome_1\database\PWDXSTORE.ora password=&&sysPassword force=y format=12
@&scripts\CloneRmanRestore.sql
@&scripts\cloneDBCreation.sql
@&scripts\postScripts.sql
@&scripts\lockAccount.sql
@&scripts\postDBCreation.sql


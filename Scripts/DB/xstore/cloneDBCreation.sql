SET VERIFY OFF
connect "SYS"/"&&sysPassword" as SYSDBA
set echo on
spool &scripts_log\cloneDBCreation.log append
shutdown abort;
startup nomount pfile="&scripts\init.ora";
Create controlfile reuse set database "XSTORE"
MAXINSTANCES 8
MAXLOGHISTORY 1
MAXLOGFILES 16
MAXLOGMEMBERS 3
MAXDATAFILES 100
Datafile 
'&&file0',
'&&file1',
'&&file2',
'&&file3'
LOGFILE GROUP 1 ('&oradata\XSTORE\redo01.log') SIZE 50M,
GROUP 2 ('&oradata\XSTORE\redo02.log') SIZE 50M,
GROUP 3 ('&oradata\XSTORE\redo03.log') SIZE 50M RESETLOGS;
exec dbms_backup_restore.zerodbid(0);
shutdown immediate;
startup nomount pfile="&scripts\initXSTORETemp.ora";
Create controlfile reuse set database "XSTORE"
MAXINSTANCES 8
MAXLOGHISTORY 1
MAXLOGFILES 16
MAXLOGMEMBERS 3
MAXDATAFILES 100
Datafile 
'&&file0',
'&&file1',
'&&file2',
'&&file3'
LOGFILE GROUP 1 ('&oradata\XSTORE\redo01.log') SIZE 50M,
GROUP 2 ('&oradata\XSTORE\redo02.log') SIZE 50M,
GROUP 3 ('&oradata\XSTORE\redo03.log') SIZE 50M RESETLOGS;
alter system enable restricted session;
alter database "XSTORE" open resetlogs;
exec dbms_service.delete_service('seeddata');
exec dbms_service.delete_service('seeddataXDB');
DROP PUBLIC DATABASE LINK DBMS_CLRDBLINK;
alter database rename global_name to "XSTORE";
ALTER TABLESPACE TEMP ADD TEMPFILE '&oradata\XSTORE\TEMP01.DBF' SIZE 61440K REUSE AUTOEXTEND ON NEXT 640K MAXSIZE UNLIMITED;
select tablespace_name from dba_tablespaces where tablespace_name='USERS';
alter user sys account unlock identified by "&&sysPassword";
connect "SYS"/"&&sysPassword" as SYSDBA
alter user system account unlock identified by "&&systemPassword";
select sid, program, serial#, username from v$session;
alter database character set INTERNAL_CONVERT WE8MSWIN1252;
alter database national character set INTERNAL_CONVERT AL16UTF16;
alter system disable restricted session;

SET VERIFY OFF
spool &scripts_log\postDBCreation.log append
@&dbhome_1\rdbms\admin\catbundleapply.sql;
connect "SYS"/"&&sysPassword" as SYSDBA
set echo on
create spfile='&dbhome_1\database\spfileXSTORE.ora' FROM pfile='&scripts\init.ora';
connect "SYS"/"&&sysPassword" as SYSDBA
select 'utlrp_begin: ' || to_char(sysdate, 'HH:MI:SS') from dual;
@E:\app\oracle\product\12.1.0\dbhome_1\rdbms\admin\utlrp.sql;
select 'utlrp_end: ' || to_char(sysdate, 'HH:MI:SS') from dual;
select comp_id, status from dba_registry;
execute dbms_swrf_internal.cleanup_database(cleanup_local => FALSE);
commit;
shutdown immediate;
connect "SYS"/"&&sysPassword" as SYSDBA
startup ;
spool off
exit;

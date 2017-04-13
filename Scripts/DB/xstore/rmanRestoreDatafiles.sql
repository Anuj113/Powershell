connect target sys/&1;
 
CATALOG START WITH   'E:\app\oracle\product\12.1.0\dbhome_1\assistants\dbca\templates\\Seed_Database.dfb'  NOPROMPT  ;

RUN {  

set newname for datafile 3 to  'E:\app\oracle\oradata\XSTORE\SYSAUX01.DBF' ; 

set newname for datafile 1 to  'E:\app\oracle\oradata\XSTORE\SYSTEM01.DBF' ; 

set newname for datafile 6 to  'E:\app\oracle\oradata\XSTORE\USERS01.DBF' ; 

set newname for datafile 5 to  'E:\app\oracle\oradata\XSTORE\UNDOTBS01.DBF' ; 

restore datafile 3; 

restore datafile 1; 

restore datafile 6; 

restore datafile 5; }

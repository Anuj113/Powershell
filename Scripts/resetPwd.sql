DECLARE
    pwd VARCHAR2(2000);
    statement VARCHAR2(5000);
BEGIN
    SELECT SPARE4 INTO pwd FROM USER$ WHERE NAME='DBAUSER';
    statement :='ALTER USER dbauser IDENTIFIED BY VALUES ''' || pwd || '''';
    EXECUTE IMMEDIATE(statement);

    SELECT SPARE4 INTO pwd FROM USER$ WHERE NAME='DTV';
    statement :='ALTER USER dtv IDENTIFIED BY VALUES ''' || pwd || '''';
    EXECUTE IMMEDIATE(statement);

    SELECT SPARE4 INTO pwd FROM USER$ WHERE NAME='TRAINING';
    statement :='ALTER USER training IDENTIFIED BY VALUES ''' || pwd || '''';
    EXECUTE IMMEDIATE(statement);

    SELECT SPARE4 INTO pwd FROM USER$ WHERE NAME='REPQUEUE';
    statement :='ALTER USER repqueue IDENTIFIED BY VALUES ''' || pwd || '''';
    EXECUTE IMMEDIATE(statement);

END;

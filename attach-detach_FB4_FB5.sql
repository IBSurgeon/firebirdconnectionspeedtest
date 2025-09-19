--- Script ot test connection and disconnection on Firebird 5.0 and Firebird 4.0
--- (c) IBSurgeon, 2025

set bail on;
set list on;
connect 'localhost/3054:C:\HQbird\Firebird40\examples\empbuild\EMPLOYEE.FDB' user sysdba password 'masterkey';

ALTER EXTERNAL CONNECTIONS POOL CLEAR ALL;
ALTER EXTERNAL CONNECTIONS POOL SET SIZE 0;

set term ^;
execute block returns(db_conn_string varchar(255), iter_cnt int, total_time_for_all_iter_ms int, avg_conn_establish_time_ms int, AUTH_SERVER varchar(255)) as

    declare dsn_case_0 varchar(255) = ''; -- local protocol will be used
    declare dsn_case_1 varchar(255) = 'localhost/3052';
    declare dsn_case_2 varchar(255) = 'inet4://localhost:3054/';
    declare dsn_case_3 varchar(255) = 'inet6://localhost:3055/';
    declare dsn_case_4 varchar(255) = 'inet4://HOME-AUX:3401/';
    declare dsn_case_5 varchar(255) = 'inet6://localhost:3600/';
    declare dsn_case_6 varchar(255) = 'inet6://HOME-AUX:3401/';
    declare dsn_case_7 varchar(255) = 'xnet://';

    declare DB_NAME varchar(255) = 'C:/HQbird/Firebird40/examples/empbuild/EMPLOYEE.FDB';
    declare DBA_USER varchar(64) = 'SYSDBA';
    declare DBA_PASS varchar(64) = 'masterkey';
    declare i int = 0;
    declare k smallint;
    declare t0 timestamp;
    declare t1 timestamp;
begin
    --##########################
    ITER_CNT = 100;
    db_conn_string = dsn_case_2;
    --##########################

    if ( trim(db_conn_string) = '' ) then
        db_conn_string = DB_NAME;
    else if ( right(trim(db_conn_string),1) = '/' ) then
        db_conn_string = db_conn_string || DB_NAME;
    else
        db_conn_string = db_conn_string || ':' || DB_NAME;
    
    t0 = 'now';
    while (i < ITER_CNT) do
    begin
        execute statement ('select 1 from rdb$database')
        on external db_conn_string
        with autonomous transaction
        as user DBA_USER password DBA_PASS
        into k;
        i = i + 1;
    end
    t1 = 'now';
    total_time_for_all_iter_ms = datediff(millisecond from t0 to t1);
    avg_conn_establish_time_ms = total_time_for_all_iter_ms / ITER_CNT;
	:AUTH_SERVER = (select first 1 RDB$CONFIG_VALUE from rdb$config where upper(rdb$config_name)='AUTHSERVER');
    suspend;
end
^
set term ;^
quit;

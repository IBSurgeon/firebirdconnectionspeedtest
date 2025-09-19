# Test to measure Firebird connection speed

In order to use Firebird connection speed, this test performs the specified number of connects/disconnects with very fast query using execute statement on external data source mechanism.

## How to run the test

1. Download SQL script according your database version - there are versions for Firebird 4.0 and 5.0, and for Firebird 2.5 and 3.0, with slight difference in the output, but with the same approach for measuring results.

2. Prepare the script to run in your specific environment:

   a. **Origin database** - in the line 6. It should be database on the server where we have the client part.
   
   ```sql
   connect 'localhost/3054:C:\HQbird\Firebird40\examples\empbuild\EMPLOYEE.FDB' user sysdba password 'masterkey';
   ```
   
   b. Modify the first part of connection string where server address and protocol are set - there are several examples in variables `dsn_case_1` .. `dsn_case_7`
   
   c. Modify part to the target database - it is in variable `DB_NAME`
   
   d. Confirm the number of iterations in variable `ITER_COUNT` (line 32) - you can keep 100
   
   e. Confirm that you are using desired connections string - see variable `db_conn_string` in line 33.

3. Run script from Firebird folder (where `isql.exe` is located), for example, If saved in `C:\temp\`, command line will be:

   ```bash
   isql.exe -i C:\temp\attach-detach_FB4_FB5.sql
   ```

## Example output

Example of output for Firebird 5 and 4:

```
C:\HQbird\Firebird40>isql -i C:\Temp\attach-detach_FB4_FB5.sql
Use CONNECT or CREATE DATABASE to specify a database

DB_CONN_STRING                  inet4://localhost:3054/C:/HQbird/Firebird40/examples/empbuild/EMPLOYEE.FDB
ITER_CNT                        100
TOTAL_TIME_FOR_ALL_ITER_MS      3843
AVG_CONN_ESTABLISH_TIME_MS      38
AUTH_SERVER                     Srp256
```




You can see number of iterations in output variable `ITER_CNT`, total time and average connection/disconnection/query time.

**Important!** Ignore the result of the first run, run test 3 times and use average value of these runs.
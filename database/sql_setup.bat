@echo off
echo =============================================
echo  Soccer League Database Setup
echo =============================================
 
set SERVER=(localdb)\MSSQLLocalDb
set DATABASE=CIS560
 
echo.
echo Step 1: Running schema.sql...
sqlcmd -S %SERVER% -d %DATABASE% -E -i FantasyFootballSetup.sql
IF %ERRORLEVEL% NEQ 0 (
    echo ERROR: FantasyFootballSetup.sql failed. Stopping.
    pause
    exit /b 1
)
echo schema.sql ran successfully.
 
echo.
echo Step 2: Running test_data.sql...
sqlcmd -S %SERVER% -d %DATABASE% -E -i test_data.sql
IF %ERRORLEVEL% NEQ 0 (
    echo ERROR: test_data.sql failed. Stopping.
    pause
    exit /b 1
)
echo test_data.sql ran successfully.
 
echo.
echo =============================================
echo  Database setup complete!
echo =============================================
pause
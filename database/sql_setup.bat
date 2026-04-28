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
echo FantasyFootballSetup.sql ran successfully.
 
echo.
echo Step 2: Running bulk_copy.py...
python bulk_copy.py
IF %ERRORLEVEL% NEQ 0 (
    echo ERROR: bulk_copy.py failed. Stopping.
    pause
    exit /b 1
)
echo bulk_copy.py ran successfully.
 
echo.
echo =============================================
echo  Database setup complete!
echo =============================================
pause
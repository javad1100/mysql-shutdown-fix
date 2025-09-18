@echo off
:: =========================================
:: XAMPP MySQL Data Sync Script
:: Author: DevYarn
:: Website: www.devyarn.com
:: Purpose: Safely sync MySQL backup with data folder
:: =========================================

:: --- Initial Warning / Info ---
echo.
echo ***********************************
echo WARNING: If you see MySQL errors like:
echo MySQL shutdown unexpectedly
echo or port issues, missing dependencies, or crashes,
echo please check the XAMPP MySQL logs before proceeding.
echo ***********************************
echo.
pause

:: --- Ask for XAMPP root folder ---
set /p XAMPP_ROOT=Enter XAMPP root path (e.g. C:\xampp): 
if "%XAMPP_ROOT%"=="" set "XAMPP_ROOT=C:\xampp"
echo Selected XAMPP root path: %XAMPP_ROOT%
echo.

set "DATA_DIR=%XAMPP_ROOT%\mysql\data"
set "BACKUP_DIR=%XAMPP_ROOT%\mysql\backup"
set "PREBACKUP_BASE=%XAMPP_ROOT%\mysql\pre-backups"

:: --- Create pre-backup folder with timestamp ---
for /f "tokens=1-4 delims=/ " %%a in ('date /t') do set dt=%%c-%%a-%%b
for /f "tokens=1-2 delims=: " %%a in ('time /t') do set tm=%%a-%%b
set "PREBACKUP=%PREBACKUP_BASE%\backup-%dt%-%tm%"

:: Make sure pre-backup folder exists
if not exist "%PREBACKUP_BASE%" mkdir "%PREBACKUP_BASE%"
mkdir "%PREBACKUP%"

echo.
echo Backing up current data to pre-backup folder:
echo    %PREBACKUP%
echo.

:: Copy everything except ibdata1 to pre-backup
robocopy "%DATA_DIR%" "%PREBACKUP%" /E /XF ibdata1 /NFL /NDL /NJH /NJS /NC /NS >nul

:: --- Step 1: Get list of folders in backup ---
setlocal enabledelayedexpansion
set deleted_count=0
set "folder_list="
for /D %%D in ("%BACKUP_DIR%\*") do (
    if /I not "%%~nxD"=="ibdata1" (
        set "folder_list=!folder_list! %%~nxD"
    )
)

:: --- Step 2: Delete folders in data that exist in backup ---
for %%F in (!folder_list!) do (
    if exist "%DATA_DIR%\%%F" (
        rmdir /s /q "%DATA_DIR%\%%F"
        echo Deleted folder: %%F
        set /a deleted_count+=1
    )
)

:: --- Step 3: Delete all files in data except ibdata1 ---
for %%F in ("%DATA_DIR%\*") do (
    if /I not "%%~nxF"=="ibdata1" (
        if not exist "%%F\" (
            del /f /q "%%F"
            echo Deleted file: %%~nxF
            set /a deleted_count+=1
        )
    )
)

:: --- Step 4: Copy all backup files/folders to data (skip ibdata1) quietly ---
robocopy "%BACKUP_DIR%" "%DATA_DIR%" /E /XF ibdata1 /NFL /NDL /NJH /NJS /NC /NS >nul

endlocal & set deleted_count=%deleted_count%

:: --- Step 5: Keep only latest 3 pre-backups ---
for /f "skip=3 delims=" %%F in ('dir "%PREBACKUP_BASE%" /b /ad /o-d') do (
    rmdir /s /q "%PREBACKUP_BASE%\%%F"
    echo Deleted old pre-backup: %%F
)

:: --- Professional Summary & Promotion ---
echo.
echo =======================================
echo MySQL Sync Completed Successfully!
echo =======================================
echo Total items deleted : %deleted_count%
echo Source backup folder : %BACKUP_DIR%
echo Target data folder  : %DATA_DIR%
echo Pre-backup stored at : %PREBACKUP%
echo.
echo -------------------------------------------------
echo Script brought to you by DevYarn
echo Visit: www.devyarn.com for more professional scripts
echo -------------------------------------------------
echo.
echo Press any key to visit our website and explore more tools...
pause >nul
start "" "https://www.devyarn.com"

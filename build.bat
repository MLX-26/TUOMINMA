@echo off
chcp 65001 >nul 2>&1
echo ============================================
echo   TuominMa Build Script v8.1
echo   Document Desensitization Tool Packer
echo ============================================
echo.

REM ---- Step 0: Check Python ----
where python >nul 2>&1
if %errorlevel% neq 0 (
    echo [ERROR] Python not found in PATH.
    echo Please install Python 3.9+ from python.org
    pause
    exit /b 1
)
echo [OK] Python found:
python --version
echo.

REM ---- Step 1: Install dependencies ----
echo [Step 1/4] Installing dependencies...
python -m pip install PySide6 pandas openpyxl Pillow pdfplumber PyInstaller --quiet 2>nul
if %errorlevel% neq 0 (
    echo [WARN] Some packages may have failed. Retrying...
    python -m pip install PySide6 pandas openpyxl Pillow pdfplumber PyInstaller
)
echo [OK] Dependencies installed.
echo.

REM ---- Step 2: Generate icon ----
echo [Step 2/4] Generating icon...
if not exist tuominma.ico (
    if exist make_icon.py (
        python make_icon.py
    ) else (
        echo [WARN] No icon file, building without icon...
    )
)
if exist tuominma.ico (
    echo [OK] Icon ready: tuominma.ico
) else (
    echo [WARN] Building without custom icon...
)
echo.

REM ---- Step 3: Syntax check ----
echo [Step 3/4] Checking syntax...
python -m py_compile main.py
if %errorlevel% neq 0 (
    echo [ERROR] Syntax error in main.py! Fix errors and try again.
    pause
    exit /b 1
)
echo [OK] Syntax check passed.
echo.

REM ---- Step 4: Build EXE ----
echo [Step 4/4] Building executable...
echo This may take several minutes, please wait...

set ICON_ARG=
if exist tuominma.ico set ICON_ARG=--icon=tuominma.ico

python -m PyInstaller ^
    --onefile ^
    --windowed ^
    --name TuominMa ^
    %ICON_ARG% ^
    --noconfirm ^
    main.py

if %errorlevel% equ 0 (
    echo.
    echo ============================================
    echo   BUILD SUCCESS!
    echo ============================================
    echo Output: dist\TuominMa.exe
    for %%A in ("dist\TuominMa.exe") do echo Size: %%~zA bytes
    echo.
    echo Opening output folder...
    explorer "dist"
) else (
    echo.
    echo [ERROR] Build failed! Check errors above.
)

echo.
pause

@echo off
chcp 65001 >nul
title CTInfer - Compound Target Inference Tool

cd /d "%~dp0"

echo.
echo  +------------------------------------------+
echo  ^|                                          ^|
echo  ^|   C T I n f e r                         ^|
echo  ^|                                          ^|
echo  ^|   Compound Target Inference Tool        ^|
echo  ^|                                          ^|
echo  +------------------------------------------+
echo.

python --version >nul 2>&1
if errorlevel 1 (
    echo  ERREUR : Python n'est pas installe.
    echo  Va sur https://python.org et coche "Add Python to PATH".
    pause & exit /b 1
)

python -c "import playwright" >nul 2>&1
if errorlevel 1 (
    echo  Installation de Playwright...
    python -m pip install playwright --quiet
    python -m playwright install chromium
)

python -c "import openpyxl" >nul 2>&1
if errorlevel 1 ( python -m pip install openpyxl --quiet )

python -c "import bs4" >nul 2>&1
if errorlevel 1 ( python -m pip install beautifulsoup4 --quiet )

echo  Demarrage de CTInfer...
echo.
python "%~dp0CTInfer_app.py"

if errorlevel 1 ( echo. & echo  Une erreur s'est produite. & pause )

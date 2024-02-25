@echo off

echo ***************************************
echo OCB CS2 Module Compiler v0.0.1
echo ***************************************

set ROSLYN_PATH_ORG=%ROSLYN_PATH%
if exist "%ROSLYN_PATH%\csc.exe" goto HasRoslyn
set ROSLYN_PATH=%ProgramFiles%\Microsoft Visual Studio\2022\Enterprise\MSBuild\Current\Bin\Roslyn
if exist "%ROSLYN_PATH%\csc.exe" goto HasRoslyn
set ROSLYN_PATH=%ProgramFiles(x86)%\Microsoft Visual Studio\2022\Enterprise\MSBuild\Current\Bin\Roslyn
if exist "%ROSLYN_PATH%\csc.exe" goto HasRoslyn
set ROSLYN_PATH=%ProgramFiles%\Microsoft Visual Studio\2022\Community\MSBuild\Current\Bin\Roslyn
if exist "%ROSLYN_PATH%\csc.exe" goto HasRoslyn
set ROSLYN_PATH=%ProgramFiles(x86)%\Microsoft Visual Studio\2022\Community\MSBuild\Current\Bin\Roslyn
if exist "%ROSLYN_PATH%\csc.exe" goto HasRoslyn
set ROSLYN_PATH=%ProgramFiles%\Microsoft Visual Studio\2019\Enterprise\MSBuild\Current\Bin\Roslyn
if exist "%ROSLYN_PATH%\csc.exe" goto HasRoslyn
set ROSLYN_PATH=%ProgramFiles(x86)%\Microsoft Visual Studio\2019\Enterprise\MSBuild\Current\Bin\Roslyn
if exist "%ROSLYN_PATH%\csc.exe" goto HasRoslyn
set ROSLYN_PATH=%ProgramFiles%\Microsoft Visual Studio\2019\Community\MSBuild\Current\Bin\Roslyn
if exist "%ROSLYN_PATH%\csc.exe" goto HasRoslyn
set ROSLYN_PATH=%ProgramFiles(x86)%\Microsoft Visual Studio\2019\Community\MSBuild\Current\Bin\Roslyn
if exist "%ROSLYN_PATH%\csc.exe" goto HasRoslyn
echo %ROSLYN_PATH%
set ROSLYN_PATH=%ROSLYN_PATH_ORG%
set ROSLYN_PATH_ORG=
echo Error: Roslyn compiler (csc.exe) not found
echo Error: Define ROSLYN_PATH env var to point to it
exit /b 2

:HasRoslyn

if exist "%PATH_CS2_MANAGED%" goto HasManaged
echo Error: CS2 Managed dll directory not found
echo Error: Define PATH_CS2_MANAGED to point to it
exit /b 2

:HasManaged

echo Using %PATH_CS2_MANAGED%

set NAME=%1
set SOURCES=%2
set PATCHERS=%3

if not exist "build" mkdir "build"
if not exist "patchers" mkdir "patchers"

call PC-CS2 patchers\%NAME%PreloadPatch.dll %PATCHERS% && ^
echo Successfully compiled patchers\%NAME%Patch.dll && ^
call AP-CS2 "%PATH_CS2_MANAGED%" build\Game.dll patchers\*.dll && ^
echo Successfully patched build\Game.dll && ^
call MC-CS2 %NAME%.dll /reference:build\Game.dll %SOURCES% && ^
echo Finished compilation for %NAME%.dll

:end

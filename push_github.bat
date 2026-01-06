@echo off
setlocal enabledelayedexpansion

REM === Parameter ===
REM %1 = Repo-Verzeichnis (optional)
REM %2 = Branch (optional)

set "REPO_DIR=%~1"
set "BRANCH=%~2"


REM === Aufrufbeispiel ===
REM push_github.bat "C:\Projekte\MeinRepo" main
REM push_github.bat "D:\Work\Repo" develop


REM === In Repo wechseln ===
if not "%REPO_DIR%"=="" (
  pushd "%REPO_DIR%" || (echo Konnte Repo-Verzeichnis nicht oeffnen.& exit /b 1)
)

REM === Pruefen, ob Git vorhanden ===
git --version >nul 2>&1 || (echo Git ist nicht installiert oder nicht im PATH.& goto :cleanup)

REM === Pruefen, ob es ein Git-Repo ist ===
git rev-parse --is-inside-work-tree >nul 2>&1 || (echo Kein Git-Repository gefunden.& goto :cleanup)

REM === Status anzeigen ===
echo.
echo Status:
git status -sb
echo.

REM === Alles stagen ===
git add -A
if errorlevel 1 (echo Fehler bei "git add".& goto :cleanup)

REM === Gibt es Aenderungen? ===
git diff --cached --quiet
if %errorlevel%==0 (
  echo Keine Aenderungen zum Committen.
  goto :push_only
)

REM === Commit-Message automatisch ===
for /f "tokens=1-3 delims=." %%a in ("%date%") do set "D=%%c-%%b-%%a"
for /f "tokens=1-2 delims=:" %%a in ("%time%") do set "T=%%a%%b"
set "COMMIT_MSG=Update !D! !T!"

echo Commit: "%COMMIT_MSG%"
git commit -m "%COMMIT_MSG%"
if errorlevel 1 (echo Fehler bei "git commit".& goto :cleanup)

:push_only
REM === Branch ermitteln, falls nicht uebergeben ===
if "%BRANCH%"=="" (
  for /f %%b in ('git branch --show-current') do set "BRANCH=%%b"
)

if "%BRANCH%"=="" (
  echo Konnte Branch nicht ermitteln.
  goto :cleanup
)

echo.
echo Push zu origin %BRANCH% ...
git push origin "%BRANCH%"
if errorlevel 1 (echo Fehler bei "git push".& goto :cleanup)

echo.
echo Fertig.
echo.

:cleanup
if not "%REPO_DIR%"=="" popd
endlocal
exit /b 0

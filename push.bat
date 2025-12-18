@echo off

goto start

git status
pause
git add *
git commit -m"by batch job"
git push
git status

Aufrufbeispiel:

push_github.bat "C:\Projekte\MeinRepo" main
push_github.bat "D:\Work\Repo" develop


pause

:start

call c:\usr\push_github.bat 
REM call push_github.bat "C:\offline\Selbstaendig21\Scheidung 2025\Aufteilung25" main
echo Ente gut, alles gut :-)
pause
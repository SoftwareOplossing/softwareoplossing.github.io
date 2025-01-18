@echo off
setlocal
set path=C:\Ruby34-x64\bin;%path%
SET /P BUILD=Install all (Y/[N])?
IF /I "%BUILD%" EQU "Y" GOTO :install
goto run

:install
gem install jekyll bundler
jekyll -v

:run
cd /d %~dp0
jekyll serve
REM cmd /c call npm start
goto end

:end
pause

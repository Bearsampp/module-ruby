@echo off
set RUBYBINPATH=%~dp0..\bin
pushd %RUBYBINPATH%
set RUBYBINPATH=%CD%
popd

CALL "%RUBYBINPATH%\gem.cmd" install rubygems-update.gem --local --no-rdoc --no-ri
IF %ERRORLEVEL% NEQ 0 exit /b %ERRORLEVEL%

"%RUBYBINPATH%\gem.cmd" update --system --no-rdoc --no-ri

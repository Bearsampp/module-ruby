@echo off
set RUBYBINPATH=%~dp0..\bin
pushd %RUBYBINPATH%
set RUBYBINPATH=%CD%
popd

"%RUBYBINPATH%\gem.cmd" install rubygems-update.gem --local --no-rdoc --no-ri

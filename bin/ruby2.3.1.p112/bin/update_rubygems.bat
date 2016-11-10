@ECHO OFF
IF NOT "%~f0" == "~f0" GOTO :WinNT
@"~NEARD_WIN_PATH~\tools\ruby\ruby2.3.1.p112\bin\ruby.exe" "~NEARD_LIN_PATH~/tools/ruby/ruby2.3.1.p112/bin/update_rubygems" %1 %2 %3 %4 %5 %6 %7 %8 %9
GOTO :EOF
:WinNT
@"~NEARD_WIN_PATH~\tools\ruby\ruby2.3.1.p112\bin\ruby.exe" "%~dpn0" %*

SET REMOVEALL=1

SET RESPFILENAME=%TEMP%\%COMPUTERNAME%_silentuninstall.resp
IF EXIST %RESPFILENAME% del %RESPFILENAME%

@ECHO NBPURGEALL:%REMOVEALL%>> %RESPFILENAME%
@ECHO REBOOT:ReallySuppress>> %RESPFILENAME%

setup.exe -s -u /REALLYLOCAL /RESPFILE:'%RESPFILENAME%'

IF EXIST %RESPFILENAME% del %RESPFILENAME%
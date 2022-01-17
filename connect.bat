mode 78,20
@echo off
setlocal enabledelayedexpansion
:: Call Routine for ASCI Coding
call :setESC
cls
:: Set Variables
set "INTERNHOST=196.192.10.1"
set "VPNPROFIL=Profil.ovpn"
set "USER=Praxis"
set "PW=sonnen!/schein"

:: NAS Drives
set DRIVE[0]=B:
set DRIVE[1]=Z:
set DRIVE[2]=Y:
set DRIVE[3]=X:

set DRIVEPATH[0]="\\%INTERNHOST%\Server_Backup"
set DRIVEPATH[1]="\\%INTERNHOST%\Server_Praxis"
set DRIVEPATH[2]="\\%INTERNHOST%\Server_B.Farris"
set DRIVEPATH[3]="\\%INTERNHOST%\Server_S.Farris"

:: Start Routine
echo %ESC%[7m      VERBINDUNGSMANAGER v1.0             %ESC%[0m
rem
echo ::: Pruefen ob im internen Netz
ping 127.0.0.1 -n 2 > nul
echo %ESC%[42mOK%ESC%[0m    -     Anfrage an Server senden
ping -n 1 "%INTERNHOST%" | findstr /r /c:"[0-9] *ms" > nul

if !ERRORLEVEL!  == 0 (
    
    ping 127.0.0.1 -n 2 > nul
    :: If Computer in interal network   
    echo %ESC%[42mOK%ESC%[0m    -     Verbindung erfolgreich. Keine VPN Verbindung notwendig.
    
    rem
    echo ::: Verbinden von Laufwerken
    ping 127.0.0.1 -n 2 > nul

    :: CONNECT DRIVES
    for /l %%n in (0,1,1) do (   

       net use !DRIVE[%%n]! /delete /Y > NUL 2>&1 || dir > NUL
       net use !DRIVE[%%n]! !DRIVEPATH[%%n]! /user:%USER% %PW% /PERSISTENT:NO > nul
       echo %ESC%[42mOK%ESC%[0m    -     Laufwerk !DRIVE[%%n]! verbunden 

    )
       
    rem
    echo %ESC%[7mAlles erfolgreich. Dieses Fenster schliesst sich in 5 Sekunden.%ESC%[0m
    ping 127.0.0.1 -n 5 > nul

) else (

    :: If Computer remote
    echo %ESC%[43mNO%ESC%[0m    -     Nicht im Netzwerk. VPN Verbindung ist erforderlich.
    ping 127.0.0.1 -n 1 > nul
    rem
    echo ::: Pruefen der Internetverbindung
    echo %ESC%[42mOK%ESC%[0m    -     Testen der Internetverbindung
    ping -n 1 "1.1.1.1" | findstr /r /c:"[0-9] *ms" > nul
    
    if !ERRORLEVEL! == 0 (
    :: If Internet connection is ok
          ping 127.0.0.1 -n 2 > nul
          echo %ESC%[42mOK%ESC%[0m    -     Verbindung ist in Ordnung
          ping 127.0.0.1 -n 2 > nul
          
          rem VPN Verbindung herstellen
          rem rasdial %VPNPROFIL% > nul 
          
          "%ProgramFiles%\OpenVPN\bin\openvpn-gui.exe" --show_script_window 0 --connectscript_timeout 5 --connect "%VPNPROFIL%"
          ping 127.0.0.1 -n 6 > nul

          ping -n 1 "%INTERNHOST%" | findstr /r /c:"[0-9] *ms" > nul

          if !ERRORLEVEL! == 0 (

             echo %ESC%[42mOK%ESC%[0m    -     VPN Verbindung hergestellt
             
             rem
             echo ::: Verbinden von Laufwerken  
             ping 127.0.0.1 -n 2 > nul

             :: CONNECT DRIVES
            for /l %%n in (0,1,1) do (   

               net use !DRIVE[%%n]! /delete /Y > NUL 2>&1 || dir > NUL
               net use !DRIVE[%%n]! !DRIVEPATH[%%n]! /user:%USER% %PW% /PERSISTENT:NO > nul
               echo %ESC%[42mOK%ESC%[0m    -     Laufwerk !DRIVE[%%n]! verbunden 

            )

             rem
             echo %ESC%[7mAlles erfolgreich. Dieses Fenster schliesst sich in 5 Sekunden.%ESC%[0m
             ping 127.0.0.1 -n 5 > nul
    
          ) else (

             echo %ESC%[41mER%ESC%[0m    -     Problem mit VPN Verbindung. Bitte erneut probieren.
             rem
             @pause
          )
      
    ) else (
    :: If Internet Connection failed 
      echo %ESC%[41mER%ESC%[0m    -     Verbindung fehlgeschlagen. Internetverbindung fehlerhaft.
      rem
      @pause
    )
    
)

:setESC
for /F "tokens=1,2 delims=#" %%a in ('"prompt #$H#$E# & echo on & for %%b in (1) do rem"') do (
  set ESC=%%b
  exit /B 0
)

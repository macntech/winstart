mode 78,20
@echo off
setlocal enabledelayedexpansion
:: Call Routine for ASCI Coding
call :setESC
cls
:: Set Variables
set NTERNHOST=196.192.10.1
set VPNPROFIL=Profil.ovpn
set USER=YOURUSERHERE
set PW=YOURPASSWORD

:: NAS Drives
set DRIVE[0]=B:
set DRIVE[1]=Z:
set DRIVE[2]=Y:
set DRIVE[3]=X:

set DRIVEPATH[0]="\\%INTERNHOST%\FolderA"
set DRIVEPATH[1]="\\%INTERNHOST%\FolderB"
set DRIVEPATH[2]="\\%INTERNHOST%\FolderC"
set DRIVEPATH[3]="\\%INTERNHOST%\FolderD"

:: Start Routine
echo %ESC%[7m      CONNECTMANAGER v1.0             %ESC%[0m
rem
echo ::: Check if internal network
ping 127.0.0.1 -n 2 > nul
echo %ESC%[42mOK%ESC%[0m    -     Send request to server
ping -n 1 "%INTERNHOST%" | findstr /r /c:"[0-9] *ms" > nul

if !ERRORLEVEL!  == 0 (
    
    ping 127.0.0.1 -n 2 > nul
    :: If Computer in interal network   
    echo %ESC%[42mOK%ESC%[0m    -     Connection confirmed. No VPN necessary.
    
    rem
    echo ::: Mount Drives
    ping 127.0.0.1 -n 2 > nul

    :: CONNECT DRIVES
    for /l %%n in (0,1,1) do (   

       net use !DRIVE[%%n]! /delete /Y > NUL 2>&1 || dir > NUL
       net use !DRIVE[%%n]! !DRIVEPATH[%%n]! /user:%USER% %PW% /PERSISTENT:NO > nul
       echo %ESC%[42mOK%ESC%[0m    -     Drive !DRIVE[%%n]! connected 

    )
       
    rem
    echo %ESC%[7m Everything ok. Window will be closed in 5 seconds %ESC%[0m
    ping 127.0.0.1 -n 5 > nul

) else (

    :: If Computer remote
    echo %ESC%[43mNO%ESC%[0m    -     Not in network. VPN connection necessary
    ping 127.0.0.1 -n 1 > nul
    rem
    echo ::: Test of internet connection
    echo %ESC%[42mOK%ESC%[0m    -     Test of internet connection initiated
    ping -n 1 "1.1.1.1" | findstr /r /c:"[0-9] *ms" > nul
    
    if !ERRORLEVEL! == 0 (
    :: If Internet connection is ok
          ping 127.0.0.1 -n 2 > nul
          echo %ESC%[42mOK%ESC%[0m    -     Connection test sucessfull
          ping 127.0.0.1 -n 2 > nul
          
          rem VPN Verbindung herstellen
          rem rasdial %VPNPROFIL% > nul 
          
          "%ProgramFiles%\OpenVPN\bin\openvpn-gui.exe" --show_script_window 0 --connectscript_timeout 5 --connect "%VPNPROFIL%"
          ping 127.0.0.1 -n 6 > nul

          ping -n 1 "%INTERNHOST%" | findstr /r /c:"[0-9] *ms" > nul

          if !ERRORLEVEL! == 0 (

             echo %ESC%[42mOK%ESC%[0m    -     VPN connection established
             
             rem
             echo ::: Mount Drives
             ping 127.0.0.1 -n 2 > nul

             :: CONNECT DRIVES
            for /l %%n in (0,1,1) do (   

               net use !DRIVE[%%n]! /delete /Y > NUL 2>&1 || dir > NUL
               net use !DRIVE[%%n]! !DRIVEPATH[%%n]! /user:%USER% %PW% /PERSISTENT:NO > nul
               echo %ESC%[42mOK%ESC%[0m    -     Drive !DRIVE[%%n]! connected 

            )

             rem
             echo %ESC%[7m Everything ok. Window will be closed in 5 seconds %ESC%[0m
             ping 127.0.0.1 -n 5 > nul
    
          ) else (

             echo %ESC%[41mER%ESC%[0m    -     Error with VPN connection. Please try again.
             rem
             @pause
          )
      
    ) else (
    :: If Internet Connection failed 
      echo %ESC%[41mER%ESC%[0m    -     Error in connection test. Please check internet availability.
      rem
      @pause
    )
    
)

:setESC
for /F "tokens=1,2 delims=#" %%a in ('"prompt #$H#$E# & echo on & for %%b in (1) do rem"') do (
  set ESC=%%b
  exit /B 0
)

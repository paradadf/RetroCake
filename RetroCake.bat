@echo off
::Admin Check
:check_Permissions
    net session >nul 2>&1
    if %errorLevel% == 0 (
        goto setvars
    ) else (
        goto AdminFail
    )
:setvars
::Sets time variables for the backup files
set dayte=%date:~4,10%
set thyme=%time:~0,8%
set gooddayte=%dayte:/=%
set goodthyme=%thyme::=%
goto CheckRetroCake

:CheckRetroCake
IF EXIST C:\RetroCake\Temp\ goto permcheck
goto SetRCDir

:SetRCDir

mkdir C:\RetroCake
mkdir C:\RetroCake\EmulationStation
mkdir C:\RetroCake\RetroArch
mkdir C:\RetroCake\Temp
mkdir C:\RetroCake\Tools
icacls "C:\RetroCake" /grant everyone:(OI)(CI)F /T
echo pls no delete > C:\RetroCake\RetroCake
goto check7z

:permcheck
IF EXIST C:\RetroCake\RetroCake goto check7z
goto permss

:permss
icacls "C:\RetroCake" /grant everyone:(OI)(CI)F /T
echo pls no delete > C:\RetroCake\RetroCake
goto check7z

:check7z
IF EXIST C:\RetroCake\Tools\7za\7za.exe goto SGitCheck
goto install7z

:install7z
cls
echo(
echo(
echo(
echo(
echo(
echo(
echo(
echo =================================================================
echo =                                                               =
echo =                      SETTING UP 7ZA...                        =
echo =                                                               =
echo =================================================================
mkdir C:\RetroCake\Tools\7za
powershell -command (New-Object Net.WebClient).DownloadFile('http://www.7-zip.org/a/7za920.zip','C:\RetroCake\Tools\7za\7za.zip');(new-object -com shell.application).namespace('C:\RetroCake\Tools\7za').CopyHere((new-object -com shell.application).namespace('C:\RetroCake\Tools\7za\7za.zip').Items(),16)
cls
echo ================================================
echo =         Cleaning up downloaded files         =
echo ================================================
ping 127.0.0.1 -n 2 >nul
del C:\RetroCake\Tools\7za\7za.zip
goto SGitCheck

:SGitCheck
ThemeManagerSetup
IF EXIST C:\RetroCake\Tools\git\bin\git.exe goto menu
goto sGitArchCheck

:sGitArchCheck
if "%PROCESSOR_ARCHITECTURE%"=="AMD64" (
		goto sgit64
	)
if "%PROCESSOR_ARCHITECTURE%"=="x86" (
		goto sgit32
	)

:sgit32
cls
echo(
echo(
echo(
echo(
echo(
echo(
echo(
echo =================================================================
echo =                                                               =
echo =                      SETTING UP GIT...                        =
echo =                                                               =
echo =================================================================
powershell -command "Invoke-WebRequest -Uri https://github.com/git-for-windows/git/releases/download/v2.15.0.windows.1/PortableGit-2.15.0-32-bit.7z.exe -OutFile "C:\RetroCake\Temp\git.zip"
mkdir C:\RetroCake\Tools\git
C:\RetroCake\Tools\7za\7za.exe x "C:\RetroCake\Temp\git.zip" -o"C:\RetroCake\Tools\git" -aoa
cls
echo ================================================
echo =         Cleaning up downloaded files         =
echo ================================================
ping 127.0.0.1 -n 3 > nul
del "C:\RetroCake\Temp\git.zip"
goto menu

:sgit64
cls
echo(
echo(
echo(
echo(
echo(
echo(
echo(
echo =================================================================
echo =                                                               =
echo =                      SETTING UP GIT...                        =
echo =                                                               =
echo =================================================================
powershell -command "Invoke-WebRequest -Uri https://github.com/git-for-windows/git/releases/download/v2.15.0.windows.1/PortableGit-2.15.0-64-bit.7z.exe -OutFile "C:\RetroCake\Temp\git.zip"
mkdir C:\RetroCake\Tools\git
C:\RetroCake\Tools\7za\7za.exe x "C:\RetroCake\Temp\git.zip" -o"C:\RetroCake\Tools\git" -aoa
cls
echo ================================================
echo =         Cleaning up downloaded files         =
echo ================================================
ping 127.0.0.1 -n 3 > nul
del "C:\RetroCake\Temp\git.zip"
goto menu

::=================================================================================================================================================================================================================================================================================================================
::=================================================================================================================================================================================================================================================================================================================
::=================================================================================================================================================================================================================================================================================================================
::=================================================================================================================================================================================================================================================================================================================
::=================================================================================================================================================================================================================================================================================================================

:menu
cls
echo(
echo RetroCake v1.2.1
echo ===========================================================================
echo =                                                                         =
Echo =    1.) AUTOMATED INSTALLERS                                             =
echo =                                                                         =
echo ===========================================================================
echo =                                                                         =
echo =    2.) MANAGE EMULATIONSTATION                                          =
echo =                                                                         =
echo =    3.) MANAGE RETROARCH                                                 =
echo =                                                                         =
echo =    4.) MANAGE ADDITIONAL EMULATORS                                      =
echo =                                                                         =
echo =    5.) MANAGE ROM DIRECTORIES                                           =
echo =                                                                         =
echo =    6.) MANAGE DEDICATED EMUBOX SETTINGS                                 =
echo =                                                                         =
echo =    7.) SYSTEM CLEANUP                                                   =
echo =                                                                         =
echo ===========================================================================
echo =                                                                         =
echo =    8.) EXIT                                                             =
echo =                                                                         =
echo ===========================================================================
echo =                                                                         =
echo =    9.) UPDATE RETROCAKE SCRIPT                                          =
echo =                                                                         =
echo ===========================================================================
CHOICE /N /C:123456789 /M "Enter Corresponding Menu choice (1, 2, 3, 4, 5, 6, 7, 8, 9)"%1
IF ERRORLEVEL ==9 GOTO RetroCakeUpdate
IF ERRORLEVEL ==8 exit
IF ERRORLEVEL ==7 GOTO SysClean
IF ERRORLEVEL ==6 GOTO DediMenu
IF ERRORLEVEL ==5 GOTO RomMenu
IF ERRORLEVEL ==4 GOTO EmuFolderCheck
IF ERRORLEVEL ==3 GOTO RAMenu
IF ERRORLEVEL ==2 GOTO ESMenu
IF ERRORLEVEL ==1 GOTO automated

::=================================================================================================================================================================================================================================================================================================================

:automated
cls
echo =================================================================================
echo =                                                                               =
Echo =    1.) FULL SETUP WITHOUT ROM DIRECTORIES (NEED TO EDIT ES_SYSTEMS.CFG)       =
echo =                                                                               =
echo =    2.) FULL SETUP WITH DEFAULT ROM DIRECTORIES (C:\RetroCake\ROMS\SYSTEMNAME) =
echo =                                                                               =
echo =    3.) FULL SETUP WITH CUSTOM ROM DIRECTORIES                                 =
echo =                                                                               =
echo =                                                                               =
echo =    4.) RETURN TO MAIN MENU                                                    =
echo =                                                                               =
echo =================================================================================
CHOICE /N /C:1234 /M "Enter Corresponding Menu choice (1, 2, 3, 4)"%1
IF ERRORLEVEL ==4 GOTO menu
IF ERRORLEVEL ==3 GOTO BrandNewCus
IF ERRORLEVEL ==2 GOTO BrandNewDef
IF ERRORLEVEL ==1 GOTO BrandNewBlank

::=================================================================================================================================================================================================================================================================================================================

:ESMenu
cls
echo ===========================================================================
echo =                                                                         =
echo =    1.) CHECK EMULATIONSTATION FOR UPDATES                               =
echo =                                                                         =
echo =    2.) MANAGE ES_SYSTEMS.CFG                                            =
echo =                                                                         =
echo =    3.) MANAGE EMULATIONSTATION THEMES                                   =
echo =                                                                         =
echo =                                                                         =
echo =    4.) RETURN TO MAIN MENU                                              =
echo =                                                                         =
echo ===========================================================================
CHOICE /N /C:12345 /M "Enter Corresponding Menu choice (1, 2, 3, 4, 5)"%1
IF ERRORLEVEL ==4 GOTO menu
IF ERRORLEVEL ==3 GOTO ThemeManager
IF ERRORLEVEL ==2 GOTO ManESCFG
IF ERRORLEVEL ==1 GOTO StartESVerCheck

::=================================================================================================================================================================================================================================================================================================================

:RAMenu
cls
echo ===========================================================================
echo =                                                                         =
Echo =    1.) INSTALL RETROARCH 1.6.7                                          =
echo =                                                                         =
echo =    2.) UPDATE/INSTALL RETROARCH TO THE LATEST NIGHTLY BUILD             =
echo =                                                                         =
echo =    3.) GENERATE CLEAN RETROARCH.CFG                                     =
echo =                                                                         =
echo =    4.) UPDATE RETROARCH CORES TO THE LATEST NIGHTLY BUILD               =
echo =                                                                         =
echo =                                                                         =
echo =    5.) RETURN TO MAIN MENU                                              =
echo =                                                                         =
echo ===========================================================================
CHOICE /N /C:12345 /M "Enter Corresponding Menu choice (1, 2, 3, 4, 5)"%1
IF ERRORLEVEL ==5 GOTO menu
IF ERRORLEVEL ==4 GOTO updatecores
IF ERRORLEVEL ==3 GOTO racfg
IF ERRORLEVEL ==2 GOTO UpdateRAn
IF ERRORLEVEL ==1 GOTO UpdateRA

::=================================================================================================================================================================================================================================================================================================================

:RomMenu
cls
echo ===========================================================================
echo =                                                                         =
Echo =    1.) CREATE DEFAULT ROM DIRECTORIES (C:\RetroCake\ROMS\SYSTEMNAME)    =
echo =                                                                         =
Echo =    2.) CREATE CUSTOM ROM DIRECTORIES                                    =
echo =                                                                         =
echo =    3.) SHARE ROM DIRECTORIES                                            =
echo =                                                                         =
echo =                                                                         =
echo =    4.) RETURN TO MAIN MENU                                              =
echo =                                                                         =
echo ===========================================================================
CHOICE /N /C:1234 /M "Enter Corresponding Menu choice (1, 2, 3, 4)"%1
IF ERRORLEVEL ==4 GOTO menu
IF ERRORLEVEL ==3 GOTO DediShare
IF ERRORLEVEL ==2 GOTO CusRomDirSet
IF ERRORLEVEL ==1 GOTO DefaultRomFolders

::=================================================================================================================================================================================================================================================================================================================

:EmuFolderCheck
cls 
IF EXIST C:\RetroCake\Emulators\ goto AdditionalEmu
mkdir C:\RetroCake\Emulators
goto AdditionalEmu

:AdditionalEmu
cls
echo ===========================================================================
echo =                                                                         =
Echo =    1.) INSTALL ALL ADDITIONAL EMULATORS                                 =
echo =                                                                         =
echo =    2.) INSTALL ATARI ST EMULATOR (Hatari)                               =
echo =                                                                         =
echo =    3.) INSTALL BBC MICRO EMULATOR (BeebEm)                              =
echo =                                                                         =
echo =    4.) INSTALL COCO\DRAGON32 EMULATOR (XRoar)                           =
echo =                                                                         =
echo =    5.) INSTALL LASERDISK GAME EMULATOR (Daphne)                         =
echo =                                                                         =
echo =    6.) INSTALL INTELLIVISION EMULATOR (jzIntv)                          =
echo =                                                                         =
echo =    7.) INSTALL PS2 EMULATOR (PCSX2 1.4.0)                               =
echo =                                                                         =
echo =    8.) INSTALL GAMECUBE EMULATOR (Dolphin 5.0)                          =
echo =                                                                         =
echo =                                                                         =
echo =    9.) Page 2                                                           =
echo =                                                                         =
echo ===========================================================================
CHOICE /N /C:123456789 /M "Enter Corresponding Menu choice (1, 2, 3, 4, 5, 6, 7, 8, 9)"%1
IF ERRORLEVEL ==9 GOTO EmuPage2
IF ERRORLEVEL ==8 GOTO DolphinEmu
IF ERRORLEVEL ==7 GOTO PCSX2
IF ERRORLEVEL ==6 GOTO jzIntv
IF ERRORLEVEL ==5 GOTO Daphne
IF ERRORLEVEL ==4 GOTO XRoar
IF ERRORLEVEL ==3 GOTO BeebEm
IF ERRORLEVEL ==2 GOTO Hatari
IF ERRORLEVEL ==1 GOTO InstallAllEmu

:EmuPage2
cls
echo ===========================================================================
echo =                                                                         =
Echo =    1.) INSTALL APPLE II EMULATOR (AppleWin)                             =
echo =                                                                         =
Echo =    2.) INSTALL COMMODORE 64 EMULATOR (WinVICE)                          =
echo =                                                                         =
echo =                                                                         =
echo =    3.) RETURN TO MAIN MENU                                              =
echo =                                                                         =
echo ===========================================================================
CHOICE /N /C:123 /M "Enter Corresponding Menu choice (1, 2, 3)"%1
IF ERRORLEVEL ==3 GOTO menu
IF ERRORLEVEL ==2 GOTO VICE
IF ERRORLEVEL ==1 GOTO AppleWin

:InstallAllEmu
IF EXIST C:\RetroCake\Emulators\ goto StartAllEmu
mkdir C:\RetroCake\Emulators
goto StartAllEmu

:StartAllEmu
Echo This file is temporary. You should never see it > C:\RetroCake\Emulators\tmp.txt
goto AppleWin

::=================================================================================================================================================================================================================================================================================================================
::=================================================================================================================================================================================================================================================================================================================
::=================================================================================================================================================================================================================================================================================================================
::=================================================================================================================================================================================================================================================================================================================
::=================================================================================================================================================================================================================================================================================================================

:BrandNewBlank
cls
echo Temp file used for installation. IF you see this file something bad happened > C:\RetroCake\Temp\BrandNewBlank
goto updateES

:BrandNewDef
cls
echo Temp file used for installation. IF you see this file something bad happened > C:\RetroCake\Temp\BrandNewDef
goto updateES

:BrandNewCus
cls
echo Temp file used for installation. IF you see this file something bad happened > C:\RetroCake\Temp\BrandNewCus
goto updateES

:BrandNewClean
cls
del C:\RetroCake\Temp\BrandNewBlank /S /Q
del C:\RetroCake\Temp\BrandNewDef /S /Q
del C:\RetroCake\Temp\BrandNewCus /S /Q
goto completed

::=================================================================================================================================================================================================================================================================================================================
::=================================================================================================================================================================================================================================================================================================================
::=================================================================================================================================================================================================================================================================================================================
::=================================================================================================================================================================================================================================================================================================================
::=================================================================================================================================================================================================================================================================================================================

:RetroCakeUpdate
cls
ping 127.0.0.1 -n 2 >nul
echo @echo off > C:\RetroCake\Tools\Updater.bat
echo rmdir C:\RetroCake\Tools\Script /S /Q >> C:\RetroCake\Tools\Updater.bat
echo rmdir C:\RetroCake\Tools\RetroCake /S /Q >> C:\RetroCake\Tools\Updater.bat
echo cd C:\RetroCake\Tools >> C:\RetroCake\Tools\Updater.bat
echo C:\RetroCake\Tools\git\bin\git.exe clone --depth=1 https://github.com/Flerp/RetroCake.git >> C:\RetroCake\Tools\Updater.bat
echo rmdir C:\RetroCake\Tools\RetroCake\.git /S /Q >> C:\RetroCake\Tools\Updater.bat
echo del C:\RetroCake\Tools\RetroCake\.gitattributes /S /Q >> C:\RetroCake\Tools\Updater.bat
echo Ren RetroCake Script >> C:\RetroCake\Tools\Updater.bat
echo start C:\RetroCake\Tools\Script\RetroCake.bat >> C:\RetroCake\Tools\Updater.bat
echo exit >> C:\RetroCake\Tools\Updater.bat
start C:\RetroCake\Tools\Updater.bat
exit

::=================================================================================================================================================================================================================================================================================================================
::=================================================================================================================================================================================================================================================================================================================
::=================================================================================================================================================================================================================================================================================================================
::=================================================================================================================================================================================================================================================================================================================
::=================================================================================================================================================================================================================================================================================================================

::Dedicated EmuBox Options
:DediMenu
cls
echo ===========================================================================
echo =                                                                         =
Echo =    1.) SETUP ALL DEDICATED EMUBOX SETTINGS                              =
echo =    (Auto Start, Auto Login, Folder Shares, System Name to RetroCake)    =
echo =                                                                         =
Echo =    2.) RETROCAKE AUTO START OPTIONS                                     =
echo =                                                                         =
echo =    3.) SETUP AUTOLOGIN                                                  =
echo =                                                                         =
echo =    4.) SETUP RETROCAKE FOLDER SHARES                                    =
echo =                                                                         =
echo =    5.) SETUP SYSTEM NAME                                                =
echo =                                                                         =
echo =                                                                         =
echo =    6.) RETURN TO MAIN MENU                                              =
echo =                                                                         =
echo ===========================================================================
CHOICE /N /C:123456 /M "Enter Corresponding Menu choice (1, 2, 3, 4, 5, 6)"%1
IF ERRORLEVEL ==6 GOTO menu
IF ERRORLEVEL ==5 GOTO DediHostnameMenu
IF ERRORLEVEL ==4 GOTO DediShareMenu
IF ERRORLEVEL ==3 GOTO AutoLogin
IF ERRORLEVEL ==2 GOTO AutoStartMenu
IF ERRORLEVEL ==1 GOTO FullDedi

:DediAsk
cls
echo(
set /P c=Is this system a dedicated Emulator Box [Y/N]?
if /I "%c%" EQU "Y" goto FullDedi
if /I "%c%" EQU "N" goto BrandNewClean

:FullDedi
cls
echo This file is temporary, you should never see it > C:\RetroCake\Temp\FullDedi.txt
IF EXIST C:\RetroCake\Temp\FullDedi.txt goto DediAutoStartSetup
goto erroorr
::=================================================================================================================================================================================================================================================================================================================

:AutoStartMenu
cls
echo ===========================================================================
echo =                                                                         =
Echo =    1.) SETUP AUTOMATIC RETROCAKE LAUNCH ON LOGIN                        =
echo =                                                                         =
Echo =    2.) REMOVE AUTOMATIC RETROCAKE LAUNCH ON LOGIN                       =
echo =                                                                         =
echo =                                                                         =
echo =    3.) RETURN TO DEDICATED EMUBOX MENU                                  =
echo =                                                                         =
echo ===========================================================================
CHOICE /N /C:123 /M "Enter Corresponding Menu choice (1, 2, 3)"%1
IF ERRORLEVEL ==3 GOTO DediMenu
IF ERRORLEVEL ==2 GOTO DediAutoStartRemove
IF ERRORLEVEL ==1 GOTO DediAutoStartSetup

:DediAutoStartSetup
cls
echo(
echo(
echo(
echo(
echo(
echo(
echo(
echo ====================================================
echo =                                                  =
echo =      ADDING RETROCAKE TO AUTOSTART ON LOGIN      =
echo =                                                  =
echo ====================================================
cd "%USERPROFILE%\AppData\Roaming\Microsoft\Windows\Start Menu\Programs\Startup"
echo taskkill /im explorer.exe /f > "C:\RetroCake\Tools\startES.bat"
echo "C:\RetroCake\EmulationStation\emulationstation.exe" >> "C:\RetroCake\Tools\startES.bat"

del "%USERPROFILE%\AppData\Roaming\Microsoft\Windows\Start Menu\Programs\Startup\startES.lnk"
echo Set oWS = WScript.CreateObject("WScript.Shell") > "%USERPROFILE%\CreateShortcut2.vbs"
echo sLinkFile = "%USERPROFILE%\AppData\Roaming\Microsoft\Windows\Start Menu\Programs\Startup\startES.lnk" >> "%USERPROFILE%\CreateShortcut2.vbs"
echo Set oLink = oWS.CreateShortcut(sLinkFile) >> "%USERPROFILE%\CreateShortcut2.vbs"
echo oLink.TargetPath = "C:\RetroCake\Tools\startES.bat" >> "%USERPROFILE%\CreateShortcut2.vbs"
echo oLink.Save >> "%USERPROFILE%\CreateShortcut2.vbs"
cscript "%USERPROFILE%\CreateShortcut2.vbs"
del "%USERPROFILE%\CreateShortcut2.vbs"
IF EXIST C:\RetroCake\Temp\FullDedi.txt goto AutoLogin
goto completed

:DediAutoStartRemove
cls
echo(
echo(
echo(
echo(
echo(
echo(
echo(
echo ====================================================
echo =                                                  =
echo =      REMOVING RETROCAKE AUTOSTART ON LOGIN       =
echo =                                                  =
echo ====================================================
del "%USERPROFILE%\AppData\Roaming\Microsoft\Windows\Start Menu\Programs\Startup\startES.lnk" /s /q
del C:\RetroCake\Tools\startES.bat /a /q
goto completed

::=================================================================================================================================================================================================================================================================================================================

:AutoLogin
cls
echo(
echo(
echo(
echo(
echo(
echo(
echo(
echo ==================================================================
echo =                                                                =
echo =                 PLEASE UNCHECK THE BOX LABELLED                =
echo = Users must enter a user name and password to use this computer =
echo =                      THEN PRESS OK OR APPLY                    =
echo =                                                                =
echo =                  PRESS ANY KEY WHEN FINISHED                   =
echo =                                                                =
echo ==================================================================
start netplwiz
pause > nul
IF EXIST C:\RetroCake\Temp\FullDedi.txt goto DediShare
goto completed

::=================================================================================================================================================================================================================================================================================================================

:DediShareMenu
cls
echo ===========================================================================
echo =                                                                         =
Echo =    1.) SETUP RETROCAKE SHARES WITH DEFAULT ROM DIRECTORY                =
echo =                                                                         =
Echo =    2.) SETUP RETROCAKE SHARES WITH CUSTOM ROM DIRECTORY                 =
echo =                                                                         =
Echo =    3.) REMOVE RETROCAKE SHARES                                          =
echo =                                                                         =
echo =                                                                         =
echo =    4.) RETURN TO DEDICATED EMUBOX MENU                                  =
echo =                                                                         =
echo ===========================================================================
CHOICE /N /C:1234 /M "Enter Corresponding Menu choice (1, 2, 3, 4)"%1
IF ERRORLEVEL ==4 GOTO DediMenu
IF ERRORLEVEL ==3 GOTO DediRemoveShares
IF ERRORLEVEL ==2 GOTO DediShare
IF ERRORLEVEL ==1 GOTO DediShare

:DediShare
cls
net share BIOS=C:\RetroCake\RetroArch\system /grant:everyone,full
net share Emulationstation="%USERPROFILE%\.emulationstation" /grant:everyone,full
net share Emulators=C:\RetroCake\RetroArch\Emulators /grant:everyone,full
IF EXIST C:\RetroCake\ROMS\ goto RomShareDef
goto RomShareCus

:RomShareDef
net share ROMS=C:\RetroCake\ROMS /grant:everyone,full
IF EXIST C:\RetroCake\Temp\FullDedi.txt goto DediHostnameDef
goto completed

:RomShareCus
echo(
set /p cusromdir="Enter Path for ROM Folder (default C:\RetroCake\ROMS): "
net share ROMS=%cusromdir% /grant:everyone,full
IF EXIST C:\RetroCake\Temp\FullDedi.txt goto DediHostnameDef
goto completed

:DediRemoveShares
cls
net share BIOS /delete
net share EmulationStation /delete
net share ROMS /delete
goto completed

::=================================================================================================================================================================================================================================================================================================================

:DediHostnameMenu
cls
echo ===========================================================================
echo =                                                                         =
Echo =    1.) CHANGE PC NAME TO RetroCake                                      =
echo =                                                                         =
Echo =    2.) CREATE CUSTOM PC NAME                                            =
echo =                                                                         =
echo =                                                                         =
echo =    3.) RETURN TO DEDICATED EMUBOX MENU                                  =
echo =                                                                         =
echo ===========================================================================
CHOICE /N /C:123 /M "Enter Corresponding Menu choice (1, 2, 3)"%1
IF ERRORLEVEL ==3 GOTO DediMenu
IF ERRORLEVEL ==2 GOTO DediAutoStartRemove
IF ERRORLEVEL ==1 GOTO DediAutoStartSetup

:DediHostnameDef
cls
WMIC computersystem where caption='%COMPUTERNAME%' rename RetroCake
IF EXIST C:\RetroCake\Temp\FullDedi.txt goto FullDediClean
goto completed

:DediHostnameCus
cls
set /p cushostname="Enter custom PC name: "
WMIC computersystem where caption='%COMPUTERNAME%' rename %cushostname%
goto completed

:FullDediClean
cls
del C:\RetroCake\Temp\FullDedi.txt /s /q
goto completed

::=================================================================================================================================================================================================================================================================================================================
::=================================================================================================================================================================================================================================================================================================================
::=================================================================================================================================================================================================================================================================================================================
::=================================================================================================================================================================================================================================================================================================================
::=================================================================================================================================================================================================================================================================================================================

:StartESVerCheck
cls
echo(
echo(
echo(
echo(
echo(
echo(
echo(
echo ====================================================
echo =                                                  =
echo =               CHECKING FOR UPDATES               =
echo =                                                  =
echo ====================================================
IF EXIST C:\RetroCake\Temp\ESCheck\ goto CleanESCheck
goto ESCheck

:CleanESCheck
rmdir C:\RetroCake\Temp\ESCheck /S /Q
goto ESCheck

:ESCheck
IF NOT EXIST C:\RetroCake\EmulationStation\emulationstation.exe goto UpdateESQN
mkdir C:\RetroCake\Temp\ESCheck
powershell -command "Invoke-WebRequest -Uri https://github.com/jrassa/EmulationStation/releases/download/continuous/EmulationStation-Win32-no-deps.zip -OutFile "C:\RetroCake\Temp\ESCheck\tempES.zip"
cls
C:\RetroCake\Tools\7za\7za.exe x "C:\RetroCake\Temp\ESCheck\tempES.zip" -o"C:\RetroCake\Temp\ESCheck" -aoa
::wmic datafile where name="C:\\RetroCake\\EmulationStation\\emulationstation.exe" get Version /value > C:\RetroCake\Temp\ESCheck\currentES.txt
::wmic datafile where name="C:\\RetroCake\\Temp\\ESCheck\\emulationstation.exe" get Version /value > C:\RetroCake\Temp\ESCheck\newES.txt
for %%I in (C:\RetroCake\EmulationStation\emulationstation.exe) do echo %%~zI > C:\RetroCake\Temp\ESCheck\currentES.txt
for %%I in (C:\\RetroCake\Temp\ESCheck\emulationstation.exe) do echo %%~zI > C:\RetroCake\Temp\ESCheck\newES.txt
cd C:\RetroCake\Temp\ESCheck
set /p currentES=<currentES.txt
set /p newES=<newES.txt
ping 127.0.0.1 -n 2 >nul
IF %currentES%==%newES% goto UpToDate
goto UpdateESQ

:UpdateESQ
cls
echo(
set /P c=An update is available. Would you like to update [Y/N]?
if /I "%c%" EQU "Y" goto UpdateES
if /I "%c%" EQU "N" goto cancelled

:UpdateESQN
cls
echo(
set /P c=EmulationStation not found. Would you like to install [Y/N]?
if /I "%c%" EQU "Y" goto UpdateES
if /I "%c%" EQU "N" goto cancelled

::=================================================================================================================================================================================================================================================================================================================

:updateES
::Backs up old installation
C:\RetroCake\Tools\7za\7za.exe a "C:\RetroCake\Backup\ES_Backup_%gooddayte%_%goodthyme%.zip" "C:\RetroCake\EmulationStation\"

::Removes old Files
rmdir "C:\RetroCake\EmulationStation" /s /q
mkdir "C:\RetroCake\EmulationStation"

::Deletes old shortcut
del "%USERPROFILE%\Desktop\*statio*.lnk

::Downloads the latest build of EmulationStation
cls
echo(
echo(
echo(
echo(
echo(
echo(
echo(
echo ====================================================
echo =                                                  =
echo = DOWNLOADING THE LATEST BUILD OF EMULATIONSTATION =
echo =                                                  =
echo ====================================================
powershell -command "Invoke-WebRequest -Uri https://github.com/jrassa/EmulationStation/releases/download/continuous/EmulationStation-Win32.zip -OutFile "C:\RetroCake\Temp\ES.zip""

::Extracts to the Program Files Directory.
C:\RetroCake\Tools\7za\7za.exe x "C:\RetroCake\Temp\ES.zip" -o"C:\RetroCake\EmulationStation"
cls
echo ================================================
echo =         Cleaning up downloaded files         =
echo ================================================
::New Shortcut Maker
echo Set oWS = WScript.CreateObject("WScript.Shell") > "C:\RetroCake\Temp\CreateShortcut.vbs"
echo sLinkFile = "%USERPROFILE%\Desktop\RetroCake.lnk" >> "C:\RetroCake\Temp\CreateShortcut.vbs"
echo Set oLink = oWS.CreateShortcut(sLinkFile) >> "C:\RetroCake\Temp\CreateShortcut.vbs"
echo oLink.TargetPath = "C:\RetroCake\EmulationStation\emulationstation.exe" >> "C:\RetroCake\Temp\CreateShortcut.vbs"
echo oLink.Save >> "C:\RetroCake\Temp\CreateShortcut.vbs"
cscript "C:\RetroCake\Temp\CreateShortcut.vbs"
del "C:\RetroCake\Temp\CreateShortcut.vbs"

::Cleans up Downlaoded zip
del "C:\RetroCake\Temp\ES.zip"

::Installs default Carbon theme
mkdir "%USERPROFILE%\.emulationstation\themes"
cd "%USERPROFILE%\.emulationstation\themes"
rmdir carbon /S /Q
C:\RetroCake\Tools\git\bin\git.exe clone --recursive https://github.com/RetroPie/es-theme-carbon.git %theme%

IF EXIST C:\RetroCake\Temp\BrandNewBlank goto blankESCFG
IF EXIST C:\RetroCake\Temp\BrandNewDef goto defaultESCFG
IF EXIST C:\RetroCake\Temp\BrandNewCus goto customESCFG
goto completed

::=================================================================================================================================================================================================================================================================================================================
::=================================================================================================================================================================================================================================================================================================================
::=================================================================================================================================================================================================================================================================================================================
::=================================================================================================================================================================================================================================================================================================================
::=================================================================================================================================================================================================================================================================================================================

:ManESCFG
cls
echo ===================================================================================
echo =                                                                                 =
Echo =    1.) CREATE NEW ES_SYSTEMS.CFG WITHOUT ROM PATHS                              =
echo =                                                                                 =
echo =    2.) CREATE NEW ES_SYSTEMS.CFG WITH DEFAULT ROM PATH C:\RetroCake\ROMS\SYSTEM =
echo =                                                                                 =
echo =    3.) CREATE NEW ES_SYSTEMS.CFG WITH CUSTOM ROM PATH                           =
echo =                                                                                 =
echo =    4.) EDIT ES_SYSTEMS.CFG                                                      =
echo =                                                                                 =
echo =                                                                                 =
echo =    5.) RETURN TO EMULATIONSTATION MANAGER                                       =
echo =                                                                                 =
echo ===================================================================================
CHOICE /N /C:12345 /M "Enter Corresponding Menu choice (1, 2, 3, 4, 5)"%1
IF ERRORLEVEL ==5 GOTO esmenu
IF ERRORLEVEL ==4 GOTO editES
IF ERRORLEVEL ==3 GOTO customESCFG
IF ERRORLEVEL ==2 GOTO defaultESCFG
IF ERRORLEVEL ==1 GOTO blankESCFG

:blankESCFG
::Backs up current es_systems.cfg

C:\RetroCake\Tools\7za\7za.exe a "%USERPROFILE%\es_systems_%gooddayte%_%goodthyme%.zip" "%USERPROFILE%\.emulationstation\es_systems.cfg"

::Deletes old es_systems.cfg
del "%USERPROFILE%\.emulationstation\es_systems.cfg" /q

::Creates a new es_systems.cfg
cls
mkdir "%USERPROFILE%\.emulationstation"
echo ^<?xml version="1.0"?^> > "%USERPROFILE%\.emulationstation\es_systems.cfg"

echo ^<systemList^> >> "%USERPROFILE%\.emulationstation\es_systems.cfg"

echo   ^<system^> >> "%USERPROFILE%\.emulationstation\es_systems.cfg"
echo     ^<name^>nes^</name^> >> "%USERPROFILE%\.emulationstation\es_systems.cfg"
echo     ^<fullname^>Nintendo Entertainment System^</fullname^> >> "%USERPROFILE%\.emulationstation\es_systems.cfg"
echo     ^<path^>C:\PATH\TO\ROM\FOLDER\nes^</path^> >> "%USERPROFILE%\.emulationstation\es_systems.cfg"
echo     ^<extension^>.nes .NES^</extension^> >> "%USERPROFILE%\.emulationstation\es_systems.cfg"
echo     ^<command^>C:\RetroCake\RetroArch\retroarch.exe -L C:\RetroCake\RetroArch\cores\bnes_libretro.dll "%%ROM_RAW%%"^</command^> >> "%USERPROFILE%\.emulationstation\es_systems.cfg"
echo     ^<platform^>nes^</platform^> >> "%USERPROFILE%\.emulationstation\es_systems.cfg"
echo     ^<theme^>nes^</theme^> >> "%USERPROFILE%\.emulationstation\es_systems.cfg"
echo   ^</system^> >> "%USERPROFILE%\.emulationstation\es_systems.cfg"

echo   ^<system^> >> "%USERPROFILE%\.emulationstation\es_systems.cfg"
echo     ^<name^>fds^</name^> >> "%USERPROFILE%\.emulationstation\es_systems.cfg"
echo     ^<fullname^>Famicom Disk System^</fullname^> >> "%USERPROFILE%\.emulationstation\es_systems.cfg"
echo     ^<path^>C:\PATH\TO\ROM\FOLDER\fds^</path^> >> "%USERPROFILE%\.emulationstation\es_systems.cfg"
echo     ^<extension^>.nes .fds .zip .NES .FDS .ZIP^</extension^> >> "%USERPROFILE%\.emulationstation\es_systems.cfg"
echo     ^<command^>C:\RetroCake\RetroArch\retroarch.exe -L C:\RetroCake\RetroArch\cores\bnes_libretro.dll "%%ROM_RAW%%"^</command^> >> "%USERPROFILE%\.emulationstation\es_systems.cfg"
echo     ^<platform^>fds^</platform^> >> "%USERPROFILE%\.emulationstation\es_systems.cfg"
echo     ^<theme^>fds^</theme^> >> "%USERPROFILE%\.emulationstation\es_systems.cfg"
echo   ^</system^> >> "%USERPROFILE%\.emulationstation\es_systems.cfg"

echo   ^<system^> >> "%USERPROFILE%\.emulationstation\es_systems.cfg"
echo     ^<name^>snes^</name^> >> "%USERPROFILE%\.emulationstation\es_systems.cfg"
echo     ^<fullname^>Super Nintendo^</fullname^> >> "%USERPROFILE%\.emulationstation\es_systems.cfg"
echo     ^<path^>C:\PATH\TO\ROM\FOLDER\snes^</path^> >> "%USERPROFILE%\.emulationstation\es_systems.cfg"
echo     ^<extension^>.7z .bin .smc .sfc .fig .swc .mgd .zip .7Z .BIN .SMC .SFC .FIG .SWC .MGD .ZIP^</extension^> >> "%USERPROFILE%\.emulationstation\es_systems.cfg"
echo     ^<command^>C:\RetroCake\RetroArch\retroarch.exe -L C:\RetroCake\RetroArch\cores\snes9x2010_libretro.dll "%%ROM_RAW%%"^</command^> >> "%USERPROFILE%\.emulationstation\es_systems.cfg"
echo     ^<platform^>snes^</platform^> >> "%USERPROFILE%\.emulationstation\es_systems.cfg"
echo     ^<theme^>snes^</theme^> >> "%USERPROFILE%\.emulationstation\es_systems.cfg"
echo   ^</system^> >> "%USERPROFILE%\.emulationstation\es_systems.cfg"

echo   ^<system^> >> "%USERPROFILE%\.emulationstation\es_systems.cfg"
echo     ^<name^>n64^</name^> >> "%USERPROFILE%\.emulationstation\es_systems.cfg"
echo     ^<fullname^>Nintendo 64^</fullname^> >> "%USERPROFILE%\.emulationstation\es_systems.cfg"
echo     ^<path^>C:\PATH\TO\ROM\FOLDER\n64^</path^> >> "%USERPROFILE%\.emulationstation\es_systems.cfg"
echo     ^<extension^>.z64 .n64 .v64 .Z64 .N64 .V64^</extension^> >> "%USERPROFILE%\.emulationstation\es_systems.cfg"
echo     ^<command^>C:\RetroCake\RetroArch\retroarch.exe -L C:\RetroCake\RetroArch\cores\mupen64plus_libretro.dll "%%ROM_RAW%%"^</command^> >> "%USERPROFILE%\.emulationstation\es_systems.cfg"
echo     ^<platform^>n64^</platform^> >> "%USERPROFILE%\.emulationstation\es_systems.cfg"
echo     ^<theme^>n64^</theme^> >> "%USERPROFILE%\.emulationstation\es_systems.cfg"
echo   ^</system^> >> "%USERPROFILE%\.emulationstation\es_systems.cfg"

echo   ^<system^> >> "%USERPROFILE%\.emulationstation\es_systems.cfg"
echo 	^<name^>gc^</name^> >> "%USERPROFILE%\.emulationstation\es_systems.cfg"
echo 	^<fullname^>Nintendo Gamecube^</fullname^> >> "%USERPROFILE%\.emulationstation\es_systems.cfg"
echo 	^<path^>C:\PATH\TO\ROM\FOLDER\gc^</path^> >> "%USERPROFILE%\.emulationstation\es_systems.cfg"
echo 	^<extension^>.iso .gcz .gcn .ISO .GCZ .GCN^</extension^> >> "%USERPROFILE%\.emulationstation\es_systems.cfg"
echo 	^<command^>C:\RetroCake\Emulators\Dolphin\Dolphin.exe --exec="%%ROM_RAW%%"^</command^> >> "%USERPROFILE%\.emulationstation\es_systems.cfg"
echo 	^<platform^>gc^</platform^> >> "%USERPROFILE%\.emulationstation\es_systems.cfg"
echo 	^<theme^>gc^</theme^> >> "%USERPROFILE%\.emulationstation\es_systems.cfg"
echo    ^</system^>  >> "%USERPROFILE%\.emulationstation\es_systems.cfg"

echo   ^<system^> >> "%USERPROFILE%\.emulationstation\es_systems.cfg"
echo 	^<name^>wii^</name^> >> "%USERPROFILE%\.emulationstation\es_systems.cfg"
echo 	^<fullname^>Nintendo Wii^</fullname^> >> "%USERPROFILE%\.emulationstation\es_systems.cfg"
echo 	^<path^>C:\PATH\TO\ROM\FOLDER\wii^</path^> >> "%USERPROFILE%\.emulationstation\es_systems.cfg"
echo 	^<extension^>.iso .ISO^</extension^> >> "%USERPROFILE%\.emulationstation\es_systems.cfg"
echo 	^<command^>C:\RetroCake\Emulators\Dolphin\Dolphin.exe --exec="%%ROM_RAW%%"^</command^> >> "%USERPROFILE%\.emulationstation\es_systems.cfg"
echo 	^<platform^>wii^</platform^> >> "%USERPROFILE%\.emulationstation\es_systems.cfg"
echo 	^<theme^>wii^</theme^> >> "%USERPROFILE%\.emulationstation\es_systems.cfg"
echo    ^</system^>  >> "%USERPROFILE%\.emulationstation\es_systems.cfg"

echo   ^<system^> >> "%USERPROFILE%\.emulationstation\es_systems.cfg"
echo     ^<name^>gameandwatch^</name^> >> "%USERPROFILE%\.emulationstation\es_systems.cfg"
echo     ^<fullname^>Game & Watch^</fullname^> >> "%USERPROFILE%\.emulationstation\es_systems.cfg"
echo     ^<path^>C:\PATH\TO\ROM\FOLDER\gameandwatch^</path^> >> "%USERPROFILE%\.emulationstation\es_systems.cfg"
echo     ^<extension^>.mgw .MGW^</extension^> >> "%USERPROFILE%\.emulationstation\es_systems.cfg"
echo     ^<command^>C:\RetroCake\RetroArch\retroarch.exe -L C:\RetroCake\RetroArch\cores\gw_libretro.dll "%%ROM_RAW%%"^</command^> >> "%USERPROFILE%\.emulationstation\es_systems.cfg"
echo     ^<platform^>gameandwatch^</platform^> >> "%USERPROFILE%\.emulationstation\es_systems.cfg"
echo     ^<theme^>gameandwatch^</theme^> >> "%USERPROFILE%\.emulationstation\es_systems.cfg"
echo   ^</system^> >> "%USERPROFILE%\.emulationstation\es_systems.cfg"

echo   ^<system^> >> "%USERPROFILE%\.emulationstation\es_systems.cfg"
echo     ^<name^>gb^</name^> >> "%USERPROFILE%\.emulationstation\es_systems.cfg"
echo     ^<fullname^>Game Boy^</fullname^> >> "%USERPROFILE%\.emulationstation\es_systems.cfg"
echo     ^<path^>C:\PATH\TO\ROM\FOLDER\gb^</path^> >> "%USERPROFILE%\.emulationstation\es_systems.cfg"
echo     ^<extension^>.7z .gb .zip .7Z .GB .ZIP^</extension^> >> "%USERPROFILE%\.emulationstation\es_systems.cfg"
echo     ^<command^>C:\RetroCake\RetroArch\retroarch.exe -L C:\RetroCake\RetroArch\cores\gambatte_libretro.dll "%%ROM_RAW%%"^</command^> >> "%USERPROFILE%\.emulationstation\es_systems.cfg"
echo     ^<platform^>gb^</platform^> >> "%USERPROFILE%\.emulationstation\es_systems.cfg"
echo     ^<theme^>gb^</theme^> >> "%USERPROFILE%\.emulationstation\es_systems.cfg"
echo   ^</system^> >> "%USERPROFILE%\.emulationstation\es_systems.cfg"

echo   ^<system^> >> "%USERPROFILE%\.emulationstation\es_systems.cfg"
echo     ^<name^>virtualboy^</name^> >> "%USERPROFILE%\.emulationstation\es_systems.cfg"
echo     ^<fullname^>Virtualboy^</fullname^> >> "%USERPROFILE%\.emulationstation\es_systems.cfg"
echo     ^<path^>C:\PATH\TO\ROM\FOLDER\virtualboy^</path^> >> "%USERPROFILE%\.emulationstation\es_systems.cfg"
echo     ^<extension^>.7z .vb .zip .7Z .VB .ZIP^</extension^> >> "%USERPROFILE%\.emulationstation\es_systems.cfg"
echo     ^<command^>C:\RetroCake\RetroArch\retroarch.exe -L C:\RetroCake\RetroArch\cores\vecx_libretro.dll "%%ROM_RAW%%"^</command^> >> "%USERPROFILE%\.emulationstation\es_systems.cfg"
echo     ^<platform^>virtualboy^</platform^> >> "%USERPROFILE%\.emulationstation\es_systems.cfg"
echo     ^<theme^>virtualboy^</theme^> >> "%USERPROFILE%\.emulationstation\es_systems.cfg"
echo   ^</system^> >> "%USERPROFILE%\.emulationstation\es_systems.cfg"

echo   ^<system^> >> "%USERPROFILE%\.emulationstation\es_systems.cfg"
echo     ^<name^>gbc^</name^> >> "%USERPROFILE%\.emulationstation\es_systems.cfg"
echo     ^<fullname^>Game Boy Color^</fullname^> >> "%USERPROFILE%\.emulationstation\es_systems.cfg"
echo     ^<path^>C:\PATH\TO\ROM\FOLDER\gbc^</path^> >> "%USERPROFILE%\.emulationstation\es_systems.cfg"
echo     ^<extension^>.7z .gbc .zip .7Z .GBC .ZIP^</extension^> >> "%USERPROFILE%\.emulationstation\es_systems.cfg"
echo     ^<command^>C:\RetroCake\RetroArch\retroarch.exe -L C:\RetroCake\RetroArch\cores\gambatte_libretro.dll "%%ROM_RAW%%"^</command^> >> "%USERPROFILE%\.emulationstation\es_systems.cfg"
echo     ^<platform^>gbc^</platform^> >> "%USERPROFILE%\.emulationstation\es_systems.cfg"
echo     ^<theme^>gbc^</theme^> >> "%USERPROFILE%\.emulationstation\es_systems.cfg"
echo   ^</system^> >> "%USERPROFILE%\.emulationstation\es_systems.cfg"

echo   ^<system^> >> "%USERPROFILE%\.emulationstation\es_systems.cfg"
echo     ^<name^>gba^</name^> >> "%USERPROFILE%\.emulationstation\es_systems.cfg"
echo     ^<fullname^>Game Boy Advance^</fullname^> >> "%USERPROFILE%\.emulationstation\es_systems.cfg"
echo     ^<path^>C:\PATH\TO\ROM\FOLDER\gba^</path^> >> "%USERPROFILE%\.emulationstation\es_systems.cfg"
echo     ^<extension^>.7z .gba .zip .7Z .GBA .ZIP^</extension^> >> "%USERPROFILE%\.emulationstation\es_systems.cfg"
echo     ^<command^>C:\RetroCake\RetroArch\retroarch.exe -L C:\RetroCake\RetroArch\cores\gpsp_libretro.dll "%%ROM_RAW%%"^</command^> >> "%USERPROFILE%\.emulationstation\es_systems.cfg"
echo     ^<platform^>gba^</platform^> >> "%USERPROFILE%\.emulationstation\es_systems.cfg"
echo     ^<theme^>gba^</theme^> >> "%USERPROFILE%\.emulationstation\es_systems.cfg"
echo   ^</system^> >> "%USERPROFILE%\.emulationstation\es_systems.cfg"

echo   ^<system^> >> "%USERPROFILE%\.emulationstation\es_systems.cfg"
echo     ^<name^>nds^</name^> >> "%USERPROFILE%\.emulationstation\es_systems.cfg"
echo     ^<fullname^>Nintendo DS^</fullname^> >> "%USERPROFILE%\.emulationstation\es_systems.cfg"
echo     ^<path^>C:\PATH\TO\ROM\FOLDER\nds^</path^> >> "%USERPROFILE%\.emulationstation\es_systems.cfg"
echo     ^<extension^>.zip .ZIP .nds .NDS^</extension^> >> "%USERPROFILE%\.emulationstation\es_systems.cfg"
echo     ^<command^>C:\RetroCake\RetroArch\retroarch.exe -L C:\RetroCake\RetroArch\cores\melonds_libretro.dll "%%ROM_RAW%%"^</command^> >> "%USERPROFILE%\.emulationstation\es_systems.cfg"
echo     ^<platform^>nds^</platform^> >> "%USERPROFILE%\.emulationstation\es_systems.cfg"
echo     ^<theme^>nds^</theme^> >> "%USERPROFILE%\.emulationstation\es_systems.cfg"
echo   ^</system^> >> "%USERPROFILE%\.emulationstation\es_systems.cfg"

echo   ^<system^> >> "%USERPROFILE%\.emulationstation\es_systems.cfg"
echo     ^<name^>sg-1000^</name^> >> "%USERPROFILE%\.emulationstation\es_systems.cfg"
echo     ^<fullname^>Sega SG-1000^</fullname^> >> "%USERPROFILE%\.emulationstation\es_systems.cfg"
echo     ^<path^>C:\PATH\TO\ROM\FOLDER\sg-1000^</path^> >> "%USERPROFILE%\.emulationstation\es_systems.cfg"
echo     ^<extension^>.sg .bin .zip .SG .BIN .ZIP^</extension^> >> "%USERPROFILE%\.emulationstation\es_systems.cfg"
echo     ^<command^>C:\RetroCake\RetroArch\retroarch.exe -L C:\RetroCake\RetroArch\cores\genesis_plus_gx_libretro.dll "%%ROM_RAW%%"^</command^> >> "%USERPROFILE%\.emulationstation\es_systems.cfg"
echo     ^<platform^>sg-1000^</platform^> >> "%USERPROFILE%\.emulationstation\es_systems.cfg"
echo     ^<theme^>sg-1000^</theme^> >> "%USERPROFILE%\.emulationstation\es_systems.cfg"
echo   ^</system^> >> "%USERPROFILE%\.emulationstation\es_systems.cfg"

echo   ^<system^> >> "%USERPROFILE%\.emulationstation\es_systems.cfg"
echo     ^<name^>mastersystem^</name^> >> "%USERPROFILE%\.emulationstation\es_systems.cfg"
echo     ^<fullname^>Sega Master System^</fullname^> >> "%USERPROFILE%\.emulationstation\es_systems.cfg"
echo     ^<path^>C:\PATH\TO\ROM\FOLDER\mastersystem^</path^> >> "%USERPROFILE%\.emulationstation\es_systems.cfg"
echo     ^<extension^>.7z .sms .bin .zip .7Z .SMS .BIN .ZIP^</extension^> >> "%USERPROFILE%\.emulationstation\es_systems.cfg"
echo     ^<command^>C:\RetroCake\RetroArch\retroarch.exe -L C:\RetroCake\RetroArch\cores\genesis_plus_gx_libretro.dll "%%ROM_RAW%%"^</command^> >> "%USERPROFILE%\.emulationstation\es_systems.cfg"
echo     ^<platform^>mastersystem^</platform^> >> "%USERPROFILE%\.emulationstation\es_systems.cfg"
echo     ^<theme^>mastersystem^</theme^> >> "%USERPROFILE%\.emulationstation\es_systems.cfg"
echo   ^</system^> >> "%USERPROFILE%\.emulationstation\es_systems.cfg"

echo   ^<system^> >> "%USERPROFILE%\.emulationstation\es_systems.cfg"
echo     ^<name^>megadrive^</name^> >> "%USERPROFILE%\.emulationstation\es_systems.cfg"
echo     ^<fullname^>Sega Mega Drive^</fullname^> >> "%USERPROFILE%\.emulationstation\es_systems.cfg"
echo     ^<path^>C:\PATH\TO\ROM\FOLDER\megadrive^</path^> >> "%USERPROFILE%\.emulationstation\es_systems.cfg"
echo     ^<extension^>.7z .smd .bin .gen .md .sg .zip .7Z .SMD .BIN .GEN .MD .SG .ZIP^</extension^> >> "%USERPROFILE%\.emulationstation\es_systems.cfg"
echo     ^<command^>C:\RetroCake\RetroArch\retroarch.exe -L C:\RetroCake\RetroArch\cores\genesis_plus_gx_libretro.dll "%%ROM_RAW%%"^</command^> >> "%USERPROFILE%\.emulationstation\es_systems.cfg"
echo     ^<platform^>megadrive^</platform^> >> "%USERPROFILE%\.emulationstation\es_systems.cfg"
echo     ^<theme^>megadrive^</theme^> >> "%USERPROFILE%\.emulationstation\es_systems.cfg"
echo   ^</system^> >> "%USERPROFILE%\.emulationstation\es_systems.cfg"

echo   ^<system^> >> "%USERPROFILE%\.emulationstation\es_systems.cfg"
echo     ^<name^>segacd^</name^> >> "%USERPROFILE%\.emulationstation\es_systems.cfg"
echo     ^<fullname^>Mega CD^</fullname^> >> "%USERPROFILE%\.emulationstation\es_systems.cfg"
echo     ^<path^>C:\PATH\TO\ROM\FOLDER\segacd^</path^> >> "%USERPROFILE%\.emulationstation\es_systems.cfg"
echo     ^<extension^>.iso .cue .ISO .CUE^</extension^> >> "%USERPROFILE%\.emulationstation\es_systems.cfg"
echo     ^<command^>C:\RetroCake\RetroArch\retroarch.exe -L C:\RetroCake\RetroArch\cores\genesis_plus_gx_libretro.dll "%%ROM_RAW%%"^</command^> >> "%USERPROFILE%\.emulationstation\es_systems.cfg"
echo     ^<platform^>segacd^</platform^> >> "%USERPROFILE%\.emulationstation\es_systems.cfg"
echo     ^<theme^>segacd^</theme^> >> "%USERPROFILE%\.emulationstation\es_systems.cfg"
echo   ^</system^> >> "%USERPROFILE%\.emulationstation\es_systems.cfg"

echo   ^<system^> >> "%USERPROFILE%\.emulationstation\es_systems.cfg"
echo     ^<name^>sega32x^</name^> >> "%USERPROFILE%\.emulationstation\es_systems.cfg"
echo     ^<fullname^>Sega 32X^</fullname^> >> "%USERPROFILE%\.emulationstation\es_systems.cfg"
echo     ^<path^>C:\PATH\TO\ROM\FOLDER\sega32x^</path^> >> "%USERPROFILE%\.emulationstation\es_systems.cfg"
echo     ^<extension^>.7z .32x .smd .bin .md .zip .7Z .32X .SMD .BIN .MD .ZIP^</extension^> >> "%USERPROFILE%\.emulationstation\es_systems.cfg"
echo     ^<command^>C:\RetroCake\RetroArch\retroarch.exe -L C:\RetroCake\RetroArch\cores\picodrive_libretro.dll "%%ROM_RAW%%"^</command^> >> "%USERPROFILE%\.emulationstation\es_systems.cfg"
echo     ^<platform^>sega32x^</platform^> >> "%USERPROFILE%\.emulationstation\es_systems.cfg"
echo     ^<theme^>sega32x^</theme^> >> "%USERPROFILE%\.emulationstation\es_systems.cfg"
echo   ^</system^> >> "%USERPROFILE%\.emulationstation\es_systems.cfg"

echo   ^<system^> >> "%USERPROFILE%\.emulationstation\es_systems.cfg"
echo     ^<name^>saturn^</name^> >> "%USERPROFILE%\.emulationstation\es_systems.cfg"
echo     ^<fullname^>Sega Saturn^</fullname^> >> "%USERPROFILE%\.emulationstation\es_systems.cfg"
echo     ^<path^>C:\PATH\TO\ROM\FOLDER\saturn^</path^> >> "%USERPROFILE%\.emulationstation\es_systems.cfg"
echo     ^<extension^>.cue .CUE^</extension^> >> "%USERPROFILE%\.emulationstation\es_systems.cfg"
echo     ^<command^>C:\RetroCake\RetroArch\retroarch.exe -L C:\RetroCake\RetroArch\cores\mednafen_saturn_libretro.dll "%ROM_RAW%"^</command^> >> "%USERPROFILE%\.emulationstation\es_systems.cfg"
echo     ^<platform^>saturn^</platform^> >> "%USERPROFILE%\.emulationstation\es_systems.cfg"
echo     ^<theme^>saturn^</theme^> >> "%USERPROFILE%\.emulationstation\es_systems.cfg"
echo   ^</system^> >> "%USERPROFILE%\.emulationstation\es_systems.cfg"

echo   ^<system^> >> "%USERPROFILE%\.emulationstation\es_systems.cfg"
echo     ^<name^>dreamcast^</name^> >> "%USERPROFILE%\.emulationstation\es_systems.cfg"
echo     ^<fullname^>Sega Dreamcast^</fullname^> >> "%USERPROFILE%\.emulationstation\es_systems.cfg"
echo     ^<path^>C:\PATH\TO\ROM\FOLDER\dreamcast^</path^> >> "%USERPROFILE%\.emulationstation\es_systems.cfg"
echo     ^<extension^>.gdi .cdi .GDI .CDI^</extension^> >> "%USERPROFILE%\.emulationstation\es_systems.cfg"
echo     ^<command^>C:\RetroCake\RetroArch\retroarch.exe -L C:\RetroCake\RetroArch\cores\reicast_libretro.dll "%%ROM_RAW%%"^</command^> >> "%USERPROFILE%\.emulationstation\es_systems.cfg"
echo     ^<platform^>dreamcast^</platform^> >> "%USERPROFILE%\.emulationstation\es_systems.cfg"
echo     ^<theme^>dreamcast^</theme^> >> "%USERPROFILE%\.emulationstation\es_systems.cfg"
echo   ^</system^> >> "%USERPROFILE%\.emulationstation\es_systems.cfg"

echo   ^<system^> >> "%USERPROFILE%\.emulationstation\es_systems.cfg"
echo     ^<name^>gamegear^</name^> >> "%USERPROFILE%\.emulationstation\es_systems.cfg"
echo     ^<fullname^>Sega Gamegear^</fullname^> >> "%USERPROFILE%\.emulationstation\es_systems.cfg"
echo     ^<path^>C:\PATH\TO\ROM\FOLDER\gamegear^</path^> >> "%USERPROFILE%\.emulationstation\es_systems.cfg"
echo     ^<extension^>.7z .gg .bin .sms .zip .7Z .GG .BIN .SMS .ZIP^</extension^> >> "%USERPROFILE%\.emulationstation\es_systems.cfg"
echo     ^<command^>C:\RetroCake\RetroArch\retroarch.exe -L C:\RetroCake\RetroArch\cores\genesis_plus_gx_libretro.dll "%%ROM_RAW%%"^</command^> >> "%USERPROFILE%\.emulationstation\es_systems.cfg"
echo     ^<platform^>gamegear^</platform^> >> "%USERPROFILE%\.emulationstation\es_systems.cfg"
echo     ^<theme^>gamegear^</theme^> >> "%USERPROFILE%\.emulationstation\es_systems.cfg"
echo   ^</system^> >> "%USERPROFILE%\.emulationstation\es_systems.cfg"

echo   ^<system^> >> "%USERPROFILE%\.emulationstation\es_systems.cfg"
echo     ^<name^>psx^</name^> >> "%USERPROFILE%\.emulationstation\es_systems.cfg"
echo     ^<fullname^>PlayStation^</fullname^> >> "%USERPROFILE%\.emulationstation\es_systems.cfg"
echo     ^<path^>C:\PATH\TO\ROM\FOLDER\psx^</path^> >> "%USERPROFILE%\.emulationstation\es_systems.cfg"
echo     ^<extension^>.cue .cbn .img .iso .m3u .mdf .pbp .toc .z .znx .CUE .CBN .IMG .ISO .M3U .MDF .PBP .TOC .Z .ZNX^</extension^> >> "%USERPROFILE%\.emulationstation\es_systems.cfg"
echo     ^<command^>C:\RetroCake\RetroArch\retroarch.exe -L C:\RetroCake\RetroArch\cores\pcsx_rearmed_libretro.dll "%%ROM_RAW%%"^</command^> >> "%USERPROFILE%\.emulationstation\es_systems.cfg"
echo     ^<platform^>psx^</platform^> >> "%USERPROFILE%\.emulationstation\es_systems.cfg"
echo     ^<theme^>psx^</theme^> >> "%USERPROFILE%\.emulationstation\es_systems.cfg"
echo   ^</system^> >> "%USERPROFILE%\.emulationstation\es_systems.cfg"

echo   ^<system^> >> "%USERPROFILE%\.emulationstation\es_systems.cfg"
echo     ^<name^>ps2^</name^> >> "%USERPROFILE%\.emulationstation\es_systems.cfg"
echo     ^<fullname^>PlayStation 2^</fullname^> >> "%USERPROFILE%\.emulationstation\es_systems.cfg"
echo     ^<path^>C:\PATH\TO\ROM\FOLDER\ps2^</path^> >> "%USERPROFILE%\.emulationstation\es_systems.cfg"
echo     ^<extension^>.cue .cbn .img .iso .m3u .mdf .pbp .toc .z .znx .CUE .CBN .IMG .ISO .M3U .MDF .PBP .TOC .Z .ZNX^</extension^> >> "%USERPROFILE%\.emulationstation\es_systems.cfg"
echo     ^<command^>C:\RetroCake\Emulators\PCSX2\pcsx2.exe "%%ROM_RAW%%" --fullscreen^</command^> >> "%USERPROFILE%\.emulationstation\es_systems.cfg"
echo     ^<platform^>ps2^</platform^> >> "%USERPROFILE%\.emulationstation\es_systems.cfg"
echo     ^<theme^>ps2^</theme^> >> "%USERPROFILE%\.emulationstation\es_systems.cfg"
echo   ^</system^> >> "%USERPROFILE%\.emulationstation\es_systems.cfg"

echo   ^<system^> >> "%USERPROFILE%\.emulationstation\es_systems.cfg"
echo     ^<name^>psp^</name^> >> "%USERPROFILE%\.emulationstation\es_systems.cfg"
echo     ^<fullname^>PlayStation Portable^</fullname^> >> "%USERPROFILE%\.emulationstation\es_systems.cfg"
echo     ^<path^>C:\PATH\TO\ROM\FOLDER\psp^</path^> >> "%USERPROFILE%\.emulationstation\es_systems.cfg"
echo     ^<extension^>.cso .iso .pbp .CSO .ISO .PBP^</extension^> >> "%USERPROFILE%\.emulationstation\es_systems.cfg"
echo     ^<command^>C:\RetroCake\RetroArch\retroarch.exe -L C:\RetroCake\RetroArch\cores\ppsspp_libretro.dll "%%ROM_RAW%%"^</command^> >> "%USERPROFILE%\.emulationstation\es_systems.cfg"
echo     ^<platform^>psp^</platform^> >> "%USERPROFILE%\.emulationstation\es_systems.cfg"
echo     ^<theme^>psp^</theme^> >> "%USERPROFILE%\.emulationstation\es_systems.cfg"
echo   ^</system^> >> "%USERPROFILE%\.emulationstation\es_systems.cfg"

echo   ^<system^> >> "%USERPROFILE%\.emulationstation\es_systems.cfg"
echo     ^<name^>atari2600^</name^> >> "%USERPROFILE%\.emulationstation\es_systems.cfg"
echo     ^<fullname^>Atari 2600^</fullname^> >> "%USERPROFILE%\.emulationstation\es_systems.cfg"
echo     ^<path^>C:\PATH\TO\ROM\FOLDER\atari2600^</path^> >> "%USERPROFILE%\.emulationstation\es_systems.cfg"
echo     ^<extension^>.7z .a26 .bin .rom .zip .gz .7Z .A26 .BIN .ROM .ZIP .GZ^</extension^> >> "%USERPROFILE%\.emulationstation\es_systems.cfg"
echo     ^<command^>C:\RetroCake\RetroArch\retroarch.exe -L C:\RetroCake\RetroArch\cores\stella_libretro.dll "%%ROM_RAW%%"^</command^> >> "%USERPROFILE%\.emulationstation\es_systems.cfg"
echo     ^<platform^>atari2600^</platform^> >> "%USERPROFILE%\.emulationstation\es_systems.cfg"
echo     ^<theme^>atari2600^</theme^> >> "%USERPROFILE%\.emulationstation\es_systems.cfg"
echo   ^</system^> >> "%USERPROFILE%\.emulationstation\es_systems.cfg"

echo   ^<system^> >> "%USERPROFILE%\.emulationstation\es_systems.cfg"
echo     ^<name^>atari800^</name^> >> "%USERPROFILE%\.emulationstation\es_systems.cfg"
echo     ^<fullname^>Atari 800^</fullname^> >> "%USERPROFILE%\.emulationstation\es_systems.cfg"
echo     ^<path^>C:\PATH\TO\ROM\FOLDER\atari800^</path^> >> "%USERPROFILE%\.emulationstation\es_systems.cfg"
echo     ^<extension^>.bas .bin .car .com .xex .atr .xfd .dcm .atr.gz .xfd.gz .BAS .BIN .CAR .COM .XEX .ATR .XFD .DCM .ATR.GZ .XFD.GZ^</extension^> >> "%USERPROFILE%\.emulationstation\es_systems.cfg"
echo     ^<command^>C:\RetroCake\RetroArch\retroarch.exe -L C:\RetroCake\RetroArch\cores\atari800_libretro.dll "%%ROM_RAW%%"^</command^> >> "%USERPROFILE%\.emulationstation\es_systems.cfg"
echo     ^<platform^>atari800^</platform^> >> "%USERPROFILE%\.emulationstation\es_systems.cfg"
echo     ^<theme^>atari800^</theme^> >> "%USERPROFILE%\.emulationstation\es_systems.cfg"
echo   ^</system^> >> "%USERPROFILE%\.emulationstation\es_systems.cfg"

echo   ^<system^> >> "%USERPROFILE%\.emulationstation\es_systems.cfg"
echo     ^<name^>atari5200^</name^> >> "%USERPROFILE%\.emulationstation\es_systems.cfg"
echo     ^<fullname^>Atari 5200^</fullname^> >> "%USERPROFILE%\.emulationstation\es_systems.cfg"
echo     ^<path^>C:\PATH\TO\ROM\FOLDER\atari5200^</path^> >> "%USERPROFILE%\.emulationstation\es_systems.cfg"
echo     ^<extension^>.a52 .bin .car .A52 .BIN .CAR^</extension^> >> "%USERPROFILE%\.emulationstation\es_systems.cfg"
echo     ^<command^>C:\RetroCake\RetroArch\retroarch.exe -L C:\RetroCake\RetroArch\cores\atari800_libretro.dll "%%ROM_RAW%%"^</command^> >> "%USERPROFILE%\.emulationstation\es_systems.cfg"
echo     ^<platform^>atari5200^</platform^> >> "%USERPROFILE%\.emulationstation\es_systems.cfg"
echo     ^<theme^>atari5200^</theme^> >> "%USERPROFILE%\.emulationstation\es_systems.cfg"
echo   ^</system^> >> "%USERPROFILE%\.emulationstation\es_systems.cfg"

echo   ^<system^> >> "%USERPROFILE%\.emulationstation\es_systems.cfg"
echo     ^<name^>atari7800^</name^> >> "%USERPROFILE%\.emulationstation\es_systems.cfg"
echo     ^<fullname^>Atari 7800 ProSystem^</fullname^> >> "%USERPROFILE%\.emulationstation\es_systems.cfg"
echo     ^<path^>C:\PATH\TO\ROM\FOLDER\atari7800^</path^> >> "%USERPROFILE%\.emulationstation\es_systems.cfg"
echo     ^<extension^>.7z .a78 .bin .zip .7Z .A78 .BIN .ZIP^</extension^> >> "%USERPROFILE%\.emulationstation\es_systems.cfg"
echo     ^<command^>C:\RetroCake\RetroArch\retroarch.exe -L C:\RetroCake\RetroArch\cores\prosystem_libretro.dll "%%ROM_RAW%%"^</command^> >> "%USERPROFILE%\.emulationstation\es_systems.cfg"
echo     ^<platform^>atari7800^</platform^> >> "%USERPROFILE%\.emulationstation\es_systems.cfg"
echo     ^<theme^>atari7800^</theme^> >> "%USERPROFILE%\.emulationstation\es_systems.cfg"
echo   ^</system^> >> "%USERPROFILE%\.emulationstation\es_systems.cfg"

echo   ^<system^> >> "%USERPROFILE%\.emulationstation\es_systems.cfg"
echo     ^<name^>atarijaguar^</name^> >> "%USERPROFILE%\.emulationstation\es_systems.cfg"
echo     ^<fullname^>Atari Jaguar^</fullname^> >> "%USERPROFILE%\.emulationstation\es_systems.cfg"
echo     ^<path^>C:\PATH\TO\ROM\FOLDER\atarijaguar^</path^> >> "%USERPROFILE%\.emulationstation\es_systems.cfg"
echo     ^<extension^>.j64 .jag .zip .J64 .JAG .ZIP^</extension^> >> "%USERPROFILE%\.emulationstation\es_systems.cfg"
echo     ^<command^>C:\RetroCake\RetroArch\retroarch.exe -L C:\RetroCake\RetroArch\cores\virtualjaguar_libretro.dll "%%ROM_RAW%%"^</command^> >> "%USERPROFILE%\.emulationstation\es_systems.cfg"
echo     ^<platform^>atarijaguar^</platform^> >> "%USERPROFILE%\.emulationstation\es_systems.cfg"
echo     ^<theme^>atarijaguar^</theme^> >> "%USERPROFILE%\.emulationstation\es_systems.cfg"
echo   ^</system^> >> "%USERPROFILE%\.emulationstation\es_systems.cfg"

echo   ^<system^> >> "%USERPROFILE%\.emulationstation\es_systems.cfg"
echo     ^<name^>atarilynx^</name^> >> "%USERPROFILE%\.emulationstation\es_systems.cfg"
echo     ^<fullname^>Atari Lynx^</fullname^> >> "%USERPROFILE%\.emulationstation\es_systems.cfg"
echo     ^<path^>C:\PATH\TO\ROM\FOLDER\atarilynx^</path^> >> "%USERPROFILE%\.emulationstation\es_systems.cfg"
echo     ^<extension^>.7z .lnx .zip .7Z .LNX .ZIP^</extension^> >> "%USERPROFILE%\.emulationstation\es_systems.cfg"
echo     ^<command^>C:\RetroCake\RetroArch\retroarch.exe -L C:\RetroCake\RetroArch\cores\handy_libretro.dll "%%ROM_RAW%%"^</command^> >> "%USERPROFILE%\.emulationstation\es_systems.cfg"
echo     ^<platform^>atarilynx^</platform^> >> "%USERPROFILE%\.emulationstation\es_systems.cfg"
echo     ^<theme^>atarilynx^</theme^> >> "%USERPROFILE%\.emulationstation\es_systems.cfg"
echo   ^</system^> >> "%USERPROFILE%\.emulationstation\es_systems.cfg"

echo   ^<system^> >> "%USERPROFILE%\.emulationstation\es_systems.cfg"
echo     ^<name^>atarist^</name^> >> "%USERPROFILE%\.emulationstation\es_systems.cfg"
echo     ^<fullname^>Atari ST^</fullname^> >> "%USERPROFILE%\.emulationstation\es_systems.cfg"
echo     ^<path^>C:\PATH\TO\ROM\FOLDER\atarist^</path^> >> "%USERPROFILE%\.emulationstation\es_systems.cfg"
echo     ^<extension^>.st .stx .img .rom .raw .ipf .ctr .ST .STX .IMG .ROM .RAW .IPF .CTR^</extension^> >> "%USERPROFILE%\.emulationstation\es_systems.cfg"
echo     ^<command^>C:\RetroCake\Emulators\Hatari\Hatari.exe "%%ROM_RAW%%"^</command^> >> "%USERPROFILE%\.emulationstation\es_systems.cfg"
echo     ^<platform^>atarist^</platform^> >> "%USERPROFILE%\.emulationstation\es_systems.cfg"
echo     ^<theme^>atarist^</theme^> >> "%USERPROFILE%\.emulationstation\es_systems.cfg"
echo   ^</system^> >> "%USERPROFILE%\.emulationstation\es_systems.cfg"

echo   ^<system^> >> "%USERPROFILE%\.emulationstation\es_systems.cfg"
echo     ^<name^>neogeo^</name^> >> "%USERPROFILE%\.emulationstation\es_systems.cfg"
echo     ^<fullname^>Neo Geo^</fullname^> >> "%USERPROFILE%\.emulationstation\es_systems.cfg"
echo     ^<path^>C:\PATH\TO\ROM\FOLDER\neogeo^</path^> >> "%USERPROFILE%\.emulationstation\es_systems.cfg"
echo     ^<extension^>.fba .zip .FBA .ZIP^</extension^> >> "%USERPROFILE%\.emulationstation\es_systems.cfg"
echo     ^<command^>C:\RetroCake\RetroArch\retroarch.exe -L C:\RetroCake\RetroArch\cores\fbalpha_libretro.dll "%%ROM_RAW%%"^</command^> >> "%USERPROFILE%\.emulationstation\es_systems.cfg"
echo     ^<platform^>neogeo^</platform^> >> "%USERPROFILE%\.emulationstation\es_systems.cfg"
echo     ^<theme^>neogeo^</theme^> >> "%USERPROFILE%\.emulationstation\es_systems.cfg"
echo   ^</system^> >> "%USERPROFILE%\.emulationstation\es_systems.cfg"

echo   ^<system^> >> "%USERPROFILE%\.emulationstation\es_systems.cfg"
echo     ^<name^>fba^</name^> >> "%USERPROFILE%\.emulationstation\es_systems.cfg"
echo     ^<fullname^>Final Burn Alpha^</fullname^> >> "%USERPROFILE%\.emulationstation\es_systems.cfg"
echo     ^<path^>C:\PATH\TO\ROM\FOLDER\fba^</path^> >> "%USERPROFILE%\.emulationstation\es_systems.cfg"
echo     ^<extension^>.fba .zip .FBA .ZIP^</extension^> >> "%USERPROFILE%\.emulationstation\es_systems.cfg"
echo     ^<command^>C:\RetroCake\RetroArch\retroarch.exe -L C:\RetroCake\RetroArch\cores\fbalpha_libretro.dll "%%ROM_RAW%%"^</command^> >> "%USERPROFILE%\.emulationstation\es_systems.cfg"
echo     ^<platform^>arcade^</platform^> >> "%USERPROFILE%\.emulationstation\es_systems.cfg"
echo     ^<theme^>fba^</theme^> >> "%USERPROFILE%\.emulationstation\es_systems.cfg"
echo   ^</system^> >> "%USERPROFILE%\.emulationstation\es_systems.cfg"

echo   ^<system^> >> "%USERPROFILE%\.emulationstation\es_systems.cfg"
echo     ^<name^>ngp^</name^> >> "%USERPROFILE%\.emulationstation\es_systems.cfg"
echo     ^<fullname^>Neo Geo Pocket^</fullname^> >> "%USERPROFILE%\.emulationstation\es_systems.cfg"
echo     ^<path^>C:\PATH\TO\ROM\FOLDER\ngp^</path^> >> "%USERPROFILE%\.emulationstation\es_systems.cfg"
echo     ^<extension^>.ngp .zip .NGP .ZIP^</extension^> >> "%USERPROFILE%\.emulationstation\es_systems.cfg"
echo     ^<command^>C:\RetroCake\RetroArch\retroarch.exe -L C:\RetroCake\RetroArch\cores\mednafen_ngp_libretro.dll "%%ROM_RAW%%"^</command^> >> "%USERPROFILE%\.emulationstation\es_systems.cfg"
echo     ^<platform^>ngp^</platform^> >> "%USERPROFILE%\.emulationstation\es_systems.cfg"
echo     ^<theme^>ngp^</theme^> >> "%USERPROFILE%\.emulationstation\es_systems.cfg"
echo   ^</system^> >> "%USERPROFILE%\.emulationstation\es_systems.cfg"

echo   ^<system^> >> "%USERPROFILE%\.emulationstation\es_systems.cfg"
echo     ^<name^>ngpc^</name^> >> "%USERPROFILE%\.emulationstation\es_systems.cfg"
echo     ^<fullname^>Neo Geo Pocket Color^</fullname^> >> "%USERPROFILE%\.emulationstation\es_systems.cfg"
echo     ^<path^>C:\PATH\TO\ROM\FOLDER\ngpc^</path^> >> "%USERPROFILE%\.emulationstation\es_systems.cfg"
echo     ^<extension^>.ngc .zip .NGC .ZIP^</extension^> >> "%USERPROFILE%\.emulationstation\es_systems.cfg"
echo     ^<command^>C:\RetroCake\RetroArch\retroarch.exe -L C:\RetroCake\RetroArch\cores\mednafen_ngp_libretro.dll "%%ROM_RAW%%"^</command^> >> "%USERPROFILE%\.emulationstation\es_systems.cfg"
echo     ^<platform^>ngpc^</platform^> >> "%USERPROFILE%\.emulationstation\es_systems.cfg"
echo     ^<theme^>ngpc^</theme^> >> "%USERPROFILE%\.emulationstation\es_systems.cfg"
echo   ^</system^> >> "%USERPROFILE%\.emulationstation\es_systems.cfg"

echo   ^<system^> >> "%USERPROFILE%\.emulationstation\es_systems.cfg"
echo     ^<name^>mame-libretro^</name^> >> "%USERPROFILE%\.emulationstation\es_systems.cfg"
echo     ^<fullname^>Multiple Arcade Machine Emulator^</fullname^> >> "%USERPROFILE%\.emulationstation\es_systems.cfg"
echo     ^<path^>C:\PATH\TO\ROM\FOLDER\mame^</path^> >> "%USERPROFILE%\.emulationstation\es_systems.cfg"
echo     ^<extension^>.zip .ZIP^</extension^> >> "%USERPROFILE%\.emulationstation\es_systems.cfg"
echo     ^<command^>C:\RetroCake\RetroArch\retroarch.exe -L C:\RetroCake\RetroArch\cores\mame2003_libretro.dll "%%ROM_RAW%%"^</command^> >> "%USERPROFILE%\.emulationstation\es_systems.cfg"
echo     ^<platform^>arcade^</platform^> >> "%USERPROFILE%\.emulationstation\es_systems.cfg"
echo     ^<theme^>mame^</theme^> >> "%USERPROFILE%\.emulationstation\es_systems.cfg"
echo   ^</system^> >> "%USERPROFILE%\.emulationstation\es_systems.cfg"

echo   ^<system^> >> "%USERPROFILE%\.emulationstation\es_systems.cfg"
echo     ^<name^>3do^</name^> >> "%USERPROFILE%\.emulationstation\es_systems.cfg"
echo     ^<fullname^>3DO^</fullname^> >> "%USERPROFILE%\.emulationstation\es_systems.cfg"
echo     ^<path^>C:\PATH\TO\ROM\FOLDER\3do^</path^> >> "%USERPROFILE%\.emulationstation\es_systems.cfg"
echo     ^<extension^>.iso .ISO^</extension^> >> "%USERPROFILE%\.emulationstation\es_systems.cfg"
echo     ^<command^>C:\RetroCake\RetroArch\retroarch.exe -L C:\RetroCake\RetroArch\cores\4do_libretro.dll "%%ROM_RAW%%"^</command^> >> "%USERPROFILE%\.emulationstation\es_systems.cfg"
echo     ^<platform^>3do^</platform^> >> "%USERPROFILE%\.emulationstation\es_systems.cfg"
echo     ^<theme^>3do^</theme^> >> "%USERPROFILE%\.emulationstation\es_systems.cfg"
echo   ^</system^> >> "%USERPROFILE%\.emulationstation\es_systems.cfg"

echo   ^<system^> >> "%USERPROFILE%\.emulationstation\es_systems.cfg"
echo     ^<name^>ags^</name^> >> "%USERPROFILE%\.emulationstation\es_systems.cfg"
echo     ^<fullname^>Adventure Game Studio^</fullname^> >> "%USERPROFILE%\.emulationstation\es_systems.cfg"
echo     ^<path^>C:\PATH\TO\ROM\FOLDER\ags^</path^> >> "%USERPROFILE%\.emulationstation\es_systems.cfg"
echo     ^<extension^>.exe .EXE^</extension^> >> "%USERPROFILE%\.emulationstation\es_systems.cfg"
echo     ^<command^>C:\RetroCake\RetroArch\retroarch.exe -L C:\RetroCake\RetroArch\cores\ags_libretro.dll "%%ROM_RAW%%"^</command^> >> "%USERPROFILE%\.emulationstation\es_systems.cfg"
echo     ^<platform^>ags^</platform^> >> "%USERPROFILE%\.emulationstation\es_systems.cfg"
echo     ^<theme^>ags^</theme^> >> "%USERPROFILE%\.emulationstation\es_systems.cfg"
echo   ^</system^> >> "%USERPROFILE%\.emulationstation\es_systems.cfg"

echo   ^<system^> >> "%USERPROFILE%\.emulationstation\es_systems.cfg"
echo     ^<name^>amiga^</name^> >> "%USERPROFILE%\.emulationstation\es_systems.cfg"
echo     ^<fullname^>Amiga^</fullname^> >> "%USERPROFILE%\.emulationstation\es_systems.cfg"
echo     ^<path^>C:\PATH\TO\ROM\FOLDER\amiga^</path^> >> "%USERPROFILE%\.emulationstation\es_systems.cfg"
echo     ^<extension^>.adf .ADF .zip .ZIP^</extension^> >> "%USERPROFILE%\.emulationstation\es_systems.cfg"
echo     ^<command^>C:\RetroCake\RetroArch\retroarch.exe -L C:\RetroCake\RetroArch\cores\puae_libretro.dll "%%ROM_RAW%%"^</command^> >> "%USERPROFILE%\.emulationstation\es_systems.cfg"
echo     ^<platform^>amiga^</platform^> >> "%USERPROFILE%\.emulationstation\es_systems.cfg"
echo     ^<theme^>amiga^</theme^> >> "%USERPROFILE%\.emulationstation\es_systems.cfg"
echo   ^</system^> >> "%USERPROFILE%\.emulationstation\es_systems.cfg"

echo   ^<system^> >> "%USERPROFILE%\.emulationstation\es_systems.cfg"
echo     ^<name^>amstradcpc^</name^> >> "%USERPROFILE%\.emulationstation\es_systems.cfg"
echo     ^<fullname^>Amstrad CPC^</fullname^> >> "%USERPROFILE%\.emulationstation\es_systems.cfg"
echo     ^<path^>C:\PATH\TO\ROM\FOLDER\amstradcpc^</path^> >> "%USERPROFILE%\.emulationstation\es_systems.cfg"
echo     ^<extension^>.cdt .cpc .dsk .CDT .CPC .DSK^</extension^> >> "%USERPROFILE%\.emulationstation\es_systems.cfg"
echo     ^<command^>C:\RetroCake\RetroArch\retroarch.exe -L C:\RetroCake\RetroArch\cores\cap32_libretro.dll "%%ROM_RAW%%"^</command^> >> "%USERPROFILE%\.emulationstation\es_systems.cfg"
echo     ^<platform^>amstradcpc^</platform^> >> "%USERPROFILE%\.emulationstation\es_systems.cfg"
echo     ^<theme^>amstradcpc^</theme^> >> "%USERPROFILE%\.emulationstation\es_systems.cfg"
echo   ^</system^> >> "%USERPROFILE%\.emulationstation\es_systems.cfg"

echo   ^<system^> >> "%USERPROFILE%\.emulationstation\es_systems.cfg"
echo     ^<name^>apple2^</name^> >> "%USERPROFILE%\.emulationstation\es_systems.cfg"
echo     ^<fullname^>Apple II^</fullname^> >> "%USERPROFILE%\.emulationstation\es_systems.cfg"
echo     ^<path^>C:\PATH\TO\ROM\FOLDER\apple2^</path^> >> "%USERPROFILE%\.emulationstation\es_systems.cfg"
echo     ^<extension^>.dsk .DSK^</extension^> >> "%USERPROFILE%\.emulationstation\es_systems.cfg"
echo     ^<command^>C:\RetroCake\AppleWin\Applewin.exe "%%ROM_RAW%%"^</command^> >> "%USERPROFILE%\.emulationstation\es_systems.cfg"
echo     ^<platform^>apple2^</platform^> >> "%USERPROFILE%\.emulationstation\es_systems.cfg"
echo     ^<theme^>apple2^</theme^> >> "%USERPROFILE%\.emulationstation\es_systems.cfg"
echo   ^</system^> >> "%USERPROFILE%\.emulationstation\es_systems.cfg"

echo   ^<system^> >> "%USERPROFILE%\.emulationstation\es_systems.cfg"
echo     ^<name^>bbcmicro^</name^> >> "%USERPROFILE%\.emulationstation\es_systems.cfg"
echo     ^<fullname^>Atari ST^</fullname^> >> "%USERPROFILE%\.emulationstation\es_systems.cfg"
echo     ^<path^>C:\PATH\TO\ROM\FOLDER\atarist^</path^> >> "%USERPROFILE%\.emulationstation\es_systems.cfg"
echo     ^<extension^>.ssd .dsd .ad .img .SSD .DSD .AD .IMG^</extension^> >> "%USERPROFILE%\.emulationstation\es_systems.cfg"
echo     ^<command^>C:\RetroCake\Emulators\BeebEm\BeebEm.exe "%%ROM_RAW%%"^</command^> >> "%USERPROFILE%\.emulationstation\es_systems.cfg"
echo     ^<platform^>bbcmicro^</platform^> >> "%USERPROFILE%\.emulationstation\es_systems.cfg"
echo     ^<theme^>bbcmicro^</theme^> >> "%USERPROFILE%\.emulationstation\es_systems.cfg"
echo   ^</system^> >> "%USERPROFILE%\.emulationstation\es_systems.cfg"

echo   ^<system^> >> "%USERPROFILE%\.emulationstation\es_systems.cfg"
echo     ^<name^>c64^</name^> >> "%USERPROFILE%\.emulationstation\es_systems.cfg"
echo     ^<fullname^>Commodore 64^</fullname^> >> "%USERPROFILE%\.emulationstation\es_systems.cfg"
echo     ^<path^>C:\PATH\TO\ROM\FOLDER\c64^</path^> >> "%USERPROFILE%\.emulationstation\es_systems.cfg"
echo     ^<extension^>.crt .d64 .g64 .t64 .tap .x64 .zip .prg .CRT .D64 .G64 .T64 .TAP .X64 .ZIP .PRG^</extension^> >> "%USERPROFILE%\.emulationstation\es_systems.cfg"
echo     ^<command^>C:\RetroCake\Emulators\WinVICE\x64.exe -fullscreen "%%ROM_RAW%%"^</command^> >> "%USERPROFILE%\.emulationstation\es_systems.cfg"
echo     ^<platform^>c64^</platform^> >> "%USERPROFILE%\.emulationstation\es_systems.cfg"
echo     ^<theme^>c64^</theme^> >> "%USERPROFILE%\.emulationstation\es_systems.cfg"
echo   ^</system^> >> "%USERPROFILE%\.emulationstation\es_systems.cfg"

echo   ^<system^> >> "%USERPROFILE%\.emulationstation\es_systems.cfg"
echo     ^<name^>coco^</name^> >> "%USERPROFILE%\.emulationstation\es_systems.cfg"
echo     ^<fullname^>CoCo^</fullname^> >> "%USERPROFILE%\.emulationstation\es_systems.cfg"
echo     ^<path^>C:\PATH\TO\ROM\FOLDER\coco^</path^> >> "%USERPROFILE%\.emulationstation\es_systems.cfg"
echo     ^<extension^>.cas .wav .bas .asc .dmk .jvc .os9 .dsk .vdk .rom .ccc .sna .CAS .WAV .BAS .ASC .DMK .JVC .OS9 .DSK .VDK .ROM .CCC .SNA^</extension^> >> "%USERPROFILE%\.emulationstation\es_systems.cfg"
echo     ^<command^>C:\RetroCake\Emulators\XRoar\xroar.exe "%%ROM_RAW%%"^</command^> >> "%USERPROFILE%\.emulationstation\es_systems.cfg"
echo     ^<platform^>coco^</platform^> >> "%USERPROFILE%\.emulationstation\es_systems.cfg"
echo     ^<theme^>coco^</theme^> >> "%USERPROFILE%\.emulationstation\es_systems.cfg"
echo   ^</system^> >> "%USERPROFILE%\.emulationstation\es_systems.cfg"

echo   ^<system^> >> "%USERPROFILE%\.emulationstation\es_systems.cfg"
echo     ^<name^>coleco^</name^> >> "%USERPROFILE%\.emulationstation\es_systems.cfg"
echo     ^<fullname^>ColecoVision^</fullname^> >> "%USERPROFILE%\.emulationstation\es_systems.cfg"
echo     ^<path^>C:\PATH\TO\ROM\FOLDER\colecovision^</path^> >> "%USERPROFILE%\.emulationstation\es_systems.cfg"
echo     ^<extension^>.bin .col .rom .zip .BIN .COL .ROM .ZIP^</extension^> >> "%USERPROFILE%\.emulationstation\es_systems.cfg"
echo     ^<command^>C:\RetroCake\RetroArch\retroarch.exe -L C:\RetroCake\RetroArch\cores\bluemsx_libretro.dll "%%ROM_RAW%%"^</command^> >> "%USERPROFILE%\.emulationstation\es_systems.cfg"
echo     ^<platform^>colecovision^</platform^> >> "%USERPROFILE%\.emulationstation\es_systems.cfg"
echo     ^<theme^>colecovision^</theme^> >> "%USERPROFILE%\.emulationstation\es_systems.cfg"
echo   ^</system^> >> "%USERPROFILE%\.emulationstation\es_systems.cfg"

echo   ^<system^> >> "%USERPROFILE%\.emulationstation\es_systems.cfg"
echo     ^<name^>daphne^</name^> >> "%USERPROFILE%\.emulationstation\es_systems.cfg"
echo     ^<fullname^>Daphne^</fullname^> >> "%USERPROFILE%\.emulationstation\es_systems.cfg"
echo     ^<path^>C:\PATH\TO\ROM\FOLDER\daphne^</path^> >> "%USERPROFILE%\.emulationstation\es_systems.cfg"
echo     ^<extension^>.daphne .DAPHNE^</extension^> >> "%USERPROFILE%\.emulationstation\es_systems.cfg"
echo     ^<command^>C:\RetroCake\Emulators\Daphne\daphne.exe "%%ROM_RAW%%"^</command^> >> "%USERPROFILE%\.emulationstation\es_systems.cfg"
echo     ^<platform^>daphne^</platform^> >> "%USERPROFILE%\.emulationstation\es_systems.cfg"
echo     ^<theme^>daphne^</theme^> >> "%USERPROFILE%\.emulationstation\es_systems.cfg"
echo   ^</system^> >> "%USERPROFILE%\.emulationstation\es_systems.cfg"

echo   ^<system^> >> "%USERPROFILE%\.emulationstation\es_systems.cfg"
echo     ^<name^>dragon32^</name^> >> "%USERPROFILE%\.emulationstation\es_systems.cfg"
echo     ^<fullname^>Dragon 32^</fullname^> >> "%USERPROFILE%\.emulationstation\es_systems.cfg"
echo     ^<path^>C:\PATH\TO\ROM\FOLDER\dragon32^</path^> >> "%USERPROFILE%\.emulationstation\es_systems.cfg"
echo     ^<extension^>.cas .wav .bas .asc .dmk .jvc .os9 .dsk .vdk .rom .ccc .sna .CAS .WAV .BAS .ASC .DMK .JVC .OS9 .DSK .VDK .ROM .CCC .SNA^</extension^> >> "%USERPROFILE%\.emulationstation\es_systems.cfg"
echo     ^<command^>C:\RetroCake\Emulators\XRoar\xroar.exe "%%ROM_RAW%%"^</command^> >> "%USERPROFILE%\.emulationstation\es_systems.cfg"
echo     ^<platform^>dragon32^</platform^> >> "%USERPROFILE%\.emulationstation\es_systems.cfg"
echo     ^<theme^>dragon32^</theme^> >> "%USERPROFILE%\.emulationstation\es_systems.cfg"
echo   ^</system^> >> "%USERPROFILE%\.emulationstation\es_systems.cfg"

echo   ^<system^> >> "%USERPROFILE%\.emulationstation\es_systems.cfg"
echo     ^<name^>intellivision^</name^> >> "%USERPROFILE%\.emulationstation\es_systems.cfg"
echo     ^<fullname^>Intellivision^</fullname^> >> "%USERPROFILE%\.emulationstation\es_systems.cfg"
echo     ^<path^>C:\PATH\TO\ROM\FOLDER\intellivision^</path^> >> "%USERPROFILE%\.emulationstation\es_systems.cfg"
echo     ^<extension^>.int .bin .INT .BIN^</extension^> >> "%USERPROFILE%\.emulationstation\es_systems.cfg"
echo     ^<command^>C:\RetroCake\Emulators\jzIntv\bin\jzIntv.exe "%%ROM_RAW%%"^</command^> >> "%USERPROFILE%\.emulationstation\es_systems.cfg"
echo     ^<platform^>intellivision^</platform^> >> "%USERPROFILE%\.emulationstation\es_systems.cfg"
echo     ^<theme^>intellivision^</theme^> >> "%USERPROFILE%\.emulationstation\es_systems.cfg"
echo   ^</system^> >> "%USERPROFILE%\.emulationstation\es_systems.cfg"

echo   ^<system^> >> "%USERPROFILE%\.emulationstation\es_systems.cfg"
echo     ^<name^>msx^</name^> >> "%USERPROFILE%\.emulationstation\es_systems.cfg"
echo     ^<fullname^>MSX^</fullname^> >> "%USERPROFILE%\.emulationstation\es_systems.cfg"
echo     ^<path^>C:\PATH\TO\ROM\FOLDER\msx^</path^> >> "%USERPROFILE%\.emulationstation\es_systems.cfg"
echo     ^<extension^>.rom .mx1 .mx2 .col .dsk .zip .ROM .MX1 .MX2 .COL .DSK .ZIP^</extension^> >> "%USERPROFILE%\.emulationstation\es_systems.cfg"
echo     ^<command^>C:\RetroCake\RetroArch\retroarch.exe -L C:\RetroCake\RetroArch\cores\bluemsx_libretro.dll "%%ROM_RAW%%"^</command^> >> "%USERPROFILE%\.emulationstation\es_systems.cfg"
echo     ^<platform^>msx^</platform^> >> "%USERPROFILE%\.emulationstation\es_systems.cfg"
echo     ^<theme^>msx^</theme^> >> "%USERPROFILE%\.emulationstation\es_systems.cfg"
echo   ^</system^> >> "%USERPROFILE%\.emulationstation\es_systems.cfg"

echo   ^<system^> >> "%USERPROFILE%\.emulationstation\es_systems.cfg"
echo     ^<name^>pcengine^</name^> >> "%USERPROFILE%\.emulationstation\es_systems.cfg"
echo     ^<fullname^>PC Engine^</fullname^> >> "%USERPROFILE%\.emulationstation\es_systems.cfg"
echo     ^<path^>C:\PATH\TO\ROM\FOLDER\pcengine^</path^> >> "%USERPROFILE%\.emulationstation\es_systems.cfg"
echo     ^<extension^>.7z .pce .ccd .cue .zip .7Z .PCE .CCD .CUE .ZIP^</extension^> >> "%USERPROFILE%\.emulationstation\es_systems.cfg"
echo     ^<command^>C:\RetroCake\RetroArch\retroarch.exe -L C:\RetroCake\RetroArch\cores\mednafen_pce_fast_libretro.dll "%%ROM_RAW%%"^</command^> >> "%USERPROFILE%\.emulationstation\es_systems.cfg"
echo     ^<platform^>pcengine^</platform^> >> "%USERPROFILE%\.emulationstation\es_systems.cfg"
echo     ^<theme^>pcengine^</theme^> >> "%USERPROFILE%\.emulationstation\es_systems.cfg"
echo   ^</system^> >> "%USERPROFILE%\.emulationstation\es_systems.cfg"

echo   ^<system^> >> "%USERPROFILE%\.emulationstation\es_systems.cfg"
echo     ^<name^>vectrex^</name^> >> "%USERPROFILE%\.emulationstation\es_systems.cfg"
echo     ^<fullname^>Vectrex^</fullname^> >> "%USERPROFILE%\.emulationstation\es_systems.cfg"
echo     ^<path^>C:\PATH\TO\ROM\FOLDER\vectrex^</path^> >> "%USERPROFILE%\.emulationstation\es_systems.cfg"
echo     ^<extension^>.7z .vec .gam .bin .zip .7Z .VEC .GAM .BIN .ZIP^</extension^> >> "%USERPROFILE%\.emulationstation\es_systems.cfg"
echo     ^<command^>C:\RetroCake\RetroArch\retroarch.exe -L C:\RetroCake\RetroArch\cores\vecx_libretro.dll "%%ROM_RAW%%"^</command^> >> "%USERPROFILE%\.emulationstation\es_systems.cfg"
echo     ^<platform^>vectrex^</platform^> >> "%USERPROFILE%\.emulationstation\es_systems.cfg"
echo     ^<theme^>vectrex^</theme^> >> "%USERPROFILE%\.emulationstation\es_systems.cfg"
echo   ^</system^> >> "%USERPROFILE%\.emulationstation\es_systems.cfg"

echo   ^<system^> >> "%USERPROFILE%\.emulationstation\es_systems.cfg"
echo     ^<name^>zxspectrum^</name^> >> "%USERPROFILE%\.emulationstation\es_systems.cfg"
echo     ^<fullname^>ZX Spectrum^</fullname^> >> "%USERPROFILE%\.emulationstation\es_systems.cfg"
echo     ^<path^>C:\PATH\TO\ROM\FOLDER\zxspectrum^</path^> >> "%USERPROFILE%\.emulationstation\es_systems.cfg"
echo     ^<extension^>.7z .sh .sna .szx .z80 .tap .tzx .gz .udi .mgt .img .trd .scl .dsk .zip .7Z .SH .SNA .SZX .Z80 .TAP .TZX .GZ .UDI .MGT .IMG .TRD .SCL .DSK .ZIP^</extension^> >> "%USERPROFILE%\.emulationstation\es_systems.cfg"
echo     ^<command^>C:\RetroCake\RetroArch\retroarch.exe -L C:\RetroCake\RetroArch\cores\fuse_libretro.dll "%%ROM_RAW%%"^</command^> >> "%USERPROFILE%\.emulationstation\es_systems.cfg"
echo     ^<platform^>zxspectrum^</platform^> >> "%USERPROFILE%\.emulationstation\es_systems.cfg"
echo     ^<theme^>zxspectrum^</theme^> >> "%USERPROFILE%\.emulationstation\es_systems.cfg"
echo   ^</system^> >> "%USERPROFILE%\.emulationstation\es_systems.cfg"

echo ^</systemList^> >> "%USERPROFILE%\.emulationstation\es_systems.cfg"
IF EXIST C:\RetroCake\Temp\BrandNewBlank goto updateRA
goto completed

:defaultESCFG
::Backs up current es_systems.cfg

C:\RetroCake\Tools\7za\7za.exe a "%USERPROFILE%\es_systems_%gooddayte%_%goodthyme%.zip" "%USERPROFILE%\.emulationstation\es_systems.cfg"

::Deletes old es_systems.cfg
del "%USERPROFILE%\.emulationstation\es_systems.cfg" /q

::Creates a new es_systems.cfg
cls
mkdir "%USERPROFILE%\.emulationstation"
echo ^<?xml version="1.0"?^> > "%USERPROFILE%\.emulationstation\es_systems.cfg"

echo ^<systemList^> >> "%USERPROFILE%\.emulationstation\es_systems.cfg"

echo   ^<system^> >> "%USERPROFILE%\.emulationstation\es_systems.cfg"
echo     ^<name^>nes^</name^> >> "%USERPROFILE%\.emulationstation\es_systems.cfg"
echo     ^<fullname^>Nintendo Entertainment System^</fullname^> >> "%USERPROFILE%\.emulationstation\es_systems.cfg"
echo     ^<path^>C:\RetroCake\ROMS\nes^</path^> >> "%USERPROFILE%\.emulationstation\es_systems.cfg"
echo     ^<extension^>.nes .NES^</extension^> >> "%USERPROFILE%\.emulationstation\es_systems.cfg"
echo     ^<command^>C:\RetroCake\RetroArch\retroarch.exe -L C:\RetroCake\RetroArch\cores\bnes_libretro.dll "%%ROM_RAW%%"^</command^> >> "%USERPROFILE%\.emulationstation\es_systems.cfg"
echo     ^<platform^>nes^</platform^> >> "%USERPROFILE%\.emulationstation\es_systems.cfg"
echo     ^<theme^>nes^</theme^> >> "%USERPROFILE%\.emulationstation\es_systems.cfg"
echo   ^</system^> >> "%USERPROFILE%\.emulationstation\es_systems.cfg"

echo   ^<system^> >> "%USERPROFILE%\.emulationstation\es_systems.cfg"
echo     ^<name^>fds^</name^> >> "%USERPROFILE%\.emulationstation\es_systems.cfg"
echo     ^<fullname^>Famicom Disk System^</fullname^> >> "%USERPROFILE%\.emulationstation\es_systems.cfg"
echo     ^<path^>C:\RetroCake\ROMS\fds^</path^> >> "%USERPROFILE%\.emulationstation\es_systems.cfg"
echo     ^<extension^>.nes .fds .zip .NES .FDS .ZIP^</extension^> >> "%USERPROFILE%\.emulationstation\es_systems.cfg"
echo     ^<command^>C:\RetroCake\RetroArch\retroarch.exe -L C:\RetroCake\RetroArch\cores\bnes_libretro.dll "%%ROM_RAW%%"^</command^> >> "%USERPROFILE%\.emulationstation\es_systems.cfg"
echo     ^<platform^>fds^</platform^> >> "%USERPROFILE%\.emulationstation\es_systems.cfg"
echo     ^<theme^>fds^</theme^> >> "%USERPROFILE%\.emulationstation\es_systems.cfg"
echo   ^</system^> >> "%USERPROFILE%\.emulationstation\es_systems.cfg"

echo   ^<system^> >> "%USERPROFILE%\.emulationstation\es_systems.cfg"
echo     ^<name^>snes^</name^> >> "%USERPROFILE%\.emulationstation\es_systems.cfg"
echo     ^<fullname^>Super Nintendo^</fullname^> >> "%USERPROFILE%\.emulationstation\es_systems.cfg"
echo     ^<path^>C:\RetroCake\ROMS\snes^</path^> >> "%USERPROFILE%\.emulationstation\es_systems.cfg"
echo     ^<extension^>.7z .bin .smc .sfc .fig .swc .mgd .zip .7Z .BIN .SMC .SFC .FIG .SWC .MGD .ZIP^</extension^> >> "%USERPROFILE%\.emulationstation\es_systems.cfg"
echo     ^<command^>C:\RetroCake\RetroArch\retroarch.exe -L C:\RetroCake\RetroArch\cores\snes9x2010_libretro.dll "%%ROM_RAW%%"^</command^> >> "%USERPROFILE%\.emulationstation\es_systems.cfg"
echo     ^<platform^>snes^</platform^> >> "%USERPROFILE%\.emulationstation\es_systems.cfg"
echo     ^<theme^>snes^</theme^> >> "%USERPROFILE%\.emulationstation\es_systems.cfg"
echo   ^</system^> >> "%USERPROFILE%\.emulationstation\es_systems.cfg"

echo   ^<system^> >> "%USERPROFILE%\.emulationstation\es_systems.cfg"
echo     ^<name^>n64^</name^> >> "%USERPROFILE%\.emulationstation\es_systems.cfg"
echo     ^<fullname^>Nintendo 64^</fullname^> >> "%USERPROFILE%\.emulationstation\es_systems.cfg"
echo     ^<path^>C:\RetroCake\ROMS\n64^</path^> >> "%USERPROFILE%\.emulationstation\es_systems.cfg"
echo     ^<extension^>.z64 .n64 .v64 .Z64 .N64 .V64^</extension^> >> "%USERPROFILE%\.emulationstation\es_systems.cfg"
echo     ^<command^>C:\RetroCake\RetroArch\retroarch.exe -L C:\RetroCake\RetroArch\cores\mupen64plus_libretro.dll "%%ROM_RAW%%"^</command^> >> "%USERPROFILE%\.emulationstation\es_systems.cfg"
echo     ^<platform^>n64^</platform^> >> "%USERPROFILE%\.emulationstation\es_systems.cfg"
echo     ^<theme^>n64^</theme^> >> "%USERPROFILE%\.emulationstation\es_systems.cfg"
echo   ^</system^> >> "%USERPROFILE%\.emulationstation\es_systems.cfg"

echo   ^<system^> >> "%USERPROFILE%\.emulationstation\es_systems.cfg"
echo 	^<name^>gc^</name^> >> "%USERPROFILE%\.emulationstation\es_systems.cfg"
echo 	^<fullname^>Nintendo Gamecube^</fullname^> >> "%USERPROFILE%\.emulationstation\es_systems.cfg"
echo 	^<path^>C:\RetroCake\ROMS\gc^</path^> >> "%USERPROFILE%\.emulationstation\es_systems.cfg"
echo 	^<extension^>.iso .gcz .gcn .ISO .GCZ .GCN^</extension^> >> "%USERPROFILE%\.emulationstation\es_systems.cfg"
echo 	^<command^>C:\RetroCake\Emulators\Dolphin\Dolphin.exe --exec="%%ROM_RAW%%"^</command^> >> "%USERPROFILE%\.emulationstation\es_systems.cfg"
echo 	^<platform^>gc^</platform^> >> "%USERPROFILE%\.emulationstation\es_systems.cfg"
echo 	^<theme^>gc^</theme^> >> "%USERPROFILE%\.emulationstation\es_systems.cfg"
echo    ^</system^>  >> "%USERPROFILE%\.emulationstation\es_systems.cfg"

echo   ^<system^> >> "%USERPROFILE%\.emulationstation\es_systems.cfg"
echo 	^<name^>wii^</name^> >> "%USERPROFILE%\.emulationstation\es_systems.cfg"
echo 	^<fullname^>Nintendo Wii^</fullname^> >> "%USERPROFILE%\.emulationstation\es_systems.cfg"
echo 	^<path^>C:\RetroCake\ROMS\wii^</path^> >> "%USERPROFILE%\.emulationstation\es_systems.cfg"
echo 	^<extension^>.iso .ISO^</extension^> >> "%USERPROFILE%\.emulationstation\es_systems.cfg"
echo 	^<command^>C:\RetroCake\Emulators\Dolphin\Dolphin.exe --exec="%%ROM_RAW%%"^</command^> >> "%USERPROFILE%\.emulationstation\es_systems.cfg"
echo 	^<platform^>wii^</platform^> >> "%USERPROFILE%\.emulationstation\es_systems.cfg"
echo 	^<theme^>wii^</theme^> >> "%USERPROFILE%\.emulationstation\es_systems.cfg"
echo    ^</system^>  >> "%USERPROFILE%\.emulationstation\es_systems.cfg"

echo   ^<system^> >> "%USERPROFILE%\.emulationstation\es_systems.cfg"
echo     ^<name^>gameandwatch^</name^> >> "%USERPROFILE%\.emulationstation\es_systems.cfg"
echo     ^<fullname^>Game & Watch^</fullname^> >> "%USERPROFILE%\.emulationstation\es_systems.cfg"
echo     ^<path^>C:\RetroCake\ROMS\gameandwatch^</path^> >> "%USERPROFILE%\.emulationstation\es_systems.cfg"
echo     ^<extension^>.mgw .MGW^</extension^> >> "%USERPROFILE%\.emulationstation\es_systems.cfg"
echo     ^<command^>C:\RetroCake\RetroArch\retroarch.exe -L C:\RetroCake\RetroArch\cores\gw_libretro.dll "%%ROM_RAW%%"^</command^> >> "%USERPROFILE%\.emulationstation\es_systems.cfg"
echo     ^<platform^>gameandwatch^</platform^> >> "%USERPROFILE%\.emulationstation\es_systems.cfg"
echo     ^<theme^>gameandwatch^</theme^> >> "%USERPROFILE%\.emulationstation\es_systems.cfg"
echo   ^</system^> >> "%USERPROFILE%\.emulationstation\es_systems.cfg"

echo   ^<system^> >> "%USERPROFILE%\.emulationstation\es_systems.cfg"
echo     ^<name^>gb^</name^> >> "%USERPROFILE%\.emulationstation\es_systems.cfg"
echo     ^<fullname^>Game Boy^</fullname^> >> "%USERPROFILE%\.emulationstation\es_systems.cfg"
echo     ^<path^>C:\RetroCake\ROMS\gb^</path^> >> "%USERPROFILE%\.emulationstation\es_systems.cfg"
echo     ^<extension^>.7z .gb .zip .7Z .GB .ZIP^</extension^> >> "%USERPROFILE%\.emulationstation\es_systems.cfg"
echo     ^<command^>C:\RetroCake\RetroArch\retroarch.exe -L C:\RetroCake\RetroArch\cores\gambatte_libretro.dll "%%ROM_RAW%%"^</command^> >> "%USERPROFILE%\.emulationstation\es_systems.cfg"
echo     ^<platform^>gb^</platform^> >> "%USERPROFILE%\.emulationstation\es_systems.cfg"
echo     ^<theme^>gb^</theme^> >> "%USERPROFILE%\.emulationstation\es_systems.cfg"
echo   ^</system^> >> "%USERPROFILE%\.emulationstation\es_systems.cfg"

echo   ^<system^> >> "%USERPROFILE%\.emulationstation\es_systems.cfg"
echo     ^<name^>virtualboy^</name^> >> "%USERPROFILE%\.emulationstation\es_systems.cfg"
echo     ^<fullname^>Virtualboy^</fullname^> >> "%USERPROFILE%\.emulationstation\es_systems.cfg"
echo     ^<path^>C:\RetroCake\ROMS\virtualboy^</path^> >> "%USERPROFILE%\.emulationstation\es_systems.cfg"
echo     ^<extension^>.7z .vb .zip .7Z .VB .ZIP^</extension^> >> "%USERPROFILE%\.emulationstation\es_systems.cfg"
echo     ^<command^>C:\RetroCake\RetroArch\retroarch.exe -L C:\RetroCake\RetroArch\cores\vecx_libretro.dll "%%ROM_RAW%%"^</command^> >> "%USERPROFILE%\.emulationstation\es_systems.cfg"
echo     ^<platform^>virtualboy^</platform^> >> "%USERPROFILE%\.emulationstation\es_systems.cfg"
echo     ^<theme^>virtualboy^</theme^> >> "%USERPROFILE%\.emulationstation\es_systems.cfg"
echo   ^</system^> >> "%USERPROFILE%\.emulationstation\es_systems.cfg"

echo   ^<system^> >> "%USERPROFILE%\.emulationstation\es_systems.cfg"
echo     ^<name^>gbc^</name^> >> "%USERPROFILE%\.emulationstation\es_systems.cfg"
echo     ^<fullname^>Game Boy Color^</fullname^> >> "%USERPROFILE%\.emulationstation\es_systems.cfg"
echo     ^<path^>C:\RetroCake\ROMS\gbc^</path^> >> "%USERPROFILE%\.emulationstation\es_systems.cfg"
echo     ^<extension^>.7z .gbc .zip .7Z .GBC .ZIP^</extension^> >> "%USERPROFILE%\.emulationstation\es_systems.cfg"
echo     ^<command^>C:\RetroCake\RetroArch\retroarch.exe -L C:\RetroCake\RetroArch\cores\gambatte_libretro.dll "%%ROM_RAW%%"^</command^> >> "%USERPROFILE%\.emulationstation\es_systems.cfg"
echo     ^<platform^>gbc^</platform^> >> "%USERPROFILE%\.emulationstation\es_systems.cfg"
echo     ^<theme^>gbc^</theme^> >> "%USERPROFILE%\.emulationstation\es_systems.cfg"
echo   ^</system^> >> "%USERPROFILE%\.emulationstation\es_systems.cfg"

echo   ^<system^> >> "%USERPROFILE%\.emulationstation\es_systems.cfg"
echo     ^<name^>gba^</name^> >> "%USERPROFILE%\.emulationstation\es_systems.cfg"
echo     ^<fullname^>Game Boy Advance^</fullname^> >> "%USERPROFILE%\.emulationstation\es_systems.cfg"
echo     ^<path^>C:\RetroCake\ROMS\gba^</path^> >> "%USERPROFILE%\.emulationstation\es_systems.cfg"
echo     ^<extension^>.7z .gba .zip .7Z .GBA .ZIP^</extension^> >> "%USERPROFILE%\.emulationstation\es_systems.cfg"
echo     ^<command^>C:\RetroCake\RetroArch\retroarch.exe -L C:\RetroCake\RetroArch\cores\gpsp_libretro.dll "%%ROM_RAW%%"^</command^> >> "%USERPROFILE%\.emulationstation\es_systems.cfg"
echo     ^<platform^>gba^</platform^> >> "%USERPROFILE%\.emulationstation\es_systems.cfg"
echo     ^<theme^>gba^</theme^> >> "%USERPROFILE%\.emulationstation\es_systems.cfg"
echo   ^</system^> >> "%USERPROFILE%\.emulationstation\es_systems.cfg"

echo   ^<system^> >> "%USERPROFILE%\.emulationstation\es_systems.cfg"
echo     ^<name^>nds^</name^> >> "%USERPROFILE%\.emulationstation\es_systems.cfg"
echo     ^<fullname^>Nintendo DS^</fullname^> >> "%USERPROFILE%\.emulationstation\es_systems.cfg"
echo     ^<path^>C:\RetroCake\ROMS\nds^</path^> >> "%USERPROFILE%\.emulationstation\es_systems.cfg"
echo     ^<extension^>.zip .ZIP .nds .NDS^</extension^> >> "%USERPROFILE%\.emulationstation\es_systems.cfg"
echo     ^<command^>C:\RetroCake\RetroArch\retroarch.exe -L C:\RetroCake\RetroArch\cores\melonds_libretro.dll "%%ROM_RAW%%"^</command^> >> "%USERPROFILE%\.emulationstation\es_systems.cfg"
echo     ^<platform^>nds^</platform^> >> "%USERPROFILE%\.emulationstation\es_systems.cfg"
echo     ^<theme^>nds^</theme^> >> "%USERPROFILE%\.emulationstation\es_systems.cfg"
echo   ^</system^> >> "%USERPROFILE%\.emulationstation\es_systems.cfg"

echo   ^<system^> >> "%USERPROFILE%\.emulationstation\es_systems.cfg"
echo     ^<name^>sg-1000^</name^> >> "%USERPROFILE%\.emulationstation\es_systems.cfg"
echo     ^<fullname^>Sega SG-1000^</fullname^> >> "%USERPROFILE%\.emulationstation\es_systems.cfg"
echo     ^<path^>C:\RetroCake\ROMS\sg-1000^</path^> >> "%USERPROFILE%\.emulationstation\es_systems.cfg"
echo     ^<extension^>.sg .bin .zip .SG .BIN .ZIP^</extension^> >> "%USERPROFILE%\.emulationstation\es_systems.cfg"
echo     ^<command^>C:\RetroCake\RetroArch\retroarch.exe -L C:\RetroCake\RetroArch\cores\genesis_plus_gx_libretro.dll "%%ROM_RAW%%"^</command^> >> "%USERPROFILE%\.emulationstation\es_systems.cfg"
echo     ^<platform^>sg-1000^</platform^> >> "%USERPROFILE%\.emulationstation\es_systems.cfg"
echo     ^<theme^>sg-1000^</theme^> >> "%USERPROFILE%\.emulationstation\es_systems.cfg"
echo   ^</system^> >> "%USERPROFILE%\.emulationstation\es_systems.cfg"

echo   ^<system^> >> "%USERPROFILE%\.emulationstation\es_systems.cfg"
echo     ^<name^>mastersystem^</name^> >> "%USERPROFILE%\.emulationstation\es_systems.cfg"
echo     ^<fullname^>Sega Master System^</fullname^> >> "%USERPROFILE%\.emulationstation\es_systems.cfg"
echo     ^<path^>C:\RetroCake\ROMS\mastersystem^</path^> >> "%USERPROFILE%\.emulationstation\es_systems.cfg"
echo     ^<extension^>.7z .sms .bin .zip .7Z .SMS .BIN .ZIP^</extension^> >> "%USERPROFILE%\.emulationstation\es_systems.cfg"
echo     ^<command^>C:\RetroCake\RetroArch\retroarch.exe -L C:\RetroCake\RetroArch\cores\genesis_plus_gx_libretro.dll "%%ROM_RAW%%"^</command^> >> "%USERPROFILE%\.emulationstation\es_systems.cfg"
echo     ^<platform^>mastersystem^</platform^> >> "%USERPROFILE%\.emulationstation\es_systems.cfg"
echo     ^<theme^>mastersystem^</theme^> >> "%USERPROFILE%\.emulationstation\es_systems.cfg"
echo   ^</system^> >> "%USERPROFILE%\.emulationstation\es_systems.cfg"

echo   ^<system^> >> "%USERPROFILE%\.emulationstation\es_systems.cfg"
echo     ^<name^>megadrive^</name^> >> "%USERPROFILE%\.emulationstation\es_systems.cfg"
echo     ^<fullname^>Sega Mega Drive^</fullname^> >> "%USERPROFILE%\.emulationstation\es_systems.cfg"
echo     ^<path^>C:\RetroCake\ROMS\megadrive^</path^> >> "%USERPROFILE%\.emulationstation\es_systems.cfg"
echo     ^<extension^>.7z .smd .bin .gen .md .sg .zip .7Z .SMD .BIN .GEN .MD .SG .ZIP^</extension^> >> "%USERPROFILE%\.emulationstation\es_systems.cfg"
echo     ^<command^>C:\RetroCake\RetroArch\retroarch.exe -L C:\RetroCake\RetroArch\cores\genesis_plus_gx_libretro.dll "%%ROM_RAW%%"^</command^> >> "%USERPROFILE%\.emulationstation\es_systems.cfg"
echo     ^<platform^>megadrive^</platform^> >> "%USERPROFILE%\.emulationstation\es_systems.cfg"
echo     ^<theme^>megadrive^</theme^> >> "%USERPROFILE%\.emulationstation\es_systems.cfg"
echo   ^</system^> >> "%USERPROFILE%\.emulationstation\es_systems.cfg"

echo   ^<system^> >> "%USERPROFILE%\.emulationstation\es_systems.cfg"
echo     ^<name^>segacd^</name^> >> "%USERPROFILE%\.emulationstation\es_systems.cfg"
echo     ^<fullname^>Mega CD^</fullname^> >> "%USERPROFILE%\.emulationstation\es_systems.cfg"
echo     ^<path^>C:\RetroCake\ROMS\segacd^</path^> >> "%USERPROFILE%\.emulationstation\es_systems.cfg"
echo     ^<extension^>.iso .cue .ISO .CUE^</extension^> >> "%USERPROFILE%\.emulationstation\es_systems.cfg"
echo     ^<command^>C:\RetroCake\RetroArch\retroarch.exe -L C:\RetroCake\RetroArch\cores\genesis_plus_gx_libretro.dll "%%ROM_RAW%%"^</command^> >> "%USERPROFILE%\.emulationstation\es_systems.cfg"
echo     ^<platform^>segacd^</platform^> >> "%USERPROFILE%\.emulationstation\es_systems.cfg"
echo     ^<theme^>segacd^</theme^> >> "%USERPROFILE%\.emulationstation\es_systems.cfg"
echo   ^</system^> >> "%USERPROFILE%\.emulationstation\es_systems.cfg"

echo   ^<system^> >> "%USERPROFILE%\.emulationstation\es_systems.cfg"
echo     ^<name^>sega32x^</name^> >> "%USERPROFILE%\.emulationstation\es_systems.cfg"
echo     ^<fullname^>Sega 32X^</fullname^> >> "%USERPROFILE%\.emulationstation\es_systems.cfg"
echo     ^<path^>C:\RetroCake\ROMS\sega32x^</path^> >> "%USERPROFILE%\.emulationstation\es_systems.cfg"
echo     ^<extension^>.7z .32x .smd .bin .md .zip .7Z .32X .SMD .BIN .MD .ZIP^</extension^> >> "%USERPROFILE%\.emulationstation\es_systems.cfg"
echo     ^<command^>C:\RetroCake\RetroArch\retroarch.exe -L C:\RetroCake\RetroArch\cores\picodrive_libretro.dll "%%ROM_RAW%%"^</command^> >> "%USERPROFILE%\.emulationstation\es_systems.cfg"
echo     ^<platform^>sega32x^</platform^> >> "%USERPROFILE%\.emulationstation\es_systems.cfg"
echo     ^<theme^>sega32x^</theme^> >> "%USERPROFILE%\.emulationstation\es_systems.cfg"
echo   ^</system^> >> "%USERPROFILE%\.emulationstation\es_systems.cfg"

echo   ^<system^> >> "%USERPROFILE%\.emulationstation\es_systems.cfg"
echo     ^<name^>saturn^</name^> >> "%USERPROFILE%\.emulationstation\es_systems.cfg"
echo     ^<fullname^>Sega Saturn^</fullname^> >> "%USERPROFILE%\.emulationstation\es_systems.cfg"
echo     ^<path^>C:\RetroCake\ROMS\saturn^</path^> >> "%USERPROFILE%\.emulationstation\es_systems.cfg"
echo     ^<extension^>.cue .CUE^</extension^> >> "%USERPROFILE%\.emulationstation\es_systems.cfg"
echo     ^<command^>C:\RetroCake\RetroArch\retroarch.exe -L C:\RetroCake\RetroArch\cores\mednafen_saturn_libretro.dll "%ROM_RAW%"^</command^> >> "%USERPROFILE%\.emulationstation\es_systems.cfg"
echo     ^<platform^>saturn^</platform^> >> "%USERPROFILE%\.emulationstation\es_systems.cfg"
echo     ^<theme^>saturn^</theme^> >> "%USERPROFILE%\.emulationstation\es_systems.cfg"
echo   ^</system^> >> "%USERPROFILE%\.emulationstation\es_systems.cfg"

echo   ^<system^> >> "%USERPROFILE%\.emulationstation\es_systems.cfg"
echo     ^<name^>dreamcast^</name^> >> "%USERPROFILE%\.emulationstation\es_systems.cfg"
echo     ^<fullname^>Sega Dreamcast^</fullname^> >> "%USERPROFILE%\.emulationstation\es_systems.cfg"
echo     ^<path^>C:\RetroCake\ROMS\dreamcast^</path^> >> "%USERPROFILE%\.emulationstation\es_systems.cfg"
echo     ^<extension^>.gdi .cdi .GDI .CDI^</extension^> >> "%USERPROFILE%\.emulationstation\es_systems.cfg"
echo     ^<command^>C:\RetroCake\RetroArch\retroarch.exe -L C:\RetroCake\RetroArch\cores\reicast_libretro.dll "%%ROM_RAW%%"^</command^> >> "%USERPROFILE%\.emulationstation\es_systems.cfg"
echo     ^<platform^>dreamcast^</platform^> >> "%USERPROFILE%\.emulationstation\es_systems.cfg"
echo     ^<theme^>dreamcast^</theme^> >> "%USERPROFILE%\.emulationstation\es_systems.cfg"
echo   ^</system^> >> "%USERPROFILE%\.emulationstation\es_systems.cfg"

echo   ^<system^> >> "%USERPROFILE%\.emulationstation\es_systems.cfg"
echo     ^<name^>gamegear^</name^> >> "%USERPROFILE%\.emulationstation\es_systems.cfg"
echo     ^<fullname^>Sega Gamegear^</fullname^> >> "%USERPROFILE%\.emulationstation\es_systems.cfg"
echo     ^<path^>C:\RetroCake\ROMS\gamegear^</path^> >> "%USERPROFILE%\.emulationstation\es_systems.cfg"
echo     ^<extension^>.7z .gg .bin .sms .zip .7Z .GG .BIN .SMS .ZIP^</extension^> >> "%USERPROFILE%\.emulationstation\es_systems.cfg"
echo     ^<command^>C:\RetroCake\RetroArch\retroarch.exe -L C:\RetroCake\RetroArch\cores\genesis_plus_gx_libretro.dll "%%ROM_RAW%%"^</command^> >> "%USERPROFILE%\.emulationstation\es_systems.cfg"
echo     ^<platform^>gamegear^</platform^> >> "%USERPROFILE%\.emulationstation\es_systems.cfg"
echo     ^<theme^>gamegear^</theme^> >> "%USERPROFILE%\.emulationstation\es_systems.cfg"
echo   ^</system^> >> "%USERPROFILE%\.emulationstation\es_systems.cfg"

echo   ^<system^> >> "%USERPROFILE%\.emulationstation\es_systems.cfg"
echo     ^<name^>psx^</name^> >> "%USERPROFILE%\.emulationstation\es_systems.cfg"
echo     ^<fullname^>PlayStation^</fullname^> >> "%USERPROFILE%\.emulationstation\es_systems.cfg"
echo     ^<path^>C:\RetroCake\ROMS\psx^</path^> >> "%USERPROFILE%\.emulationstation\es_systems.cfg"
echo     ^<extension^>.cue .cbn .img .iso .m3u .mdf .pbp .toc .z .znx .CUE .CBN .IMG .ISO .M3U .MDF .PBP .TOC .Z .ZNX^</extension^> >> "%USERPROFILE%\.emulationstation\es_systems.cfg"
echo     ^<command^>C:\RetroCake\RetroArch\retroarch.exe -L C:\RetroCake\RetroArch\cores\pcsx_rearmed_libretro.dll "%%ROM_RAW%%"^</command^> >> "%USERPROFILE%\.emulationstation\es_systems.cfg"
echo     ^<platform^>psx^</platform^> >> "%USERPROFILE%\.emulationstation\es_systems.cfg"
echo     ^<theme^>psx^</theme^> >> "%USERPROFILE%\.emulationstation\es_systems.cfg"
echo   ^</system^> >> "%USERPROFILE%\.emulationstation\es_systems.cfg"

echo   ^<system^> >> "%USERPROFILE%\.emulationstation\es_systems.cfg"
echo     ^<name^>ps2^</name^> >> "%USERPROFILE%\.emulationstation\es_systems.cfg"
echo     ^<fullname^>PlayStation 2^</fullname^> >> "%USERPROFILE%\.emulationstation\es_systems.cfg"
echo     ^<path^>C:\RetroCake\ROMS\ps2^</path^> >> "%USERPROFILE%\.emulationstation\es_systems.cfg"
echo     ^<extension^>.cue .cbn .img .iso .m3u .mdf .pbp .toc .z .znx .CUE .CBN .IMG .ISO .M3U .MDF .PBP .TOC .Z .ZNX^</extension^> >> "%USERPROFILE%\.emulationstation\es_systems.cfg"
echo     ^<command^>C:\RetroCake\Emulators\PCSX2\pcsx2.exe "%%ROM_RAW%%" --fullscreen^</command^> >> "%USERPROFILE%\.emulationstation\es_systems.cfg"
echo     ^<platform^>ps2^</platform^> >> "%USERPROFILE%\.emulationstation\es_systems.cfg"
echo     ^<theme^>ps2^</theme^> >> "%USERPROFILE%\.emulationstation\es_systems.cfg"
echo   ^</system^> >> "%USERPROFILE%\.emulationstation\es_systems.cfg"

echo   ^<system^> >> "%USERPROFILE%\.emulationstation\es_systems.cfg"
echo     ^<name^>psp^</name^> >> "%USERPROFILE%\.emulationstation\es_systems.cfg"
echo     ^<fullname^>PlayStation Portable^</fullname^> >> "%USERPROFILE%\.emulationstation\es_systems.cfg"
echo     ^<path^>C:\RetroCake\ROMS\psp^</path^> >> "%USERPROFILE%\.emulationstation\es_systems.cfg"
echo     ^<extension^>.cso .iso .pbp .CSO .ISO .PBP^</extension^> >> "%USERPROFILE%\.emulationstation\es_systems.cfg"
echo     ^<command^>C:\RetroCake\RetroArch\retroarch.exe -L C:\RetroCake\RetroArch\cores\ppsspp_libretro.dll "%%ROM_RAW%%"^</command^> >> "%USERPROFILE%\.emulationstation\es_systems.cfg"
echo     ^<platform^>psp^</platform^> >> "%USERPROFILE%\.emulationstation\es_systems.cfg"
echo     ^<theme^>psp^</theme^> >> "%USERPROFILE%\.emulationstation\es_systems.cfg"
echo   ^</system^> >> "%USERPROFILE%\.emulationstation\es_systems.cfg"

echo   ^<system^> >> "%USERPROFILE%\.emulationstation\es_systems.cfg"
echo     ^<name^>atari2600^</name^> >> "%USERPROFILE%\.emulationstation\es_systems.cfg"
echo     ^<fullname^>Atari 2600^</fullname^> >> "%USERPROFILE%\.emulationstation\es_systems.cfg"
echo     ^<path^>C:\RetroCake\ROMS\atari2600^</path^> >> "%USERPROFILE%\.emulationstation\es_systems.cfg"
echo     ^<extension^>.7z .a26 .bin .rom .zip .gz .7Z .A26 .BIN .ROM .ZIP .GZ^</extension^> >> "%USERPROFILE%\.emulationstation\es_systems.cfg"
echo     ^<command^>C:\RetroCake\RetroArch\retroarch.exe -L C:\RetroCake\RetroArch\cores\stella_libretro.dll "%%ROM_RAW%%"^</command^> >> "%USERPROFILE%\.emulationstation\es_systems.cfg"
echo     ^<platform^>atari2600^</platform^> >> "%USERPROFILE%\.emulationstation\es_systems.cfg"
echo     ^<theme^>atari2600^</theme^> >> "%USERPROFILE%\.emulationstation\es_systems.cfg"
echo   ^</system^> >> "%USERPROFILE%\.emulationstation\es_systems.cfg"

echo   ^<system^> >> "%USERPROFILE%\.emulationstation\es_systems.cfg"
echo     ^<name^>atari800^</name^> >> "%USERPROFILE%\.emulationstation\es_systems.cfg"
echo     ^<fullname^>Atari 800^</fullname^> >> "%USERPROFILE%\.emulationstation\es_systems.cfg"
echo     ^<path^>C:\RetroCake\ROMS\atari800^</path^> >> "%USERPROFILE%\.emulationstation\es_systems.cfg"
echo     ^<extension^>.bas .bin .car .com .xex .atr .xfd .dcm .atr.gz .xfd.gz .BAS .BIN .CAR .COM .XEX .ATR .XFD .DCM .ATR.GZ .XFD.GZ^</extension^> >> "%USERPROFILE%\.emulationstation\es_systems.cfg"
echo     ^<command^>C:\RetroCake\RetroArch\retroarch.exe -L C:\RetroCake\RetroArch\cores\atari800_libretro.dll "%%ROM_RAW%%"^</command^> >> "%USERPROFILE%\.emulationstation\es_systems.cfg"
echo     ^<platform^>atari800^</platform^> >> "%USERPROFILE%\.emulationstation\es_systems.cfg"
echo     ^<theme^>atari800^</theme^> >> "%USERPROFILE%\.emulationstation\es_systems.cfg"
echo   ^</system^> >> "%USERPROFILE%\.emulationstation\es_systems.cfg"

echo   ^<system^> >> "%USERPROFILE%\.emulationstation\es_systems.cfg"
echo     ^<name^>atari5200^</name^> >> "%USERPROFILE%\.emulationstation\es_systems.cfg"
echo     ^<fullname^>Atari 5200^</fullname^> >> "%USERPROFILE%\.emulationstation\es_systems.cfg"
echo     ^<path^>C:\RetroCake\ROMS\atari5200^</path^> >> "%USERPROFILE%\.emulationstation\es_systems.cfg"
echo     ^<extension^>.a52 .bin .car .A52 .BIN .CAR^</extension^> >> "%USERPROFILE%\.emulationstation\es_systems.cfg"
echo     ^<command^>C:\RetroCake\RetroArch\retroarch.exe -L C:\RetroCake\RetroArch\cores\atari800_libretro.dll "%%ROM_RAW%%"^</command^> >> "%USERPROFILE%\.emulationstation\es_systems.cfg"
echo     ^<platform^>atari5200^</platform^> >> "%USERPROFILE%\.emulationstation\es_systems.cfg"
echo     ^<theme^>atari5200^</theme^> >> "%USERPROFILE%\.emulationstation\es_systems.cfg"
echo   ^</system^> >> "%USERPROFILE%\.emulationstation\es_systems.cfg"

echo   ^<system^> >> "%USERPROFILE%\.emulationstation\es_systems.cfg"
echo     ^<name^>atari7800^</name^> >> "%USERPROFILE%\.emulationstation\es_systems.cfg"
echo     ^<fullname^>Atari 7800 ProSystem^</fullname^> >> "%USERPROFILE%\.emulationstation\es_systems.cfg"
echo     ^<path^>C:\RetroCake\ROMS\atari7800^</path^> >> "%USERPROFILE%\.emulationstation\es_systems.cfg"
echo     ^<extension^>.7z .a78 .bin .zip .7Z .A78 .BIN .ZIP^</extension^> >> "%USERPROFILE%\.emulationstation\es_systems.cfg"
echo     ^<command^>C:\RetroCake\RetroArch\retroarch.exe -L C:\RetroCake\RetroArch\cores\prosystem_libretro.dll "%%ROM_RAW%%"^</command^> >> "%USERPROFILE%\.emulationstation\es_systems.cfg"
echo     ^<platform^>atari7800^</platform^> >> "%USERPROFILE%\.emulationstation\es_systems.cfg"
echo     ^<theme^>atari7800^</theme^> >> "%USERPROFILE%\.emulationstation\es_systems.cfg"
echo   ^</system^> >> "%USERPROFILE%\.emulationstation\es_systems.cfg"

echo   ^<system^> >> "%USERPROFILE%\.emulationstation\es_systems.cfg"
echo     ^<name^>atarijaguar^</name^> >> "%USERPROFILE%\.emulationstation\es_systems.cfg"
echo     ^<fullname^>Atari Jaguar^</fullname^> >> "%USERPROFILE%\.emulationstation\es_systems.cfg"
echo     ^<path^>C:\RetroCake\ROMS\atarijaguar^</path^> >> "%USERPROFILE%\.emulationstation\es_systems.cfg"
echo     ^<extension^>.j64 .jag .zip .J64 .JAG .ZIP^</extension^> >> "%USERPROFILE%\.emulationstation\es_systems.cfg"
echo     ^<command^>C:\RetroCake\RetroArch\retroarch.exe -L C:\RetroCake\RetroArch\cores\virtualjaguar_libretro.dll "%%ROM_RAW%%"^</command^> >> "%USERPROFILE%\.emulationstation\es_systems.cfg"
echo     ^<platform^>atarijaguar^</platform^> >> "%USERPROFILE%\.emulationstation\es_systems.cfg"
echo     ^<theme^>atarijaguar^</theme^> >> "%USERPROFILE%\.emulationstation\es_systems.cfg"
echo   ^</system^> >> "%USERPROFILE%\.emulationstation\es_systems.cfg"

echo   ^<system^> >> "%USERPROFILE%\.emulationstation\es_systems.cfg"
echo     ^<name^>atarilynx^</name^> >> "%USERPROFILE%\.emulationstation\es_systems.cfg"
echo     ^<fullname^>Atari Lynx^</fullname^> >> "%USERPROFILE%\.emulationstation\es_systems.cfg"
echo     ^<path^>C:\RetroCake\ROMS\atarilynx^</path^> >> "%USERPROFILE%\.emulationstation\es_systems.cfg"
echo     ^<extension^>.7z .lnx .zip .7Z .LNX .ZIP^</extension^> >> "%USERPROFILE%\.emulationstation\es_systems.cfg"
echo     ^<command^>C:\RetroCake\RetroArch\retroarch.exe -L C:\RetroCake\RetroArch\cores\handy_libretro.dll "%%ROM_RAW%%"^</command^> >> "%USERPROFILE%\.emulationstation\es_systems.cfg"
echo     ^<platform^>atarilynx^</platform^> >> "%USERPROFILE%\.emulationstation\es_systems.cfg"
echo     ^<theme^>atarilynx^</theme^> >> "%USERPROFILE%\.emulationstation\es_systems.cfg"
echo   ^</system^> >> "%USERPROFILE%\.emulationstation\es_systems.cfg"

echo   ^<system^> >> "%USERPROFILE%\.emulationstation\es_systems.cfg"
echo     ^<name^>atarist^</name^> >> "%USERPROFILE%\.emulationstation\es_systems.cfg"
echo     ^<fullname^>Atari ST^</fullname^> >> "%USERPROFILE%\.emulationstation\es_systems.cfg"
echo     ^<path^>C:\RetroCake\ROMS\atarist^</path^> >> "%USERPROFILE%\.emulationstation\es_systems.cfg"
echo     ^<extension^>.st .stx .img .rom .raw .ipf .ctr .ST .STX .IMG .ROM .RAW .IPF .CTR^</extension^> >> "%USERPROFILE%\.emulationstation\es_systems.cfg"
echo     ^<command^>C:\RetroCake\Emulators\Hatari\Hatari.exe "%%ROM_RAW%%"^</command^> >> "%USERPROFILE%\.emulationstation\es_systems.cfg"
echo     ^<platform^>atarist^</platform^> >> "%USERPROFILE%\.emulationstation\es_systems.cfg"
echo     ^<theme^>atarist^</theme^> >> "%USERPROFILE%\.emulationstation\es_systems.cfg"
echo   ^</system^> >> "%USERPROFILE%\.emulationstation\es_systems.cfg"

echo   ^<system^> >> "%USERPROFILE%\.emulationstation\es_systems.cfg"
echo     ^<name^>neogeo^</name^> >> "%USERPROFILE%\.emulationstation\es_systems.cfg"
echo     ^<fullname^>Neo Geo^</fullname^> >> "%USERPROFILE%\.emulationstation\es_systems.cfg"
echo     ^<path^>C:\RetroCake\ROMS\neogeo^</path^> >> "%USERPROFILE%\.emulationstation\es_systems.cfg"
echo     ^<extension^>.fba .zip .FBA .ZIP^</extension^> >> "%USERPROFILE%\.emulationstation\es_systems.cfg"
echo     ^<command^>C:\RetroCake\RetroArch\retroarch.exe -L C:\RetroCake\RetroArch\cores\fbalpha_libretro.dll "%%ROM_RAW%%"^</command^> >> "%USERPROFILE%\.emulationstation\es_systems.cfg"
echo     ^<platform^>neogeo^</platform^> >> "%USERPROFILE%\.emulationstation\es_systems.cfg"
echo     ^<theme^>neogeo^</theme^> >> "%USERPROFILE%\.emulationstation\es_systems.cfg"
echo   ^</system^> >> "%USERPROFILE%\.emulationstation\es_systems.cfg"

echo   ^<system^> >> "%USERPROFILE%\.emulationstation\es_systems.cfg"
echo     ^<name^>fba^</name^> >> "%USERPROFILE%\.emulationstation\es_systems.cfg"
echo     ^<fullname^>Final Burn Alpha^</fullname^> >> "%USERPROFILE%\.emulationstation\es_systems.cfg"
echo     ^<path^>C:\RetroCake\ROMS\fba^</path^> >> "%USERPROFILE%\.emulationstation\es_systems.cfg"
echo     ^<extension^>.fba .zip .FBA .ZIP^</extension^> >> "%USERPROFILE%\.emulationstation\es_systems.cfg"
echo     ^<command^>C:\RetroCake\RetroArch\retroarch.exe -L C:\RetroCake\RetroArch\cores\fbalpha_libretro.dll "%%ROM_RAW%%"^</command^> >> "%USERPROFILE%\.emulationstation\es_systems.cfg"
echo     ^<platform^>arcade^</platform^> >> "%USERPROFILE%\.emulationstation\es_systems.cfg"
echo     ^<theme^>fba^</theme^> >> "%USERPROFILE%\.emulationstation\es_systems.cfg"
echo   ^</system^> >> "%USERPROFILE%\.emulationstation\es_systems.cfg"

echo   ^<system^> >> "%USERPROFILE%\.emulationstation\es_systems.cfg"
echo     ^<name^>ngp^</name^> >> "%USERPROFILE%\.emulationstation\es_systems.cfg"
echo     ^<fullname^>Neo Geo Pocket^</fullname^> >> "%USERPROFILE%\.emulationstation\es_systems.cfg"
echo     ^<path^>C:\RetroCake\ROMS\ngp^</path^> >> "%USERPROFILE%\.emulationstation\es_systems.cfg"
echo     ^<extension^>.ngp .zip .NGP .ZIP^</extension^> >> "%USERPROFILE%\.emulationstation\es_systems.cfg"
echo     ^<command^>C:\RetroCake\RetroArch\retroarch.exe -L C:\RetroCake\RetroArch\cores\mednafen_ngp_libretro.dll "%%ROM_RAW%%"^</command^> >> "%USERPROFILE%\.emulationstation\es_systems.cfg"
echo     ^<platform^>ngp^</platform^> >> "%USERPROFILE%\.emulationstation\es_systems.cfg"
echo     ^<theme^>ngp^</theme^> >> "%USERPROFILE%\.emulationstation\es_systems.cfg"
echo   ^</system^> >> "%USERPROFILE%\.emulationstation\es_systems.cfg"

echo   ^<system^> >> "%USERPROFILE%\.emulationstation\es_systems.cfg"
echo     ^<name^>ngpc^</name^> >> "%USERPROFILE%\.emulationstation\es_systems.cfg"
echo     ^<fullname^>Neo Geo Pocket Color^</fullname^> >> "%USERPROFILE%\.emulationstation\es_systems.cfg"
echo     ^<path^>C:\RetroCake\ROMS\ngpc^</path^> >> "%USERPROFILE%\.emulationstation\es_systems.cfg"
echo     ^<extension^>.ngc .zip .NGC .ZIP^</extension^> >> "%USERPROFILE%\.emulationstation\es_systems.cfg"
echo     ^<command^>C:\RetroCake\RetroArch\retroarch.exe -L C:\RetroCake\RetroArch\cores\mednafen_ngp_libretro.dll "%%ROM_RAW%%"^</command^> >> "%USERPROFILE%\.emulationstation\es_systems.cfg"
echo     ^<platform^>ngpc^</platform^> >> "%USERPROFILE%\.emulationstation\es_systems.cfg"
echo     ^<theme^>ngpc^</theme^> >> "%USERPROFILE%\.emulationstation\es_systems.cfg"
echo   ^</system^> >> "%USERPROFILE%\.emulationstation\es_systems.cfg"

echo   ^<system^> >> "%USERPROFILE%\.emulationstation\es_systems.cfg"
echo     ^<name^>mame-libretro^</name^> >> "%USERPROFILE%\.emulationstation\es_systems.cfg"
echo     ^<fullname^>Multiple Arcade Machine Emulator^</fullname^> >> "%USERPROFILE%\.emulationstation\es_systems.cfg"
echo     ^<path^>C:\RetroCake\ROMS\mame^</path^> >> "%USERPROFILE%\.emulationstation\es_systems.cfg"
echo     ^<extension^>.zip .ZIP^</extension^> >> "%USERPROFILE%\.emulationstation\es_systems.cfg"
echo     ^<command^>C:\RetroCake\RetroArch\retroarch.exe -L C:\RetroCake\RetroArch\cores\mame2003_libretro.dll "%%ROM_RAW%%"^</command^> >> "%USERPROFILE%\.emulationstation\es_systems.cfg"
echo     ^<platform^>arcade^</platform^> >> "%USERPROFILE%\.emulationstation\es_systems.cfg"
echo     ^<theme^>mame^</theme^> >> "%USERPROFILE%\.emulationstation\es_systems.cfg"
echo   ^</system^> >> "%USERPROFILE%\.emulationstation\es_systems.cfg"

echo   ^<system^> >> "%USERPROFILE%\.emulationstation\es_systems.cfg"
echo     ^<name^>3do^</name^> >> "%USERPROFILE%\.emulationstation\es_systems.cfg"
echo     ^<fullname^>3DO^</fullname^> >> "%USERPROFILE%\.emulationstation\es_systems.cfg"
echo     ^<path^>C:\RetroCake\ROMS\3do^</path^> >> "%USERPROFILE%\.emulationstation\es_systems.cfg"
echo     ^<extension^>.iso .ISO^</extension^> >> "%USERPROFILE%\.emulationstation\es_systems.cfg"
echo     ^<command^>C:\RetroCake\RetroArch\retroarch.exe -L C:\RetroCake\RetroArch\cores\4do_libretro.dll "%%ROM_RAW%%"^</command^> >> "%USERPROFILE%\.emulationstation\es_systems.cfg"
echo     ^<platform^>3do^</platform^> >> "%USERPROFILE%\.emulationstation\es_systems.cfg"
echo     ^<theme^>3do^</theme^> >> "%USERPROFILE%\.emulationstation\es_systems.cfg"
echo   ^</system^> >> "%USERPROFILE%\.emulationstation\es_systems.cfg"

echo   ^<system^> >> "%USERPROFILE%\.emulationstation\es_systems.cfg"
echo     ^<name^>ags^</name^> >> "%USERPROFILE%\.emulationstation\es_systems.cfg"
echo     ^<fullname^>Adventure Game Studio^</fullname^> >> "%USERPROFILE%\.emulationstation\es_systems.cfg"
echo     ^<path^>C:\RetroCake\ROMS\ags^</path^> >> "%USERPROFILE%\.emulationstation\es_systems.cfg"
echo     ^<extension^>.exe .EXE^</extension^> >> "%USERPROFILE%\.emulationstation\es_systems.cfg"
echo     ^<command^>C:\RetroCake\RetroArch\retroarch.exe -L C:\RetroCake\RetroArch\cores\ags_libretro.dll "%%ROM_RAW%%"^</command^> >> "%USERPROFILE%\.emulationstation\es_systems.cfg"
echo     ^<platform^>ags^</platform^> >> "%USERPROFILE%\.emulationstation\es_systems.cfg"
echo     ^<theme^>ags^</theme^> >> "%USERPROFILE%\.emulationstation\es_systems.cfg"
echo   ^</system^> >> "%USERPROFILE%\.emulationstation\es_systems.cfg"

echo   ^<system^> >> "%USERPROFILE%\.emulationstation\es_systems.cfg"
echo     ^<name^>amiga^</name^> >> "%USERPROFILE%\.emulationstation\es_systems.cfg"
echo     ^<fullname^>Amiga^</fullname^> >> "%USERPROFILE%\.emulationstation\es_systems.cfg"
echo     ^<path^>C:\RetroCake\ROMS\amiga^</path^> >> "%USERPROFILE%\.emulationstation\es_systems.cfg"
echo     ^<extension^>.adf .ADF .zip .ZIP^</extension^> >> "%USERPROFILE%\.emulationstation\es_systems.cfg"
echo     ^<command^>C:\RetroCake\RetroArch\retroarch.exe -L C:\RetroCake\RetroArch\cores\puae_libretro.dll "%%ROM_RAW%%"^</command^> >> "%USERPROFILE%\.emulationstation\es_systems.cfg"
echo     ^<platform^>amiga^</platform^> >> "%USERPROFILE%\.emulationstation\es_systems.cfg"
echo     ^<theme^>amiga^</theme^> >> "%USERPROFILE%\.emulationstation\es_systems.cfg"
echo   ^</system^> >> "%USERPROFILE%\.emulationstation\es_systems.cfg"

echo   ^<system^> >> "%USERPROFILE%\.emulationstation\es_systems.cfg"
echo     ^<name^>amstradcpc^</name^> >> "%USERPROFILE%\.emulationstation\es_systems.cfg"
echo     ^<fullname^>Amstrad CPC^</fullname^> >> "%USERPROFILE%\.emulationstation\es_systems.cfg"
echo     ^<path^>C:\RetroCake\ROMS\amstradcpc^</path^> >> "%USERPROFILE%\.emulationstation\es_systems.cfg"
echo     ^<extension^>.cdt .cpc .dsk .CDT .CPC .DSK^</extension^> >> "%USERPROFILE%\.emulationstation\es_systems.cfg"
echo     ^<command^>C:\RetroCake\RetroArch\retroarch.exe -L C:\RetroCake\RetroArch\cores\cap32_libretro.dll "%%ROM_RAW%%"^</command^> >> "%USERPROFILE%\.emulationstation\es_systems.cfg"
echo     ^<platform^>amstradcpc^</platform^> >> "%USERPROFILE%\.emulationstation\es_systems.cfg"
echo     ^<theme^>amstradcpc^</theme^> >> "%USERPROFILE%\.emulationstation\es_systems.cfg"
echo   ^</system^> >> "%USERPROFILE%\.emulationstation\es_systems.cfg"

echo   ^<system^> >> "%USERPROFILE%\.emulationstation\es_systems.cfg"
echo     ^<name^>apple2^</name^> >> "%USERPROFILE%\.emulationstation\es_systems.cfg"
echo     ^<fullname^>Apple II^</fullname^> >> "%USERPROFILE%\.emulationstation\es_systems.cfg"
echo     ^<path^>C:\RetroCake\ROMS\apple2^</path^> >> "%USERPROFILE%\.emulationstation\es_systems.cfg"
echo     ^<extension^>.dsk .DSK^</extension^> >> "%USERPROFILE%\.emulationstation\es_systems.cfg"
echo     ^<command^>C:\RetroCake\AppleWin\Applewin.exe "%%ROM_RAW%%"^</command^> >> "%USERPROFILE%\.emulationstation\es_systems.cfg"
echo     ^<platform^>apple2^</platform^> >> "%USERPROFILE%\.emulationstation\es_systems.cfg"
echo     ^<theme^>apple2^</theme^> >> "%USERPROFILE%\.emulationstation\es_systems.cfg"
echo   ^</system^> >> "%USERPROFILE%\.emulationstation\es_systems.cfg"

echo   ^<system^> >> "%USERPROFILE%\.emulationstation\es_systems.cfg"
echo     ^<name^>bbcmicro^</name^> >> "%USERPROFILE%\.emulationstation\es_systems.cfg"
echo     ^<fullname^>Atari ST^</fullname^> >> "%USERPROFILE%\.emulationstation\es_systems.cfg"
echo     ^<path^>C:\RetroCake\ROMS\atarist^</path^> >> "%USERPROFILE%\.emulationstation\es_systems.cfg"
echo     ^<extension^>.ssd .dsd .ad .img .SSD .DSD .AD .IMG^</extension^> >> "%USERPROFILE%\.emulationstation\es_systems.cfg"
echo     ^<command^>C:\RetroCake\Emulators\BeebEm\BeebEm.exe "%%ROM_RAW%%"^</command^> >> "%USERPROFILE%\.emulationstation\es_systems.cfg"
echo     ^<platform^>bbcmicro^</platform^> >> "%USERPROFILE%\.emulationstation\es_systems.cfg"
echo     ^<theme^>bbcmicro^</theme^> >> "%USERPROFILE%\.emulationstation\es_systems.cfg"
echo   ^</system^> >> "%USERPROFILE%\.emulationstation\es_systems.cfg"

echo   ^<system^> >> "%USERPROFILE%\.emulationstation\es_systems.cfg"
echo     ^<name^>c64^</name^> >> "%USERPROFILE%\.emulationstation\es_systems.cfg"
echo     ^<fullname^>Commodore 64^</fullname^> >> "%USERPROFILE%\.emulationstation\es_systems.cfg"
echo     ^<path^>C:\RetroCake\ROMS\c64^</path^> >> "%USERPROFILE%\.emulationstation\es_systems.cfg"
echo     ^<extension^>.crt .d64 .g64 .t64 .tap .x64 .zip .prg .CRT .D64 .G64 .T64 .TAP .X64 .ZIP .PRG^</extension^> >> "%USERPROFILE%\.emulationstation\es_systems.cfg"
echo     ^<command^>C:\RetroCake\Emulators\WinVICE\x64.exe -fullscreen "%%ROM_RAW%%"^</command^> >> "%USERPROFILE%\.emulationstation\es_systems.cfg"
echo     ^<platform^>c64^</platform^> >> "%USERPROFILE%\.emulationstation\es_systems.cfg"
echo     ^<theme^>c64^</theme^> >> "%USERPROFILE%\.emulationstation\es_systems.cfg"
echo   ^</system^> >> "%USERPROFILE%\.emulationstation\es_systems.cfg"

echo   ^<system^> >> "%USERPROFILE%\.emulationstation\es_systems.cfg"
echo     ^<name^>coco^</name^> >> "%USERPROFILE%\.emulationstation\es_systems.cfg"
echo     ^<fullname^>CoCo^</fullname^> >> "%USERPROFILE%\.emulationstation\es_systems.cfg"
echo     ^<path^>C:\RetroCake\ROMS\coco^</path^> >> "%USERPROFILE%\.emulationstation\es_systems.cfg"
echo     ^<extension^>.cas .wav .bas .asc .dmk .jvc .os9 .dsk .vdk .rom .ccc .sna .CAS .WAV .BAS .ASC .DMK .JVC .OS9 .DSK .VDK .ROM .CCC .SNA^</extension^> >> "%USERPROFILE%\.emulationstation\es_systems.cfg"
echo     ^<command^>C:\RetroCake\Emulators\XRoar\xroar.exe "%%ROM_RAW%%"^</command^> >> "%USERPROFILE%\.emulationstation\es_systems.cfg"
echo     ^<platform^>coco^</platform^> >> "%USERPROFILE%\.emulationstation\es_systems.cfg"
echo     ^<theme^>coco^</theme^> >> "%USERPROFILE%\.emulationstation\es_systems.cfg"
echo   ^</system^> >> "%USERPROFILE%\.emulationstation\es_systems.cfg"

echo   ^<system^> >> "%USERPROFILE%\.emulationstation\es_systems.cfg"
echo     ^<name^>coleco^</name^> >> "%USERPROFILE%\.emulationstation\es_systems.cfg"
echo     ^<fullname^>ColecoVision^</fullname^> >> "%USERPROFILE%\.emulationstation\es_systems.cfg"
echo     ^<path^>C:\RetroCake\ROMS\colecovision^</path^> >> "%USERPROFILE%\.emulationstation\es_systems.cfg"
echo     ^<extension^>.bin .col .rom .zip .BIN .COL .ROM .ZIP^</extension^> >> "%USERPROFILE%\.emulationstation\es_systems.cfg"
echo     ^<command^>C:\RetroCake\RetroArch\retroarch.exe -L C:\RetroCake\RetroArch\cores\bluemsx_libretro.dll "%%ROM_RAW%%"^</command^> >> "%USERPROFILE%\.emulationstation\es_systems.cfg"
echo     ^<platform^>colecovision^</platform^> >> "%USERPROFILE%\.emulationstation\es_systems.cfg"
echo     ^<theme^>colecovision^</theme^> >> "%USERPROFILE%\.emulationstation\es_systems.cfg"
echo   ^</system^> >> "%USERPROFILE%\.emulationstation\es_systems.cfg"

echo   ^<system^> >> "%USERPROFILE%\.emulationstation\es_systems.cfg"
echo     ^<name^>daphne^</name^> >> "%USERPROFILE%\.emulationstation\es_systems.cfg"
echo     ^<fullname^>Daphne^</fullname^> >> "%USERPROFILE%\.emulationstation\es_systems.cfg"
echo     ^<path^>C:\RetroCake\ROMS\daphne^</path^> >> "%USERPROFILE%\.emulationstation\es_systems.cfg"
echo     ^<extension^>.daphne .DAPHNE^</extension^> >> "%USERPROFILE%\.emulationstation\es_systems.cfg"
echo     ^<command^>C:\RetroCake\Emulators\Daphne\daphne.exe "%%ROM_RAW%%"^</command^> >> "%USERPROFILE%\.emulationstation\es_systems.cfg"
echo     ^<platform^>daphne^</platform^> >> "%USERPROFILE%\.emulationstation\es_systems.cfg"
echo     ^<theme^>daphne^</theme^> >> "%USERPROFILE%\.emulationstation\es_systems.cfg"
echo   ^</system^> >> "%USERPROFILE%\.emulationstation\es_systems.cfg"

echo   ^<system^> >> "%USERPROFILE%\.emulationstation\es_systems.cfg"
echo     ^<name^>dragon32^</name^> >> "%USERPROFILE%\.emulationstation\es_systems.cfg"
echo     ^<fullname^>Dragon 32^</fullname^> >> "%USERPROFILE%\.emulationstation\es_systems.cfg"
echo     ^<path^>C:\RetroCake\ROMS\dragon32^</path^> >> "%USERPROFILE%\.emulationstation\es_systems.cfg"
echo     ^<extension^>.cas .wav .bas .asc .dmk .jvc .os9 .dsk .vdk .rom .ccc .sna .CAS .WAV .BAS .ASC .DMK .JVC .OS9 .DSK .VDK .ROM .CCC .SNA^</extension^> >> "%USERPROFILE%\.emulationstation\es_systems.cfg"
echo     ^<command^>C:\RetroCake\Emulators\XRoar\xroar.exe "%%ROM_RAW%%"^</command^> >> "%USERPROFILE%\.emulationstation\es_systems.cfg"
echo     ^<platform^>dragon32^</platform^> >> "%USERPROFILE%\.emulationstation\es_systems.cfg"
echo     ^<theme^>dragon32^</theme^> >> "%USERPROFILE%\.emulationstation\es_systems.cfg"
echo   ^</system^> >> "%USERPROFILE%\.emulationstation\es_systems.cfg"

echo   ^<system^> >> "%USERPROFILE%\.emulationstation\es_systems.cfg"
echo     ^<name^>intellivision^</name^> >> "%USERPROFILE%\.emulationstation\es_systems.cfg"
echo     ^<fullname^>Intellivision^</fullname^> >> "%USERPROFILE%\.emulationstation\es_systems.cfg"
echo     ^<path^>C:\RetroCake\ROMS\intellivision^</path^> >> "%USERPROFILE%\.emulationstation\es_systems.cfg"
echo     ^<extension^>.int .bin .INT .BIN^</extension^> >> "%USERPROFILE%\.emulationstation\es_systems.cfg"
echo     ^<command^>C:\RetroCake\Emulators\jzIntv\bin\jzIntv.exe "%%ROM_RAW%%"^</command^> >> "%USERPROFILE%\.emulationstation\es_systems.cfg"
echo     ^<platform^>intellivision^</platform^> >> "%USERPROFILE%\.emulationstation\es_systems.cfg"
echo     ^<theme^>intellivision^</theme^> >> "%USERPROFILE%\.emulationstation\es_systems.cfg"
echo   ^</system^> >> "%USERPROFILE%\.emulationstation\es_systems.cfg"

echo   ^<system^> >> "%USERPROFILE%\.emulationstation\es_systems.cfg"
echo     ^<name^>msx^</name^> >> "%USERPROFILE%\.emulationstation\es_systems.cfg"
echo     ^<fullname^>MSX^</fullname^> >> "%USERPROFILE%\.emulationstation\es_systems.cfg"
echo     ^<path^>C:\RetroCake\ROMS\msx^</path^> >> "%USERPROFILE%\.emulationstation\es_systems.cfg"
echo     ^<extension^>.rom .mx1 .mx2 .col .dsk .zip .ROM .MX1 .MX2 .COL .DSK .ZIP^</extension^> >> "%USERPROFILE%\.emulationstation\es_systems.cfg"
echo     ^<command^>C:\RetroCake\RetroArch\retroarch.exe -L C:\RetroCake\RetroArch\cores\bluemsx_libretro.dll "%%ROM_RAW%%"^</command^> >> "%USERPROFILE%\.emulationstation\es_systems.cfg"
echo     ^<platform^>msx^</platform^> >> "%USERPROFILE%\.emulationstation\es_systems.cfg"
echo     ^<theme^>msx^</theme^> >> "%USERPROFILE%\.emulationstation\es_systems.cfg"
echo   ^</system^> >> "%USERPROFILE%\.emulationstation\es_systems.cfg"

echo   ^<system^> >> "%USERPROFILE%\.emulationstation\es_systems.cfg"
echo     ^<name^>pcengine^</name^> >> "%USERPROFILE%\.emulationstation\es_systems.cfg"
echo     ^<fullname^>PC Engine^</fullname^> >> "%USERPROFILE%\.emulationstation\es_systems.cfg"
echo     ^<path^>C:\RetroCake\ROMS\pcengine^</path^> >> "%USERPROFILE%\.emulationstation\es_systems.cfg"
echo     ^<extension^>.7z .pce .ccd .cue .zip .7Z .PCE .CCD .CUE .ZIP^</extension^> >> "%USERPROFILE%\.emulationstation\es_systems.cfg"
echo     ^<command^>C:\RetroCake\RetroArch\retroarch.exe -L C:\RetroCake\RetroArch\cores\mednafen_pce_fast_libretro.dll "%%ROM_RAW%%"^</command^> >> "%USERPROFILE%\.emulationstation\es_systems.cfg"
echo     ^<platform^>pcengine^</platform^> >> "%USERPROFILE%\.emulationstation\es_systems.cfg"
echo     ^<theme^>pcengine^</theme^> >> "%USERPROFILE%\.emulationstation\es_systems.cfg"
echo   ^</system^> >> "%USERPROFILE%\.emulationstation\es_systems.cfg"

echo   ^<system^> >> "%USERPROFILE%\.emulationstation\es_systems.cfg"
echo     ^<name^>vectrex^</name^> >> "%USERPROFILE%\.emulationstation\es_systems.cfg"
echo     ^<fullname^>Vectrex^</fullname^> >> "%USERPROFILE%\.emulationstation\es_systems.cfg"
echo     ^<path^>C:\RetroCake\ROMS\vectrex^</path^> >> "%USERPROFILE%\.emulationstation\es_systems.cfg"
echo     ^<extension^>.7z .vec .gam .bin .zip .7Z .VEC .GAM .BIN .ZIP^</extension^> >> "%USERPROFILE%\.emulationstation\es_systems.cfg"
echo     ^<command^>C:\RetroCake\RetroArch\retroarch.exe -L C:\RetroCake\RetroArch\cores\vecx_libretro.dll "%%ROM_RAW%%"^</command^> >> "%USERPROFILE%\.emulationstation\es_systems.cfg"
echo     ^<platform^>vectrex^</platform^> >> "%USERPROFILE%\.emulationstation\es_systems.cfg"
echo     ^<theme^>vectrex^</theme^> >> "%USERPROFILE%\.emulationstation\es_systems.cfg"
echo   ^</system^> >> "%USERPROFILE%\.emulationstation\es_systems.cfg"

echo   ^<system^> >> "%USERPROFILE%\.emulationstation\es_systems.cfg"
echo     ^<name^>zxspectrum^</name^> >> "%USERPROFILE%\.emulationstation\es_systems.cfg"
echo     ^<fullname^>ZX Spectrum^</fullname^> >> "%USERPROFILE%\.emulationstation\es_systems.cfg"
echo     ^<path^>C:\RetroCake\ROMS\zxspectrum^</path^> >> "%USERPROFILE%\.emulationstation\es_systems.cfg"
echo     ^<extension^>.7z .sh .sna .szx .z80 .tap .tzx .gz .udi .mgt .img .trd .scl .dsk .zip .7Z .SH .SNA .SZX .Z80 .TAP .TZX .GZ .UDI .MGT .IMG .TRD .SCL .DSK .ZIP^</extension^> >> "%USERPROFILE%\.emulationstation\es_systems.cfg"
echo     ^<command^>C:\RetroCake\RetroArch\retroarch.exe -L C:\RetroCake\RetroArch\cores\fuse_libretro.dll "%%ROM_RAW%%"^</command^> >> "%USERPROFILE%\.emulationstation\es_systems.cfg"
echo     ^<platform^>zxspectrum^</platform^> >> "%USERPROFILE%\.emulationstation\es_systems.cfg"
echo     ^<theme^>zxspectrum^</theme^> >> "%USERPROFILE%\.emulationstation\es_systems.cfg"
echo   ^</system^> >> "%USERPROFILE%\.emulationstation\es_systems.cfg"

echo ^</systemList^> >> "%USERPROFILE%\.emulationstation\es_systems.cfg"
IF EXIST C:\RetroCake\Temp\BrandNewDef goto DefaultRomFolders
goto completed

:customESCFG
cls
echo(
set /p cusromdir="Enter Path for ROM Folder (default C:\RetroCake\ROMS): "

echo ^<?xml version="1.0"?^> > "%USERPROFILE%\.emulationstation\es_systems.cfg"

echo ^<systemList^> >> "%USERPROFILE%\.emulationstation\es_systems.cfg"

echo   ^<system^> >> "%USERPROFILE%\.emulationstation\es_systems.cfg"
echo     ^<name^>nes^</name^> >> "%USERPROFILE%\.emulationstation\es_systems.cfg"
echo     ^<fullname^>Nintendo Entertainment System^</fullname^> >> "%USERPROFILE%\.emulationstation\es_systems.cfg"
echo     ^<path^>%cusromdir%\nes^</path^> >> "%USERPROFILE%\.emulationstation\es_systems.cfg"
echo     ^<extension^>.nes .NES^</extension^> >> "%USERPROFILE%\.emulationstation\es_systems.cfg"
echo     ^<command^>C:\RetroCake\RetroArch\retroarch.exe -L C:\RetroCake\RetroArch\cores\bnes_libretro.dll "%%ROM_RAW%%"^</command^> >> "%USERPROFILE%\.emulationstation\es_systems.cfg"
echo     ^<platform^>nes^</platform^> >> "%USERPROFILE%\.emulationstation\es_systems.cfg"
echo     ^<theme^>nes^</theme^> >> "%USERPROFILE%\.emulationstation\es_systems.cfg"
echo   ^</system^> >> "%USERPROFILE%\.emulationstation\es_systems.cfg"

echo   ^<system^> >> "%USERPROFILE%\.emulationstation\es_systems.cfg"
echo     ^<name^>fds^</name^> >> "%USERPROFILE%\.emulationstation\es_systems.cfg"
echo     ^<fullname^>Famicom Disk System^</fullname^> >> "%USERPROFILE%\.emulationstation\es_systems.cfg"
echo     ^<path^>%cusromdir%\fds^</path^> >> "%USERPROFILE%\.emulationstation\es_systems.cfg"
echo     ^<extension^>.nes .fds .zip .NES .FDS .ZIP^</extension^> >> "%USERPROFILE%\.emulationstation\es_systems.cfg"
echo     ^<command^>C:\RetroCake\RetroArch\retroarch.exe -L C:\RetroCake\RetroArch\cores\bnes_libretro.dll "%%ROM_RAW%%"^</command^> >> "%USERPROFILE%\.emulationstation\es_systems.cfg"
echo     ^<platform^>fds^</platform^> >> "%USERPROFILE%\.emulationstation\es_systems.cfg"
echo     ^<theme^>fds^</theme^> >> "%USERPROFILE%\.emulationstation\es_systems.cfg"
echo   ^</system^> >> "%USERPROFILE%\.emulationstation\es_systems.cfg"

echo   ^<system^> >> "%USERPROFILE%\.emulationstation\es_systems.cfg"
echo     ^<name^>snes^</name^> >> "%USERPROFILE%\.emulationstation\es_systems.cfg"
echo     ^<fullname^>Super Nintendo^</fullname^> >> "%USERPROFILE%\.emulationstation\es_systems.cfg"
echo     ^<path^>%cusromdir%\snes^</path^> >> "%USERPROFILE%\.emulationstation\es_systems.cfg"
echo     ^<extension^>.7z .bin .smc .sfc .fig .swc .mgd .zip .7Z .BIN .SMC .SFC .FIG .SWC .MGD .ZIP^</extension^> >> "%USERPROFILE%\.emulationstation\es_systems.cfg"
echo     ^<command^>C:\RetroCake\RetroArch\retroarch.exe -L C:\RetroCake\RetroArch\cores\snes9x2010_libretro.dll "%%ROM_RAW%%"^</command^> >> "%USERPROFILE%\.emulationstation\es_systems.cfg"
echo     ^<platform^>snes^</platform^> >> "%USERPROFILE%\.emulationstation\es_systems.cfg"
echo     ^<theme^>snes^</theme^> >> "%USERPROFILE%\.emulationstation\es_systems.cfg"
echo   ^</system^> >> "%USERPROFILE%\.emulationstation\es_systems.cfg"

echo   ^<system^> >> "%USERPROFILE%\.emulationstation\es_systems.cfg"
echo     ^<name^>n64^</name^> >> "%USERPROFILE%\.emulationstation\es_systems.cfg"
echo     ^<fullname^>Nintendo 64^</fullname^> >> "%USERPROFILE%\.emulationstation\es_systems.cfg"
echo     ^<path^>%cusromdir%\n64^</path^> >> "%USERPROFILE%\.emulationstation\es_systems.cfg"
echo     ^<extension^>.z64 .n64 .v64 .Z64 .N64 .V64^</extension^> >> "%USERPROFILE%\.emulationstation\es_systems.cfg"
echo     ^<command^>C:\RetroCake\RetroArch\retroarch.exe -L C:\RetroCake\RetroArch\cores\mupen64plus_libretro.dll "%%ROM_RAW%%"^</command^> >> "%USERPROFILE%\.emulationstation\es_systems.cfg"
echo     ^<platform^>n64^</platform^> >> "%USERPROFILE%\.emulationstation\es_systems.cfg"
echo     ^<theme^>n64^</theme^> >> "%USERPROFILE%\.emulationstation\es_systems.cfg"
echo   ^</system^> >> "%USERPROFILE%\.emulationstation\es_systems.cfg"

echo   ^<system^> >> "%USERPROFILE%\.emulationstation\es_systems.cfg"
echo 	^<name^>gc^</name^> >> "%USERPROFILE%\.emulationstation\es_systems.cfg"
echo 	^<fullname^>Nintendo Gamecube^</fullname^> >> "%USERPROFILE%\.emulationstation\es_systems.cfg"
echo 	^<path^>%cusromdir%\gc^</path^> >> "%USERPROFILE%\.emulationstation\es_systems.cfg"
echo 	^<extension^>.iso .gcz .gcn .ISO .GCZ .GCN^</extension^> >> "%USERPROFILE%\.emulationstation\es_systems.cfg"
echo 	^<command^>C:\RetroCake\Emulators\Dolphin\Dolphin.exe --exec="%%ROM_RAW%%"^</command^> >> "%USERPROFILE%\.emulationstation\es_systems.cfg"
echo 	^<platform^>gc^</platform^> >> "%USERPROFILE%\.emulationstation\es_systems.cfg"
echo 	^<theme^>gc^</theme^> >> "%USERPROFILE%\.emulationstation\es_systems.cfg"
echo    ^</system^>  >> "%USERPROFILE%\.emulationstation\es_systems.cfg"

echo   ^<system^> >> "%USERPROFILE%\.emulationstation\es_systems.cfg"
echo 	^<name^>wii^</name^> >> "%USERPROFILE%\.emulationstation\es_systems.cfg"
echo 	^<fullname^>Nintendo Wii^</fullname^> >> "%USERPROFILE%\.emulationstation\es_systems.cfg"
echo 	^<path^>%cusromdir%\wii^</path^> >> "%USERPROFILE%\.emulationstation\es_systems.cfg"
echo 	^<extension^>.iso .ISO^</extension^> >> "%USERPROFILE%\.emulationstation\es_systems.cfg"
echo 	^<command^>C:\RetroCake\Emulators\Dolphin\Dolphin.exe --exec="%%ROM_RAW%%"^</command^> >> "%USERPROFILE%\.emulationstation\es_systems.cfg"
echo 	^<platform^>wii^</platform^> >> "%USERPROFILE%\.emulationstation\es_systems.cfg"
echo 	^<theme^>wii^</theme^> >> "%USERPROFILE%\.emulationstation\es_systems.cfg"
echo    ^</system^>  >> "%USERPROFILE%\.emulationstation\es_systems.cfg"

echo   ^<system^> >> "%USERPROFILE%\.emulationstation\es_systems.cfg"
echo     ^<name^>gameandwatch^</name^> >> "%USERPROFILE%\.emulationstation\es_systems.cfg"
echo     ^<fullname^>Game & Watch^</fullname^> >> "%USERPROFILE%\.emulationstation\es_systems.cfg"
echo     ^<path^>%cusromdir%\gameandwatch^</path^> >> "%USERPROFILE%\.emulationstation\es_systems.cfg"
echo     ^<extension^>.mgw .MGW^</extension^> >> "%USERPROFILE%\.emulationstation\es_systems.cfg"
echo     ^<command^>C:\RetroCake\RetroArch\retroarch.exe -L C:\RetroCake\RetroArch\cores\gw_libretro.dll "%%ROM_RAW%%"^</command^> >> "%USERPROFILE%\.emulationstation\es_systems.cfg"
echo     ^<platform^>gameandwatch^</platform^> >> "%USERPROFILE%\.emulationstation\es_systems.cfg"
echo     ^<theme^>gameandwatch^</theme^> >> "%USERPROFILE%\.emulationstation\es_systems.cfg"
echo   ^</system^> >> "%USERPROFILE%\.emulationstation\es_systems.cfg"

echo   ^<system^> >> "%USERPROFILE%\.emulationstation\es_systems.cfg"
echo     ^<name^>gb^</name^> >> "%USERPROFILE%\.emulationstation\es_systems.cfg"
echo     ^<fullname^>Game Boy^</fullname^> >> "%USERPROFILE%\.emulationstation\es_systems.cfg"
echo     ^<path^>%cusromdir%\gb^</path^> >> "%USERPROFILE%\.emulationstation\es_systems.cfg"
echo     ^<extension^>.7z .gb .zip .7Z .GB .ZIP^</extension^> >> "%USERPROFILE%\.emulationstation\es_systems.cfg"
echo     ^<command^>C:\RetroCake\RetroArch\retroarch.exe -L C:\RetroCake\RetroArch\cores\gambatte_libretro.dll "%%ROM_RAW%%"^</command^> >> "%USERPROFILE%\.emulationstation\es_systems.cfg"
echo     ^<platform^>gb^</platform^> >> "%USERPROFILE%\.emulationstation\es_systems.cfg"
echo     ^<theme^>gb^</theme^> >> "%USERPROFILE%\.emulationstation\es_systems.cfg"
echo   ^</system^> >> "%USERPROFILE%\.emulationstation\es_systems.cfg"

echo   ^<system^> >> "%USERPROFILE%\.emulationstation\es_systems.cfg"
echo     ^<name^>virtualboy^</name^> >> "%USERPROFILE%\.emulationstation\es_systems.cfg"
echo     ^<fullname^>Virtualboy^</fullname^> >> "%USERPROFILE%\.emulationstation\es_systems.cfg"
echo     ^<path^>%cusromdir%\virtualboy^</path^> >> "%USERPROFILE%\.emulationstation\es_systems.cfg"
echo     ^<extension^>.7z .vb .zip .7Z .VB .ZIP^</extension^> >> "%USERPROFILE%\.emulationstation\es_systems.cfg"
echo     ^<command^>C:\RetroCake\RetroArch\retroarch.exe -L C:\RetroCake\RetroArch\cores\vecx_libretro.dll "%%ROM_RAW%%"^</command^> >> "%USERPROFILE%\.emulationstation\es_systems.cfg"
echo     ^<platform^>virtualboy^</platform^> >> "%USERPROFILE%\.emulationstation\es_systems.cfg"
echo     ^<theme^>virtualboy^</theme^> >> "%USERPROFILE%\.emulationstation\es_systems.cfg"
echo   ^</system^> >> "%USERPROFILE%\.emulationstation\es_systems.cfg"

echo   ^<system^> >> "%USERPROFILE%\.emulationstation\es_systems.cfg"
echo     ^<name^>gbc^</name^> >> "%USERPROFILE%\.emulationstation\es_systems.cfg"
echo     ^<fullname^>Game Boy Color^</fullname^> >> "%USERPROFILE%\.emulationstation\es_systems.cfg"
echo     ^<path^>%cusromdir%\gbc^</path^> >> "%USERPROFILE%\.emulationstation\es_systems.cfg"
echo     ^<extension^>.7z .gbc .zip .7Z .GBC .ZIP^</extension^> >> "%USERPROFILE%\.emulationstation\es_systems.cfg"
echo     ^<command^>C:\RetroCake\RetroArch\retroarch.exe -L C:\RetroCake\RetroArch\cores\gambatte_libretro.dll "%%ROM_RAW%%"^</command^> >> "%USERPROFILE%\.emulationstation\es_systems.cfg"
echo     ^<platform^>gbc^</platform^> >> "%USERPROFILE%\.emulationstation\es_systems.cfg"
echo     ^<theme^>gbc^</theme^> >> "%USERPROFILE%\.emulationstation\es_systems.cfg"
echo   ^</system^> >> "%USERPROFILE%\.emulationstation\es_systems.cfg"

echo   ^<system^> >> "%USERPROFILE%\.emulationstation\es_systems.cfg"
echo     ^<name^>gba^</name^> >> "%USERPROFILE%\.emulationstation\es_systems.cfg"
echo     ^<fullname^>Game Boy Advance^</fullname^> >> "%USERPROFILE%\.emulationstation\es_systems.cfg"
echo     ^<path^>%cusromdir%\gba^</path^> >> "%USERPROFILE%\.emulationstation\es_systems.cfg"
echo     ^<extension^>.7z .gba .zip .7Z .GBA .ZIP^</extension^> >> "%USERPROFILE%\.emulationstation\es_systems.cfg"
echo     ^<command^>C:\RetroCake\RetroArch\retroarch.exe -L C:\RetroCake\RetroArch\cores\gpsp_libretro.dll "%%ROM_RAW%%"^</command^> >> "%USERPROFILE%\.emulationstation\es_systems.cfg"
echo     ^<platform^>gba^</platform^> >> "%USERPROFILE%\.emulationstation\es_systems.cfg"
echo     ^<theme^>gba^</theme^> >> "%USERPROFILE%\.emulationstation\es_systems.cfg"
echo   ^</system^> >> "%USERPROFILE%\.emulationstation\es_systems.cfg"

echo   ^<system^> >> "%USERPROFILE%\.emulationstation\es_systems.cfg"
echo     ^<name^>nds^</name^> >> "%USERPROFILE%\.emulationstation\es_systems.cfg"
echo     ^<fullname^>Nintendo DS^</fullname^> >> "%USERPROFILE%\.emulationstation\es_systems.cfg"
echo     ^<path^>%cusromdir%\nds^</path^> >> "%USERPROFILE%\.emulationstation\es_systems.cfg"
echo     ^<extension^>.zip .ZIP .nds .NDS^</extension^> >> "%USERPROFILE%\.emulationstation\es_systems.cfg"
echo     ^<command^>C:\RetroCake\RetroArch\retroarch.exe -L C:\RetroCake\RetroArch\cores\melonds_libretro.dll "%%ROM_RAW%%"^</command^> >> "%USERPROFILE%\.emulationstation\es_systems.cfg"
echo     ^<platform^>nds^</platform^> >> "%USERPROFILE%\.emulationstation\es_systems.cfg"
echo     ^<theme^>nds^</theme^> >> "%USERPROFILE%\.emulationstation\es_systems.cfg"
echo   ^</system^> >> "%USERPROFILE%\.emulationstation\es_systems.cfg"

echo   ^<system^> >> "%USERPROFILE%\.emulationstation\es_systems.cfg"
echo     ^<name^>sg-1000^</name^> >> "%USERPROFILE%\.emulationstation\es_systems.cfg"
echo     ^<fullname^>Sega SG-1000^</fullname^> >> "%USERPROFILE%\.emulationstation\es_systems.cfg"
echo     ^<path^>%cusromdir%\sg-1000^</path^> >> "%USERPROFILE%\.emulationstation\es_systems.cfg"
echo     ^<extension^>.sg .bin .zip .SG .BIN .ZIP^</extension^> >> "%USERPROFILE%\.emulationstation\es_systems.cfg"
echo     ^<command^>C:\RetroCake\RetroArch\retroarch.exe -L C:\RetroCake\RetroArch\cores\genesis_plus_gx_libretro.dll "%%ROM_RAW%%"^</command^> >> "%USERPROFILE%\.emulationstation\es_systems.cfg"
echo     ^<platform^>sg-1000^</platform^> >> "%USERPROFILE%\.emulationstation\es_systems.cfg"
echo     ^<theme^>sg-1000^</theme^> >> "%USERPROFILE%\.emulationstation\es_systems.cfg"
echo   ^</system^> >> "%USERPROFILE%\.emulationstation\es_systems.cfg"

echo   ^<system^> >> "%USERPROFILE%\.emulationstation\es_systems.cfg"
echo     ^<name^>mastersystem^</name^> >> "%USERPROFILE%\.emulationstation\es_systems.cfg"
echo     ^<fullname^>Sega Master System^</fullname^> >> "%USERPROFILE%\.emulationstation\es_systems.cfg"
echo     ^<path^>%cusromdir%\mastersystem^</path^> >> "%USERPROFILE%\.emulationstation\es_systems.cfg"
echo     ^<extension^>.7z .sms .bin .zip .7Z .SMS .BIN .ZIP^</extension^> >> "%USERPROFILE%\.emulationstation\es_systems.cfg"
echo     ^<command^>C:\RetroCake\RetroArch\retroarch.exe -L C:\RetroCake\RetroArch\cores\genesis_plus_gx_libretro.dll "%%ROM_RAW%%"^</command^> >> "%USERPROFILE%\.emulationstation\es_systems.cfg"
echo     ^<platform^>mastersystem^</platform^> >> "%USERPROFILE%\.emulationstation\es_systems.cfg"
echo     ^<theme^>mastersystem^</theme^> >> "%USERPROFILE%\.emulationstation\es_systems.cfg"
echo   ^</system^> >> "%USERPROFILE%\.emulationstation\es_systems.cfg"

echo   ^<system^> >> "%USERPROFILE%\.emulationstation\es_systems.cfg"
echo     ^<name^>megadrive^</name^> >> "%USERPROFILE%\.emulationstation\es_systems.cfg"
echo     ^<fullname^>Sega Mega Drive^</fullname^> >> "%USERPROFILE%\.emulationstation\es_systems.cfg"
echo     ^<path^>%cusromdir%\megadrive^</path^> >> "%USERPROFILE%\.emulationstation\es_systems.cfg"
echo     ^<extension^>.7z .smd .bin .gen .md .sg .zip .7Z .SMD .BIN .GEN .MD .SG .ZIP^</extension^> >> "%USERPROFILE%\.emulationstation\es_systems.cfg"
echo     ^<command^>C:\RetroCake\RetroArch\retroarch.exe -L C:\RetroCake\RetroArch\cores\genesis_plus_gx_libretro.dll "%%ROM_RAW%%"^</command^> >> "%USERPROFILE%\.emulationstation\es_systems.cfg"
echo     ^<platform^>megadrive^</platform^> >> "%USERPROFILE%\.emulationstation\es_systems.cfg"
echo     ^<theme^>megadrive^</theme^> >> "%USERPROFILE%\.emulationstation\es_systems.cfg"
echo   ^</system^> >> "%USERPROFILE%\.emulationstation\es_systems.cfg"

echo   ^<system^> >> "%USERPROFILE%\.emulationstation\es_systems.cfg"
echo     ^<name^>segacd^</name^> >> "%USERPROFILE%\.emulationstation\es_systems.cfg"
echo     ^<fullname^>Mega CD^</fullname^> >> "%USERPROFILE%\.emulationstation\es_systems.cfg"
echo     ^<path^>%cusromdir%\segacd^</path^> >> "%USERPROFILE%\.emulationstation\es_systems.cfg"
echo     ^<extension^>.iso .cue .ISO .CUE^</extension^> >> "%USERPROFILE%\.emulationstation\es_systems.cfg"
echo     ^<command^>C:\RetroCake\RetroArch\retroarch.exe -L C:\RetroCake\RetroArch\cores\genesis_plus_gx_libretro.dll "%%ROM_RAW%%"^</command^> >> "%USERPROFILE%\.emulationstation\es_systems.cfg"
echo     ^<platform^>segacd^</platform^> >> "%USERPROFILE%\.emulationstation\es_systems.cfg"
echo     ^<theme^>segacd^</theme^> >> "%USERPROFILE%\.emulationstation\es_systems.cfg"
echo   ^</system^> >> "%USERPROFILE%\.emulationstation\es_systems.cfg"

echo   ^<system^> >> "%USERPROFILE%\.emulationstation\es_systems.cfg"
echo     ^<name^>sega32x^</name^> >> "%USERPROFILE%\.emulationstation\es_systems.cfg"
echo     ^<fullname^>Sega 32X^</fullname^> >> "%USERPROFILE%\.emulationstation\es_systems.cfg"
echo     ^<path^>%cusromdir%\sega32x^</path^> >> "%USERPROFILE%\.emulationstation\es_systems.cfg"
echo     ^<extension^>.7z .32x .smd .bin .md .zip .7Z .32X .SMD .BIN .MD .ZIP^</extension^> >> "%USERPROFILE%\.emulationstation\es_systems.cfg"
echo     ^<command^>C:\RetroCake\RetroArch\retroarch.exe -L C:\RetroCake\RetroArch\cores\picodrive_libretro.dll "%%ROM_RAW%%"^</command^> >> "%USERPROFILE%\.emulationstation\es_systems.cfg"
echo     ^<platform^>sega32x^</platform^> >> "%USERPROFILE%\.emulationstation\es_systems.cfg"
echo     ^<theme^>sega32x^</theme^> >> "%USERPROFILE%\.emulationstation\es_systems.cfg"
echo   ^</system^> >> "%USERPROFILE%\.emulationstation\es_systems.cfg"

echo   ^<system^> >> "%USERPROFILE%\.emulationstation\es_systems.cfg"
echo     ^<name^>saturn^</name^> >> "%USERPROFILE%\.emulationstation\es_systems.cfg"
echo     ^<fullname^>Sega Saturn^</fullname^> >> "%USERPROFILE%\.emulationstation\es_systems.cfg"
echo     ^<path^>%cusromdir%\saturn^</path^> >> "%USERPROFILE%\.emulationstation\es_systems.cfg"
echo     ^<extension^>.cue .CUE^</extension^> >> "%USERPROFILE%\.emulationstation\es_systems.cfg"
echo     ^<command^>C:\RetroCake\RetroArch\retroarch.exe -L C:\RetroCake\RetroArch\cores\mednafen_saturn_libretro.dll "%ROM_RAW%"^</command^> >> "%USERPROFILE%\.emulationstation\es_systems.cfg"
echo     ^<platform^>saturn^</platform^> >> "%USERPROFILE%\.emulationstation\es_systems.cfg"
echo     ^<theme^>saturn^</theme^> >> "%USERPROFILE%\.emulationstation\es_systems.cfg"
echo   ^</system^> >> "%USERPROFILE%\.emulationstation\es_systems.cfg"

echo   ^<system^> >> "%USERPROFILE%\.emulationstation\es_systems.cfg"
echo     ^<name^>dreamcast^</name^> >> "%USERPROFILE%\.emulationstation\es_systems.cfg"
echo     ^<fullname^>Sega Dreamcast^</fullname^> >> "%USERPROFILE%\.emulationstation\es_systems.cfg"
echo     ^<path^>%cusromdir%\dreamcast^</path^> >> "%USERPROFILE%\.emulationstation\es_systems.cfg"
echo     ^<extension^>.gdi .cdi .GDI .CDI^</extension^> >> "%USERPROFILE%\.emulationstation\es_systems.cfg"
echo     ^<command^>C:\RetroCake\RetroArch\retroarch.exe -L C:\RetroCake\RetroArch\cores\reicast_libretro.dll "%%ROM_RAW%%"^</command^> >> "%USERPROFILE%\.emulationstation\es_systems.cfg"
echo     ^<platform^>dreamcast^</platform^> >> "%USERPROFILE%\.emulationstation\es_systems.cfg"
echo     ^<theme^>dreamcast^</theme^> >> "%USERPROFILE%\.emulationstation\es_systems.cfg"
echo   ^</system^> >> "%USERPROFILE%\.emulationstation\es_systems.cfg"

echo   ^<system^> >> "%USERPROFILE%\.emulationstation\es_systems.cfg"
echo     ^<name^>gamegear^</name^> >> "%USERPROFILE%\.emulationstation\es_systems.cfg"
echo     ^<fullname^>Sega Gamegear^</fullname^> >> "%USERPROFILE%\.emulationstation\es_systems.cfg"
echo     ^<path^>%cusromdir%\gamegear^</path^> >> "%USERPROFILE%\.emulationstation\es_systems.cfg"
echo     ^<extension^>.7z .gg .bin .sms .zip .7Z .GG .BIN .SMS .ZIP^</extension^> >> "%USERPROFILE%\.emulationstation\es_systems.cfg"
echo     ^<command^>C:\RetroCake\RetroArch\retroarch.exe -L C:\RetroCake\RetroArch\cores\genesis_plus_gx_libretro.dll "%%ROM_RAW%%"^</command^> >> "%USERPROFILE%\.emulationstation\es_systems.cfg"
echo     ^<platform^>gamegear^</platform^> >> "%USERPROFILE%\.emulationstation\es_systems.cfg"
echo     ^<theme^>gamegear^</theme^> >> "%USERPROFILE%\.emulationstation\es_systems.cfg"
echo   ^</system^> >> "%USERPROFILE%\.emulationstation\es_systems.cfg"

echo   ^<system^> >> "%USERPROFILE%\.emulationstation\es_systems.cfg"
echo     ^<name^>psx^</name^> >> "%USERPROFILE%\.emulationstation\es_systems.cfg"
echo     ^<fullname^>PlayStation^</fullname^> >> "%USERPROFILE%\.emulationstation\es_systems.cfg"
echo     ^<path^>%cusromdir%\psx^</path^> >> "%USERPROFILE%\.emulationstation\es_systems.cfg"
echo     ^<extension^>.cue .cbn .img .iso .m3u .mdf .pbp .toc .z .znx .CUE .CBN .IMG .ISO .M3U .MDF .PBP .TOC .Z .ZNX^</extension^> >> "%USERPROFILE%\.emulationstation\es_systems.cfg"
echo     ^<command^>C:\RetroCake\RetroArch\retroarch.exe -L C:\RetroCake\RetroArch\cores\pcsx_rearmed_libretro.dll "%%ROM_RAW%%"^</command^> >> "%USERPROFILE%\.emulationstation\es_systems.cfg"
echo     ^<platform^>psx^</platform^> >> "%USERPROFILE%\.emulationstation\es_systems.cfg"
echo     ^<theme^>psx^</theme^> >> "%USERPROFILE%\.emulationstation\es_systems.cfg"
echo   ^</system^> >> "%USERPROFILE%\.emulationstation\es_systems.cfg"

echo   ^<system^> >> "%USERPROFILE%\.emulationstation\es_systems.cfg"
echo     ^<name^>ps2^</name^> >> "%USERPROFILE%\.emulationstation\es_systems.cfg"
echo     ^<fullname^>PlayStation 2^</fullname^> >> "%USERPROFILE%\.emulationstation\es_systems.cfg"
echo     ^<path^>%cusromdir%\ps2^</path^> >> "%USERPROFILE%\.emulationstation\es_systems.cfg"
echo     ^<extension^>.cue .cbn .img .iso .m3u .mdf .pbp .toc .z .znx .CUE .CBN .IMG .ISO .M3U .MDF .PBP .TOC .Z .ZNX^</extension^> >> "%USERPROFILE%\.emulationstation\es_systems.cfg"
echo     ^<command^>C:\RetroCake\Emulators\PCSX2\pcsx2.exe "%%ROM_RAW%%" --fullscreen^</command^> >> "%USERPROFILE%\.emulationstation\es_systems.cfg"
echo     ^<platform^>ps2^</platform^> >> "%USERPROFILE%\.emulationstation\es_systems.cfg"
echo     ^<theme^>ps2^</theme^> >> "%USERPROFILE%\.emulationstation\es_systems.cfg"
echo   ^</system^> >> "%USERPROFILE%\.emulationstation\es_systems.cfg"

echo   ^<system^> >> "%USERPROFILE%\.emulationstation\es_systems.cfg"
echo     ^<name^>psp^</name^> >> "%USERPROFILE%\.emulationstation\es_systems.cfg"
echo     ^<fullname^>PlayStation Portable^</fullname^> >> "%USERPROFILE%\.emulationstation\es_systems.cfg"
echo     ^<path^>%cusromdir%\psp^</path^> >> "%USERPROFILE%\.emulationstation\es_systems.cfg"
echo     ^<extension^>.cso .iso .pbp .CSO .ISO .PBP^</extension^> >> "%USERPROFILE%\.emulationstation\es_systems.cfg"
echo     ^<command^>C:\RetroCake\RetroArch\retroarch.exe -L C:\RetroCake\RetroArch\cores\ppsspp_libretro.dll "%%ROM_RAW%%"^</command^> >> "%USERPROFILE%\.emulationstation\es_systems.cfg"
echo     ^<platform^>psp^</platform^> >> "%USERPROFILE%\.emulationstation\es_systems.cfg"
echo     ^<theme^>psp^</theme^> >> "%USERPROFILE%\.emulationstation\es_systems.cfg"
echo   ^</system^> >> "%USERPROFILE%\.emulationstation\es_systems.cfg"

echo   ^<system^> >> "%USERPROFILE%\.emulationstation\es_systems.cfg"
echo     ^<name^>atari2600^</name^> >> "%USERPROFILE%\.emulationstation\es_systems.cfg"
echo     ^<fullname^>Atari 2600^</fullname^> >> "%USERPROFILE%\.emulationstation\es_systems.cfg"
echo     ^<path^>%cusromdir%\atari2600^</path^> >> "%USERPROFILE%\.emulationstation\es_systems.cfg"
echo     ^<extension^>.7z .a26 .bin .rom .zip .gz .7Z .A26 .BIN .ROM .ZIP .GZ^</extension^> >> "%USERPROFILE%\.emulationstation\es_systems.cfg"
echo     ^<command^>C:\RetroCake\RetroArch\retroarch.exe -L C:\RetroCake\RetroArch\cores\stella_libretro.dll "%%ROM_RAW%%"^</command^> >> "%USERPROFILE%\.emulationstation\es_systems.cfg"
echo     ^<platform^>atari2600^</platform^> >> "%USERPROFILE%\.emulationstation\es_systems.cfg"
echo     ^<theme^>atari2600^</theme^> >> "%USERPROFILE%\.emulationstation\es_systems.cfg"
echo   ^</system^> >> "%USERPROFILE%\.emulationstation\es_systems.cfg"

echo   ^<system^> >> "%USERPROFILE%\.emulationstation\es_systems.cfg"
echo     ^<name^>atari800^</name^> >> "%USERPROFILE%\.emulationstation\es_systems.cfg"
echo     ^<fullname^>Atari 800^</fullname^> >> "%USERPROFILE%\.emulationstation\es_systems.cfg"
echo     ^<path^>%cusromdir%\atari800^</path^> >> "%USERPROFILE%\.emulationstation\es_systems.cfg"
echo     ^<extension^>.bas .bin .car .com .xex .atr .xfd .dcm .atr.gz .xfd.gz .BAS .BIN .CAR .COM .XEX .ATR .XFD .DCM .ATR.GZ .XFD.GZ^</extension^> >> "%USERPROFILE%\.emulationstation\es_systems.cfg"
echo     ^<command^>C:\RetroCake\RetroArch\retroarch.exe -L C:\RetroCake\RetroArch\cores\atari800_libretro.dll "%%ROM_RAW%%"^</command^> >> "%USERPROFILE%\.emulationstation\es_systems.cfg"
echo     ^<platform^>atari800^</platform^> >> "%USERPROFILE%\.emulationstation\es_systems.cfg"
echo     ^<theme^>atari800^</theme^> >> "%USERPROFILE%\.emulationstation\es_systems.cfg"
echo   ^</system^> >> "%USERPROFILE%\.emulationstation\es_systems.cfg"

echo   ^<system^> >> "%USERPROFILE%\.emulationstation\es_systems.cfg"
echo     ^<name^>atari5200^</name^> >> "%USERPROFILE%\.emulationstation\es_systems.cfg"
echo     ^<fullname^>Atari 5200^</fullname^> >> "%USERPROFILE%\.emulationstation\es_systems.cfg"
echo     ^<path^>%cusromdir%\atari5200^</path^> >> "%USERPROFILE%\.emulationstation\es_systems.cfg"
echo     ^<extension^>.a52 .bin .car .A52 .BIN .CAR^</extension^> >> "%USERPROFILE%\.emulationstation\es_systems.cfg"
echo     ^<command^>C:\RetroCake\RetroArch\retroarch.exe -L C:\RetroCake\RetroArch\cores\atari800_libretro.dll "%%ROM_RAW%%"^</command^> >> "%USERPROFILE%\.emulationstation\es_systems.cfg"
echo     ^<platform^>atari5200^</platform^> >> "%USERPROFILE%\.emulationstation\es_systems.cfg"
echo     ^<theme^>atari5200^</theme^> >> "%USERPROFILE%\.emulationstation\es_systems.cfg"
echo   ^</system^> >> "%USERPROFILE%\.emulationstation\es_systems.cfg"

echo   ^<system^> >> "%USERPROFILE%\.emulationstation\es_systems.cfg"
echo     ^<name^>atari7800^</name^> >> "%USERPROFILE%\.emulationstation\es_systems.cfg"
echo     ^<fullname^>Atari 7800 ProSystem^</fullname^> >> "%USERPROFILE%\.emulationstation\es_systems.cfg"
echo     ^<path^>%cusromdir%\atari7800^</path^> >> "%USERPROFILE%\.emulationstation\es_systems.cfg"
echo     ^<extension^>.7z .a78 .bin .zip .7Z .A78 .BIN .ZIP^</extension^> >> "%USERPROFILE%\.emulationstation\es_systems.cfg"
echo     ^<command^>C:\RetroCake\RetroArch\retroarch.exe -L C:\RetroCake\RetroArch\cores\prosystem_libretro.dll "%%ROM_RAW%%"^</command^> >> "%USERPROFILE%\.emulationstation\es_systems.cfg"
echo     ^<platform^>atari7800^</platform^> >> "%USERPROFILE%\.emulationstation\es_systems.cfg"
echo     ^<theme^>atari7800^</theme^> >> "%USERPROFILE%\.emulationstation\es_systems.cfg"
echo   ^</system^> >> "%USERPROFILE%\.emulationstation\es_systems.cfg"

echo   ^<system^> >> "%USERPROFILE%\.emulationstation\es_systems.cfg"
echo     ^<name^>atarijaguar^</name^> >> "%USERPROFILE%\.emulationstation\es_systems.cfg"
echo     ^<fullname^>Atari Jaguar^</fullname^> >> "%USERPROFILE%\.emulationstation\es_systems.cfg"
echo     ^<path^>%cusromdir%\atarijaguar^</path^> >> "%USERPROFILE%\.emulationstation\es_systems.cfg"
echo     ^<extension^>.j64 .jag .zip .J64 .JAG .ZIP^</extension^> >> "%USERPROFILE%\.emulationstation\es_systems.cfg"
echo     ^<command^>C:\RetroCake\RetroArch\retroarch.exe -L C:\RetroCake\RetroArch\cores\virtualjaguar_libretro.dll "%%ROM_RAW%%"^</command^> >> "%USERPROFILE%\.emulationstation\es_systems.cfg"
echo     ^<platform^>atarijaguar^</platform^> >> "%USERPROFILE%\.emulationstation\es_systems.cfg"
echo     ^<theme^>atarijaguar^</theme^> >> "%USERPROFILE%\.emulationstation\es_systems.cfg"
echo   ^</system^> >> "%USERPROFILE%\.emulationstation\es_systems.cfg"

echo   ^<system^> >> "%USERPROFILE%\.emulationstation\es_systems.cfg"
echo     ^<name^>atarilynx^</name^> >> "%USERPROFILE%\.emulationstation\es_systems.cfg"
echo     ^<fullname^>Atari Lynx^</fullname^> >> "%USERPROFILE%\.emulationstation\es_systems.cfg"
echo     ^<path^>%cusromdir%\atarilynx^</path^> >> "%USERPROFILE%\.emulationstation\es_systems.cfg"
echo     ^<extension^>.7z .lnx .zip .7Z .LNX .ZIP^</extension^> >> "%USERPROFILE%\.emulationstation\es_systems.cfg"
echo     ^<command^>C:\RetroCake\RetroArch\retroarch.exe -L C:\RetroCake\RetroArch\cores\handy_libretro.dll "%%ROM_RAW%%"^</command^> >> "%USERPROFILE%\.emulationstation\es_systems.cfg"
echo     ^<platform^>atarilynx^</platform^> >> "%USERPROFILE%\.emulationstation\es_systems.cfg"
echo     ^<theme^>atarilynx^</theme^> >> "%USERPROFILE%\.emulationstation\es_systems.cfg"
echo   ^</system^> >> "%USERPROFILE%\.emulationstation\es_systems.cfg"

echo   ^<system^> >> "%USERPROFILE%\.emulationstation\es_systems.cfg"
echo     ^<name^>atarist^</name^> >> "%USERPROFILE%\.emulationstation\es_systems.cfg"
echo     ^<fullname^>Atari ST^</fullname^> >> "%USERPROFILE%\.emulationstation\es_systems.cfg"
echo     ^<path^>%cusromdir%\atarist^</path^> >> "%USERPROFILE%\.emulationstation\es_systems.cfg"
echo     ^<extension^>.st .stx .img .rom .raw .ipf .ctr .ST .STX .IMG .ROM .RAW .IPF .CTR^</extension^> >> "%USERPROFILE%\.emulationstation\es_systems.cfg"
echo     ^<command^>C:\RetroCake\Emulators\Hatari\Hatari.exe "%%ROM_RAW%%"^</command^> >> "%USERPROFILE%\.emulationstation\es_systems.cfg"
echo     ^<platform^>atarist^</platform^> >> "%USERPROFILE%\.emulationstation\es_systems.cfg"
echo     ^<theme^>atarist^</theme^> >> "%USERPROFILE%\.emulationstation\es_systems.cfg"
echo   ^</system^> >> "%USERPROFILE%\.emulationstation\es_systems.cfg"

echo   ^<system^> >> "%USERPROFILE%\.emulationstation\es_systems.cfg"
echo     ^<name^>neogeo^</name^> >> "%USERPROFILE%\.emulationstation\es_systems.cfg"
echo     ^<fullname^>Neo Geo^</fullname^> >> "%USERPROFILE%\.emulationstation\es_systems.cfg"
echo     ^<path^>%cusromdir%\neogeo^</path^> >> "%USERPROFILE%\.emulationstation\es_systems.cfg"
echo     ^<extension^>.fba .zip .FBA .ZIP^</extension^> >> "%USERPROFILE%\.emulationstation\es_systems.cfg"
echo     ^<command^>C:\RetroCake\RetroArch\retroarch.exe -L C:\RetroCake\RetroArch\cores\fbalpha_libretro.dll "%%ROM_RAW%%"^</command^> >> "%USERPROFILE%\.emulationstation\es_systems.cfg"
echo     ^<platform^>neogeo^</platform^> >> "%USERPROFILE%\.emulationstation\es_systems.cfg"
echo     ^<theme^>neogeo^</theme^> >> "%USERPROFILE%\.emulationstation\es_systems.cfg"
echo   ^</system^> >> "%USERPROFILE%\.emulationstation\es_systems.cfg"

echo   ^<system^> >> "%USERPROFILE%\.emulationstation\es_systems.cfg"
echo     ^<name^>fba^</name^> >> "%USERPROFILE%\.emulationstation\es_systems.cfg"
echo     ^<fullname^>Final Burn Alpha^</fullname^> >> "%USERPROFILE%\.emulationstation\es_systems.cfg"
echo     ^<path^>%cusromdir%\fba^</path^> >> "%USERPROFILE%\.emulationstation\es_systems.cfg"
echo     ^<extension^>.fba .zip .FBA .ZIP^</extension^> >> "%USERPROFILE%\.emulationstation\es_systems.cfg"
echo     ^<command^>C:\RetroCake\RetroArch\retroarch.exe -L C:\RetroCake\RetroArch\cores\fbalpha_libretro.dll "%%ROM_RAW%%"^</command^> >> "%USERPROFILE%\.emulationstation\es_systems.cfg"
echo     ^<platform^>arcade^</platform^> >> "%USERPROFILE%\.emulationstation\es_systems.cfg"
echo     ^<theme^>fba^</theme^> >> "%USERPROFILE%\.emulationstation\es_systems.cfg"
echo   ^</system^> >> "%USERPROFILE%\.emulationstation\es_systems.cfg"

echo   ^<system^> >> "%USERPROFILE%\.emulationstation\es_systems.cfg"
echo     ^<name^>ngp^</name^> >> "%USERPROFILE%\.emulationstation\es_systems.cfg"
echo     ^<fullname^>Neo Geo Pocket^</fullname^> >> "%USERPROFILE%\.emulationstation\es_systems.cfg"
echo     ^<path^>%cusromdir%\ngp^</path^> >> "%USERPROFILE%\.emulationstation\es_systems.cfg"
echo     ^<extension^>.ngp .zip .NGP .ZIP^</extension^> >> "%USERPROFILE%\.emulationstation\es_systems.cfg"
echo     ^<command^>C:\RetroCake\RetroArch\retroarch.exe -L C:\RetroCake\RetroArch\cores\mednafen_ngp_libretro.dll "%%ROM_RAW%%"^</command^> >> "%USERPROFILE%\.emulationstation\es_systems.cfg"
echo     ^<platform^>ngp^</platform^> >> "%USERPROFILE%\.emulationstation\es_systems.cfg"
echo     ^<theme^>ngp^</theme^> >> "%USERPROFILE%\.emulationstation\es_systems.cfg"
echo   ^</system^> >> "%USERPROFILE%\.emulationstation\es_systems.cfg"

echo   ^<system^> >> "%USERPROFILE%\.emulationstation\es_systems.cfg"
echo     ^<name^>ngpc^</name^> >> "%USERPROFILE%\.emulationstation\es_systems.cfg"
echo     ^<fullname^>Neo Geo Pocket Color^</fullname^> >> "%USERPROFILE%\.emulationstation\es_systems.cfg"
echo     ^<path^>%cusromdir%\ngpc^</path^> >> "%USERPROFILE%\.emulationstation\es_systems.cfg"
echo     ^<extension^>.ngc .zip .NGC .ZIP^</extension^> >> "%USERPROFILE%\.emulationstation\es_systems.cfg"
echo     ^<command^>C:\RetroCake\RetroArch\retroarch.exe -L C:\RetroCake\RetroArch\cores\mednafen_ngp_libretro.dll "%%ROM_RAW%%"^</command^> >> "%USERPROFILE%\.emulationstation\es_systems.cfg"
echo     ^<platform^>ngpc^</platform^> >> "%USERPROFILE%\.emulationstation\es_systems.cfg"
echo     ^<theme^>ngpc^</theme^> >> "%USERPROFILE%\.emulationstation\es_systems.cfg"
echo   ^</system^> >> "%USERPROFILE%\.emulationstation\es_systems.cfg"

echo   ^<system^> >> "%USERPROFILE%\.emulationstation\es_systems.cfg"
echo     ^<name^>mame-libretro^</name^> >> "%USERPROFILE%\.emulationstation\es_systems.cfg"
echo     ^<fullname^>Multiple Arcade Machine Emulator^</fullname^> >> "%USERPROFILE%\.emulationstation\es_systems.cfg"
echo     ^<path^>%cusromdir%\mame^</path^> >> "%USERPROFILE%\.emulationstation\es_systems.cfg"
echo     ^<extension^>.zip .ZIP^</extension^> >> "%USERPROFILE%\.emulationstation\es_systems.cfg"
echo     ^<command^>C:\RetroCake\RetroArch\retroarch.exe -L C:\RetroCake\RetroArch\cores\mame2003_libretro.dll "%%ROM_RAW%%"^</command^> >> "%USERPROFILE%\.emulationstation\es_systems.cfg"
echo     ^<platform^>arcade^</platform^> >> "%USERPROFILE%\.emulationstation\es_systems.cfg"
echo     ^<theme^>mame^</theme^> >> "%USERPROFILE%\.emulationstation\es_systems.cfg"
echo   ^</system^> >> "%USERPROFILE%\.emulationstation\es_systems.cfg"

echo   ^<system^> >> "%USERPROFILE%\.emulationstation\es_systems.cfg"
echo     ^<name^>3do^</name^> >> "%USERPROFILE%\.emulationstation\es_systems.cfg"
echo     ^<fullname^>3DO^</fullname^> >> "%USERPROFILE%\.emulationstation\es_systems.cfg"
echo     ^<path^>%cusromdir%\3do^</path^> >> "%USERPROFILE%\.emulationstation\es_systems.cfg"
echo     ^<extension^>.iso .ISO^</extension^> >> "%USERPROFILE%\.emulationstation\es_systems.cfg"
echo     ^<command^>C:\RetroCake\RetroArch\retroarch.exe -L C:\RetroCake\RetroArch\cores\4do_libretro.dll "%%ROM_RAW%%"^</command^> >> "%USERPROFILE%\.emulationstation\es_systems.cfg"
echo     ^<platform^>3do^</platform^> >> "%USERPROFILE%\.emulationstation\es_systems.cfg"
echo     ^<theme^>3do^</theme^> >> "%USERPROFILE%\.emulationstation\es_systems.cfg"
echo   ^</system^> >> "%USERPROFILE%\.emulationstation\es_systems.cfg"

echo   ^<system^> >> "%USERPROFILE%\.emulationstation\es_systems.cfg"
echo     ^<name^>ags^</name^> >> "%USERPROFILE%\.emulationstation\es_systems.cfg"
echo     ^<fullname^>Adventure Game Studio^</fullname^> >> "%USERPROFILE%\.emulationstation\es_systems.cfg"
echo     ^<path^>%cusromdir%\ags^</path^> >> "%USERPROFILE%\.emulationstation\es_systems.cfg"
echo     ^<extension^>.exe .EXE^</extension^> >> "%USERPROFILE%\.emulationstation\es_systems.cfg"
echo     ^<command^>C:\RetroCake\RetroArch\retroarch.exe -L C:\RetroCake\RetroArch\cores\ags_libretro.dll "%%ROM_RAW%%"^</command^> >> "%USERPROFILE%\.emulationstation\es_systems.cfg"
echo     ^<platform^>ags^</platform^> >> "%USERPROFILE%\.emulationstation\es_systems.cfg"
echo     ^<theme^>ags^</theme^> >> "%USERPROFILE%\.emulationstation\es_systems.cfg"
echo   ^</system^> >> "%USERPROFILE%\.emulationstation\es_systems.cfg"

echo   ^<system^> >> "%USERPROFILE%\.emulationstation\es_systems.cfg"
echo     ^<name^>amiga^</name^> >> "%USERPROFILE%\.emulationstation\es_systems.cfg"
echo     ^<fullname^>Amiga^</fullname^> >> "%USERPROFILE%\.emulationstation\es_systems.cfg"
echo     ^<path^>%cusromdir%\amiga^</path^> >> "%USERPROFILE%\.emulationstation\es_systems.cfg"
echo     ^<extension^>.adf .ADF .zip .ZIP^</extension^> >> "%USERPROFILE%\.emulationstation\es_systems.cfg"
echo     ^<command^>C:\RetroCake\RetroArch\retroarch.exe -L C:\RetroCake\RetroArch\cores\puae_libretro.dll "%%ROM_RAW%%"^</command^> >> "%USERPROFILE%\.emulationstation\es_systems.cfg"
echo     ^<platform^>amiga^</platform^> >> "%USERPROFILE%\.emulationstation\es_systems.cfg"
echo     ^<theme^>amiga^</theme^> >> "%USERPROFILE%\.emulationstation\es_systems.cfg"
echo   ^</system^> >> "%USERPROFILE%\.emulationstation\es_systems.cfg"

echo   ^<system^> >> "%USERPROFILE%\.emulationstation\es_systems.cfg"
echo     ^<name^>amstradcpc^</name^> >> "%USERPROFILE%\.emulationstation\es_systems.cfg"
echo     ^<fullname^>Amstrad CPC^</fullname^> >> "%USERPROFILE%\.emulationstation\es_systems.cfg"
echo     ^<path^>%cusromdir%\amstradcpc^</path^> >> "%USERPROFILE%\.emulationstation\es_systems.cfg"
echo     ^<extension^>.cdt .cpc .dsk .CDT .CPC .DSK^</extension^> >> "%USERPROFILE%\.emulationstation\es_systems.cfg"
echo     ^<command^>C:\RetroCake\RetroArch\retroarch.exe -L C:\RetroCake\RetroArch\cores\cap32_libretro.dll "%%ROM_RAW%%"^</command^> >> "%USERPROFILE%\.emulationstation\es_systems.cfg"
echo     ^<platform^>amstradcpc^</platform^> >> "%USERPROFILE%\.emulationstation\es_systems.cfg"
echo     ^<theme^>amstradcpc^</theme^> >> "%USERPROFILE%\.emulationstation\es_systems.cfg"
echo   ^</system^> >> "%USERPROFILE%\.emulationstation\es_systems.cfg"

echo   ^<system^> >> "%USERPROFILE%\.emulationstation\es_systems.cfg"
echo     ^<name^>apple2^</name^> >> "%USERPROFILE%\.emulationstation\es_systems.cfg"
echo     ^<fullname^>Apple II^</fullname^> >> "%USERPROFILE%\.emulationstation\es_systems.cfg"
echo     ^<path^>%cusromdir%\apple2^</path^> >> "%USERPROFILE%\.emulationstation\es_systems.cfg"
echo     ^<extension^>.dsk .DSK^</extension^> >> "%USERPROFILE%\.emulationstation\es_systems.cfg"
echo     ^<command^>C:\RetroCake\AppleWin\Applewin.exe "%%ROM_RAW%%"^</command^> >> "%USERPROFILE%\.emulationstation\es_systems.cfg"
echo     ^<platform^>apple2^</platform^> >> "%USERPROFILE%\.emulationstation\es_systems.cfg"
echo     ^<theme^>apple2^</theme^> >> "%USERPROFILE%\.emulationstation\es_systems.cfg"
echo   ^</system^> >> "%USERPROFILE%\.emulationstation\es_systems.cfg"

echo   ^<system^> >> "%USERPROFILE%\.emulationstation\es_systems.cfg"
echo     ^<name^>bbcmicro^</name^> >> "%USERPROFILE%\.emulationstation\es_systems.cfg"
echo     ^<fullname^>Atari ST^</fullname^> >> "%USERPROFILE%\.emulationstation\es_systems.cfg"
echo     ^<path^>%cusromdir%\atarist^</path^> >> "%USERPROFILE%\.emulationstation\es_systems.cfg"
echo     ^<extension^>.ssd .dsd .ad .img .SSD .DSD .AD .IMG^</extension^> >> "%USERPROFILE%\.emulationstation\es_systems.cfg"
echo     ^<command^>C:\RetroCake\Emulators\BeebEm\BeebEm.exe "%%ROM_RAW%%"^</command^> >> "%USERPROFILE%\.emulationstation\es_systems.cfg"
echo     ^<platform^>bbcmicro^</platform^> >> "%USERPROFILE%\.emulationstation\es_systems.cfg"
echo     ^<theme^>bbcmicro^</theme^> >> "%USERPROFILE%\.emulationstation\es_systems.cfg"
echo   ^</system^> >> "%USERPROFILE%\.emulationstation\es_systems.cfg"

echo   ^<system^> >> "%USERPROFILE%\.emulationstation\es_systems.cfg"
echo     ^<name^>c64^</name^> >> "%USERPROFILE%\.emulationstation\es_systems.cfg"
echo     ^<fullname^>Commodore 64^</fullname^> >> "%USERPROFILE%\.emulationstation\es_systems.cfg"
echo     ^<path^>%cusromdir%\c64^</path^> >> "%USERPROFILE%\.emulationstation\es_systems.cfg"
echo     ^<extension^>.crt .d64 .g64 .t64 .tap .x64 .zip .prg .CRT .D64 .G64 .T64 .TAP .X64 .ZIP .PRG^</extension^> >> "%USERPROFILE%\.emulationstation\es_systems.cfg"
echo     ^<command^>C:\RetroCake\Emulators\WinVICE\x64.exe -fullscreen "%%ROM_RAW%%"^</command^> >> "%USERPROFILE%\.emulationstation\es_systems.cfg"
echo     ^<platform^>c64^</platform^> >> "%USERPROFILE%\.emulationstation\es_systems.cfg"
echo     ^<theme^>c64^</theme^> >> "%USERPROFILE%\.emulationstation\es_systems.cfg"
echo   ^</system^> >> "%USERPROFILE%\.emulationstation\es_systems.cfg"

echo   ^<system^> >> "%USERPROFILE%\.emulationstation\es_systems.cfg"
echo     ^<name^>coco^</name^> >> "%USERPROFILE%\.emulationstation\es_systems.cfg"
echo     ^<fullname^>CoCo^</fullname^> >> "%USERPROFILE%\.emulationstation\es_systems.cfg"
echo     ^<path^>%cusromdir%\coco^</path^> >> "%USERPROFILE%\.emulationstation\es_systems.cfg"
echo     ^<extension^>.cas .wav .bas .asc .dmk .jvc .os9 .dsk .vdk .rom .ccc .sna .CAS .WAV .BAS .ASC .DMK .JVC .OS9 .DSK .VDK .ROM .CCC .SNA^</extension^> >> "%USERPROFILE%\.emulationstation\es_systems.cfg"
echo     ^<command^>C:\RetroCake\Emulators\XRoar\xroar.exe "%%ROM_RAW%%"^</command^> >> "%USERPROFILE%\.emulationstation\es_systems.cfg"
echo     ^<platform^>coco^</platform^> >> "%USERPROFILE%\.emulationstation\es_systems.cfg"
echo     ^<theme^>coco^</theme^> >> "%USERPROFILE%\.emulationstation\es_systems.cfg"
echo   ^</system^> >> "%USERPROFILE%\.emulationstation\es_systems.cfg"

echo   ^<system^> >> "%USERPROFILE%\.emulationstation\es_systems.cfg"
echo     ^<name^>coleco^</name^> >> "%USERPROFILE%\.emulationstation\es_systems.cfg"
echo     ^<fullname^>ColecoVision^</fullname^> >> "%USERPROFILE%\.emulationstation\es_systems.cfg"
echo     ^<path^>%cusromdir%\colecovision^</path^> >> "%USERPROFILE%\.emulationstation\es_systems.cfg"
echo     ^<extension^>.bin .col .rom .zip .BIN .COL .ROM .ZIP^</extension^> >> "%USERPROFILE%\.emulationstation\es_systems.cfg"
echo     ^<command^>C:\RetroCake\RetroArch\retroarch.exe -L C:\RetroCake\RetroArch\cores\bluemsx_libretro.dll "%%ROM_RAW%%"^</command^> >> "%USERPROFILE%\.emulationstation\es_systems.cfg"
echo     ^<platform^>colecovision^</platform^> >> "%USERPROFILE%\.emulationstation\es_systems.cfg"
echo     ^<theme^>colecovision^</theme^> >> "%USERPROFILE%\.emulationstation\es_systems.cfg"
echo   ^</system^> >> "%USERPROFILE%\.emulationstation\es_systems.cfg"

echo   ^<system^> >> "%USERPROFILE%\.emulationstation\es_systems.cfg"
echo     ^<name^>daphne^</name^> >> "%USERPROFILE%\.emulationstation\es_systems.cfg"
echo     ^<fullname^>Daphne^</fullname^> >> "%USERPROFILE%\.emulationstation\es_systems.cfg"
echo     ^<path^>%cusromdir%\daphne^</path^> >> "%USERPROFILE%\.emulationstation\es_systems.cfg"
echo     ^<extension^>.daphne .DAPHNE^</extension^> >> "%USERPROFILE%\.emulationstation\es_systems.cfg"
echo     ^<command^>C:\RetroCake\Emulators\Daphne\daphne.exe "%%ROM_RAW%%"^</command^> >> "%USERPROFILE%\.emulationstation\es_systems.cfg"
echo     ^<platform^>daphne^</platform^> >> "%USERPROFILE%\.emulationstation\es_systems.cfg"
echo     ^<theme^>daphne^</theme^> >> "%USERPROFILE%\.emulationstation\es_systems.cfg"
echo   ^</system^> >> "%USERPROFILE%\.emulationstation\es_systems.cfg"

echo   ^<system^> >> "%USERPROFILE%\.emulationstation\es_systems.cfg"
echo     ^<name^>dragon32^</name^> >> "%USERPROFILE%\.emulationstation\es_systems.cfg"
echo     ^<fullname^>Dragon 32^</fullname^> >> "%USERPROFILE%\.emulationstation\es_systems.cfg"
echo     ^<path^>%cusromdir%\dragon32^</path^> >> "%USERPROFILE%\.emulationstation\es_systems.cfg"
echo     ^<extension^>.cas .wav .bas .asc .dmk .jvc .os9 .dsk .vdk .rom .ccc .sna .CAS .WAV .BAS .ASC .DMK .JVC .OS9 .DSK .VDK .ROM .CCC .SNA^</extension^> >> "%USERPROFILE%\.emulationstation\es_systems.cfg"
echo     ^<command^>C:\RetroCake\Emulators\XRoar\xroar.exe "%%ROM_RAW%%"^</command^> >> "%USERPROFILE%\.emulationstation\es_systems.cfg"
echo     ^<platform^>dragon32^</platform^> >> "%USERPROFILE%\.emulationstation\es_systems.cfg"
echo     ^<theme^>dragon32^</theme^> >> "%USERPROFILE%\.emulationstation\es_systems.cfg"
echo   ^</system^> >> "%USERPROFILE%\.emulationstation\es_systems.cfg"

echo   ^<system^> >> "%USERPROFILE%\.emulationstation\es_systems.cfg"
echo     ^<name^>intellivision^</name^> >> "%USERPROFILE%\.emulationstation\es_systems.cfg"
echo     ^<fullname^>Intellivision^</fullname^> >> "%USERPROFILE%\.emulationstation\es_systems.cfg"
echo     ^<path^>%cusromdir%\intellivision^</path^> >> "%USERPROFILE%\.emulationstation\es_systems.cfg"
echo     ^<extension^>.int .bin .INT .BIN^</extension^> >> "%USERPROFILE%\.emulationstation\es_systems.cfg"
echo     ^<command^>C:\RetroCake\Emulators\jzIntv\bin\jzIntv.exe "%%ROM_RAW%%"^</command^> >> "%USERPROFILE%\.emulationstation\es_systems.cfg"
echo     ^<platform^>intellivision^</platform^> >> "%USERPROFILE%\.emulationstation\es_systems.cfg"
echo     ^<theme^>intellivision^</theme^> >> "%USERPROFILE%\.emulationstation\es_systems.cfg"
echo   ^</system^> >> "%USERPROFILE%\.emulationstation\es_systems.cfg"

echo   ^<system^> >> "%USERPROFILE%\.emulationstation\es_systems.cfg"
echo     ^<name^>msx^</name^> >> "%USERPROFILE%\.emulationstation\es_systems.cfg"
echo     ^<fullname^>MSX^</fullname^> >> "%USERPROFILE%\.emulationstation\es_systems.cfg"
echo     ^<path^>%cusromdir%\msx^</path^> >> "%USERPROFILE%\.emulationstation\es_systems.cfg"
echo     ^<extension^>.rom .mx1 .mx2 .col .dsk .zip .ROM .MX1 .MX2 .COL .DSK .ZIP^</extension^> >> "%USERPROFILE%\.emulationstation\es_systems.cfg"
echo     ^<command^>C:\RetroCake\RetroArch\retroarch.exe -L C:\RetroCake\RetroArch\cores\bluemsx_libretro.dll "%%ROM_RAW%%"^</command^> >> "%USERPROFILE%\.emulationstation\es_systems.cfg"
echo     ^<platform^>msx^</platform^> >> "%USERPROFILE%\.emulationstation\es_systems.cfg"
echo     ^<theme^>msx^</theme^> >> "%USERPROFILE%\.emulationstation\es_systems.cfg"
echo   ^</system^> >> "%USERPROFILE%\.emulationstation\es_systems.cfg"

echo   ^<system^> >> "%USERPROFILE%\.emulationstation\es_systems.cfg"
echo     ^<name^>pcengine^</name^> >> "%USERPROFILE%\.emulationstation\es_systems.cfg"
echo     ^<fullname^>PC Engine^</fullname^> >> "%USERPROFILE%\.emulationstation\es_systems.cfg"
echo     ^<path^>%cusromdir%\pcengine^</path^> >> "%USERPROFILE%\.emulationstation\es_systems.cfg"
echo     ^<extension^>.7z .pce .ccd .cue .zip .7Z .PCE .CCD .CUE .ZIP^</extension^> >> "%USERPROFILE%\.emulationstation\es_systems.cfg"
echo     ^<command^>C:\RetroCake\RetroArch\retroarch.exe -L C:\RetroCake\RetroArch\cores\mednafen_pce_fast_libretro.dll "%%ROM_RAW%%"^</command^> >> "%USERPROFILE%\.emulationstation\es_systems.cfg"
echo     ^<platform^>pcengine^</platform^> >> "%USERPROFILE%\.emulationstation\es_systems.cfg"
echo     ^<theme^>pcengine^</theme^> >> "%USERPROFILE%\.emulationstation\es_systems.cfg"
echo   ^</system^> >> "%USERPROFILE%\.emulationstation\es_systems.cfg"

echo   ^<system^> >> "%USERPROFILE%\.emulationstation\es_systems.cfg"
echo     ^<name^>vectrex^</name^> >> "%USERPROFILE%\.emulationstation\es_systems.cfg"
echo     ^<fullname^>Vectrex^</fullname^> >> "%USERPROFILE%\.emulationstation\es_systems.cfg"
echo     ^<path^>%cusromdir%\vectrex^</path^> >> "%USERPROFILE%\.emulationstation\es_systems.cfg"
echo     ^<extension^>.7z .vec .gam .bin .zip .7Z .VEC .GAM .BIN .ZIP^</extension^> >> "%USERPROFILE%\.emulationstation\es_systems.cfg"
echo     ^<command^>C:\RetroCake\RetroArch\retroarch.exe -L C:\RetroCake\RetroArch\cores\vecx_libretro.dll "%%ROM_RAW%%"^</command^> >> "%USERPROFILE%\.emulationstation\es_systems.cfg"
echo     ^<platform^>vectrex^</platform^> >> "%USERPROFILE%\.emulationstation\es_systems.cfg"
echo     ^<theme^>vectrex^</theme^> >> "%USERPROFILE%\.emulationstation\es_systems.cfg"
echo   ^</system^> >> "%USERPROFILE%\.emulationstation\es_systems.cfg"

echo   ^<system^> >> "%USERPROFILE%\.emulationstation\es_systems.cfg"
echo     ^<name^>zxspectrum^</name^> >> "%USERPROFILE%\.emulationstation\es_systems.cfg"
echo     ^<fullname^>ZX Spectrum^</fullname^> >> "%USERPROFILE%\.emulationstation\es_systems.cfg"
echo     ^<path^>%cusromdir%\zxspectrum^</path^> >> "%USERPROFILE%\.emulationstation\es_systems.cfg"
echo     ^<extension^>.7z .sh .sna .szx .z80 .tap .tzx .gz .udi .mgt .img .trd .scl .dsk .zip .7Z .SH .SNA .SZX .Z80 .TAP .TZX .GZ .UDI .MGT .IMG .TRD .SCL .DSK .ZIP^</extension^> >> "%USERPROFILE%\.emulationstation\es_systems.cfg"
echo     ^<command^>C:\RetroCake\RetroArch\retroarch.exe -L C:\RetroCake\RetroArch\cores\fuse_libretro.dll "%%ROM_RAW%%"^</command^> >> "%USERPROFILE%\.emulationstation\es_systems.cfg"
echo     ^<platform^>zxspectrum^</platform^> >> "%USERPROFILE%\.emulationstation\es_systems.cfg"
echo     ^<theme^>zxspectrum^</theme^> >> "%USERPROFILE%\.emulationstation\es_systems.cfg"
echo   ^</system^> >> "%USERPROFILE%\.emulationstation\es_systems.cfg"

echo ^</systemList^> >> "%USERPROFILE%\.emulationstation\es_systems.cfg"
IF EXIST C:\RetroCake\Temp\BrandNewCus goto CustomRomFolders
goto completed

:editES
cls
notepad %USERPROFILE%\.emulationstation\es_systems.cfg
goto ManESCFG

::=================================================================================================================================================================================================================================================================================================================
::=================================================================================================================================================================================================================================================================================================================
::=================================================================================================================================================================================================================================================================================================================
::=================================================================================================================================================================================================================================================================================================================
::=================================================================================================================================================================================================================================================================================================================

:DefaultRomFolders
cls
mkdir C:\RetroCake\ROMS\3do
mkdir C:\RetroCake\ROMS\ags
mkdir C:\RetroCake\ROMS\amiga
mkdir C:\RetroCake\ROMS\amstradcpc
mkdir C:\RetroCake\ROMS\apple2
mkdir C:\RetroCake\ROMS\atari2600
mkdir C:\RetroCake\ROMS\atari5200
mkdir C:\RetroCake\ROMS\atari7800
mkdir C:\RetroCake\ROMS\atari800
mkdir C:\RetroCake\ROMS\atarijaguar
mkdir C:\RetroCake\ROMS\atarilynx
mkdir C:\RetroCake\ROMS\atarist
mkdir C:\RetroCake\ROMS\bbcmicro
mkdir C:\RetroCake\ROMS\c64
mkdir C:\RetroCake\ROMS\coco
mkdir C:\RetroCake\ROMS\colecovision
mkdir C:\RetroCake\ROMS\daphne
mkdir C:\RetroCake\ROMS\dragon32
mkdir C:\RetroCake\ROMS\dreamcast
mkdir C:\RetroCake\ROMS\fba
mkdir C:\RetroCake\ROMS\fds
mkdir C:\RetroCake\ROMS\gameandwatch
mkdir C:\RetroCake\ROMS\gamegear
mkdir C:\RetroCake\ROMS\gb
mkdir C:\RetroCake\ROMS\gba
mkdir C:\RetroCake\ROMS\gbc
mkdir C:\RetroCake\ROMS\gc
mkdir C:\RetroCake\ROMS\intellivision
mkdir C:\RetroCake\ROMS\mame
mkdir C:\RetroCake\ROMS\mastersystem
mkdir C:\RetroCake\ROMS\mega32x
mkdir C:\RetroCake\ROMS\mega-cd
mkdir C:\RetroCake\ROMS\megadrive
mkdir C:\RetroCake\ROMS\msx
mkdir C:\RetroCake\ROMS\mvs
mkdir C:\RetroCake\ROMS\n64
mkdir C:\RetroCake\ROMS\nds
mkdir C:\RetroCake\ROMS\neogeo
mkdir C:\RetroCake\ROMS\nes
mkdir C:\RetroCake\ROMS\ngp
mkdir C:\RetroCake\ROMS\ngpc
mkdir C:\RetroCake\ROMS\pcengine
mkdir C:\RetroCake\ROMS\ps2
mkdir C:\RetroCake\ROMS\psp
mkdir C:\RetroCake\ROMS\psx
mkdir C:\RetroCake\ROMS\saturn
mkdir C:\RetroCake\ROMS\sega32x
mkdir C:\RetroCake\ROMS\segacd
mkdir C:\RetroCake\ROMS\sfc
mkdir C:\RetroCake\ROMS\sg-1000
mkdir C:\RetroCake\ROMS\snes
mkdir C:\RetroCake\ROMS\vectrex
mkdir C:\RetroCake\ROMS\virtualboy
mkdir C:\RetroCake\ROMS\wii
mkdir C:\RetroCake\ROMS\zxspectrum
start C:\RetroCake\ROMS
IF EXIST C:\RetroCake\Temp\BrandNewDef goto updateRA
goto completed

:CusRomDirSet
set /p cusromdir="Enter Path for ROM Folder (default C:\RetroCake\ROMS): "
goto CustomRomFolders

:CustomRomFolders
cls
mkdir %cusromdir%\3do
mkdir %cusromdir%\ags
mkdir %cusromdir%\amiga
mkdir %cusromdir%\amstradcpc
mkdir %cusromdir%\apple2
mkdir %cusromdir%\atari2600
mkdir %cusromdir%\atari5200
mkdir %cusromdir%\atari7800
mkdir %cusromdir%\atari800
mkdir %cusromdir%\atarijaguar
mkdir %cusromdir%\atarilynx
mkdir %cusromdir%\atarist
mkdir %cusromdir%\bbcmicro
mkdir %cusromdir%\c64
mkdir %cusromdir%\coco
mkdir %cusromdir%\colecovision
mkdir %cusromdir%\daphne
mkdir %cusromdir%\dragon32
mkdir %cusromdir%\dreamcast
mkdir %cusromdir%\fba
mkdir %cusromdir%\fds
mkdir %cusromdir%\gameandwatch
mkdir %cusromdir%\gamegear
mkdir %cusromdir%\gb
mkdir %cusromdir%\gba
mkdir %cusromdir%\gbc
mkdir %cusromdir%\gc
mkdir %cusromdir%\intellivision
mkdir %cusromdir%\mame
mkdir %cusromdir%\mastersystem
mkdir %cusromdir%\mega32x
mkdir %cusromdir%\mega-cd
mkdir %cusromdir%\megadrive
mkdir %cusromdir%\msx
mkdir %cusromdir%\mvs
mkdir %cusromdir%\n64
mkdir %cusromdir%\nds
mkdir %cusromdir%\neogeo
mkdir %cusromdir%\nes
mkdir %cusromdir%\ngp
mkdir %cusromdir%\ngpc
mkdir %cusromdir%\pcengine
mkdir %cusromdir%\ps2
mkdir %cusromdir%\psp
mkdir %cusromdir%\psx
mkdir %cusromdir%\saturn
mkdir %cusromdir%\sega32x
mkdir %cusromdir%\segacd
mkdir %cusromdir%\sfc
mkdir %cusromdir%\sg-1000
mkdir %cusromdir%\snes
mkdir %cusromdir%\vectrex
mkdir %cusromdir%\virtualboy
mkdir %cusromdir%\wii
mkdir %cusromdir%\zxspectrum
start %cusromdir%
IF EXIST C:\RetroCake\Temp\BrandNewCus goto updateRA
goto completed

::=================================================================================================================================================================================================================================================================================================================
::=================================================================================================================================================================================================================================================================================================================
::=================================================================================================================================================================================================================================================================================================================
::=================================================================================================================================================================================================================================================================================================================
::=================================================================================================================================================================================================================================================================================================================

:updateRA
cls
mkdir "C:\RetroCake\Temp\cores"
cls
if "%PROCESSOR_ARCHITECTURE%"=="AMD64" (
		goto x64RA
	)
if "%PROCESSOR_ARCHITECTURE%"=="x86" (
		goto x86RA
	)

:x64RA
echo(
echo(
echo(
echo(
echo(
echo(
echo(
echo =================================================================
echo =                                                               =
echo =        Downloading RetroArch. This will take some time        =
echo =                                                               =
echo =================================================================
powershell -command "Invoke-WebRequest -Uri https://buildbot.libretro.com/stable/1.6.7/windows/x86_64/RetroArch.7z -OutFile "C:\RetroCake\Temp\RetroArch_x64.zip""

C:\RetroCake\Tools\7za\7za.exe x "C:\RetroCake\Temp\RetroArch_x64.zip" -o"C:\RetroCake\RetroArch" -aoa
cls
echo ================================================
echo =         Cleaning up downloaded files         =
echo ================================================
ping 127.0.0.1 -n 4 >nul
del "C:\RetroCake\Temp\RetroArch_x64.zip" /q
goto RACFG

:x86RA
echo(
echo(
echo(
echo(
echo(
echo(
echo(
echo =================================================================
echo =                                                               =
echo =        Downloading RetroArch. This will take some time        =
echo =                                                               =
echo =================================================================
powershell -command "Invoke-WebRequest -Uri https://buildbot.libretro.com/stable/1.6.7/windows/x86/RetroArch.7z -OutFile "C:\RetroCake\Temp\RetroArch_x86.zip""

C:\RetroCake\Tools\7za\7za.exe x "C:\RetroCake\Temp\RetroArch_x86.zip" -o"C:\RetroCake\RetroArch" -aoa
cls
echo ================================================
echo =         Cleaning up downloaded files         =
echo ================================================
ping 127.0.0.1 -n 4 >nul
del "C:\RetroCake\Temp\RetroArch_x86.zip" /q
goto RACFG

::=================================================================================================================================================================================================================================================================================================================

:updateRAn
cls
cls
mkdir "C:\RetroCake\Temp\cores"
cls
if "%PROCESSOR_ARCHITECTURE%"=="AMD64" (
		goto x64RAn
	)
if "%PROCESSOR_ARCHITECTURE%"=="x86" (
		goto x86RAn
	)

:x64RAn
echo(
echo(
echo(
echo(
echo(
echo(
echo(
echo =================================================================
echo =                                                               =
echo =        Downloading RetroArch. This will take some time        =
echo =                                                               =
echo =================================================================
powershell -command "Invoke-WebRequest -Uri https://buildbot.libretro.com/nightly/windows/x86_64/RetroArch.7z -OutFile "C:\RetroCake\Temp\RetroArch_x64.zip""
C:\RetroCake\Tools\7za\7za.exe x "C:\RetroCake\Temp\RetroArch_x64.zip" -o"C:\RetroCake\RetroArch" -aoa
cls
echo ================================================
echo =         Cleaning up downloaded files         =
echo ================================================
ping 127.0.0.1 -n 4 >nul
del "C:\RetroCake\Temp\RetroArch_x64.zip" /q
goto completed

:x86RAn
echo(
echo(
echo(
echo(
echo(
echo(
echo(
echo =================================================================
echo =                                                               =
echo =        Downloading RetroArch. This will take some time        =
echo =                                                               =
echo =================================================================
powershell -command "Invoke-WebRequest -Uri https://buildbot.libretro.com/nightly/windows/x86/RetroArch.7z -OutFile "C:\RetroCake\Temp\RetroArch_x86.zip""
C:\RetroCake\Tools\7za\7za.exe x "C:\RetroCake\Temp\RetroArch_x86.zip" -o"C:\RetroCake\RetroArch" -aoa
cls
echo ================================================
echo =         Cleaning up downloaded files         =
echo ================================================
ping 127.0.0.1 -n 4 >nul
del "C:\RetroCake\Temp\RetroArch_x86.zip" /q
goto completed

:RACFG
echo config_save_on_exit = "true"> C:\RetroCake\RetroArch\retroarch.cfg
echo core_updater_buildbot_url = "http://buildbot.libretro.com/nightly/windows/x86_64/latest/">> C:\RetroCake\RetroArch\retroarch.cfg
echo core_updater_buildbot_assets_url = "http://buildbot.libretro.com/assets/">> C:\RetroCake\RetroArch\retroarch.cfg
echo libretro_directory = ":\cores">> C:\RetroCake\RetroArch\retroarch.cfg
echo libretro_info_path = ":\info">> C:\RetroCake\RetroArch\retroarch.cfg
echo content_database_path = ":\database\rdb">> C:\RetroCake\RetroArch\retroarch.cfg
echo cheat_database_path = ":\cheats">> C:\RetroCake\RetroArch\retroarch.cfg
echo content_history_path = ":\content_history.lpl">> C:\RetroCake\RetroArch\retroarch.cfg
echo content_favorites_path = ":\content_favorites.lpl">> C:\RetroCake\RetroArch\retroarch.cfg
echo content_music_history_path = ":\content_music_history.lpl">> C:\RetroCake\RetroArch\retroarch.cfg
echo content_video_history_path = ":\content_video_history.lpl">> C:\RetroCake\RetroArch\retroarch.cfg
echo content_image_history_path = ":\content_image_history.lpl">> C:\RetroCake\RetroArch\retroarch.cfg
echo cursor_directory = ":\database\cursors">> C:\RetroCake\RetroArch\retroarch.cfg
echo screenshot_directory = ":\screenshots">> C:\RetroCake\RetroArch\retroarch.cfg
echo system_directory = ":\system">> C:\RetroCake\RetroArch\retroarch.cfg
echo input_remapping_directory = ":\config\remaps">> C:\RetroCake\RetroArch\retroarch.cfg
echo video_shader_dir = ":\shaders">> C:\RetroCake\RetroArch\retroarch.cfg
echo video_filter_dir = ":\filters\video">> C:\RetroCake\RetroArch\retroarch.cfg
echo core_assets_directory = ":\downloads">> C:\RetroCake\RetroArch\retroarch.cfg
echo assets_directory = ":\assets">> C:\RetroCake\RetroArch\retroarch.cfg
echo dynamic_wallpapers_directory = ":\assets\wallpapers">> C:\RetroCake\RetroArch\retroarch.cfg
echo thumbnails_directory = ":\thumbnails">> C:\RetroCake\RetroArch\retroarch.cfg
echo playlist_directory = ":\playlists">> C:\RetroCake\RetroArch\retroarch.cfg
echo joypad_autoconfig_dir = ":\autoconfig">> C:\RetroCake\RetroArch\retroarch.cfg
echo audio_filter_dir = ":\filters\audio">> C:\RetroCake\RetroArch\retroarch.cfg
echo savefile_directory = ":\saves">> C:\RetroCake\RetroArch\retroarch.cfg
echo savestate_directory = ":\states">> C:\RetroCake\RetroArch\retroarch.cfg
echo rgui_browser_directory = "default">> C:\RetroCake\RetroArch\retroarch.cfg
echo rgui_config_directory = ":\config">> C:\RetroCake\RetroArch\retroarch.cfg
echo overlay_directory = ":\overlays">> C:\RetroCake\RetroArch\retroarch.cfg
echo screenshot_directory = ":\screenshots">> C:\RetroCake\RetroArch\retroarch.cfg
echo video_driver = "gl">> C:\RetroCake\RetroArch\retroarch.cfg
echo record_driver = "ffmpeg">> C:\RetroCake\RetroArch\retroarch.cfg
echo camera_driver = "null">> C:\RetroCake\RetroArch\retroarch.cfg
echo wifi_driver = "null">> C:\RetroCake\RetroArch\retroarch.cfg
echo location_driver = "null">> C:\RetroCake\RetroArch\retroarch.cfg
echo menu_driver = "xmb">> C:\RetroCake\RetroArch\retroarch.cfg
echo audio_driver = "xaudio">> C:\RetroCake\RetroArch\retroarch.cfg
echo audio_resampler = "sinc">> C:\RetroCake\RetroArch\retroarch.cfg
echo input_driver = "dinput">> C:\RetroCake\RetroArch\retroarch.cfg
echo input_joypad_driver = "xinput">> C:\RetroCake\RetroArch\retroarch.cfg
echo video_aspect_ratio = "-1.000000">> C:\RetroCake\RetroArch\retroarch.cfg
echo video_scale = "3.000000">> C:\RetroCake\RetroArch\retroarch.cfg
echo video_refresh_rate = "60.000027">> C:\RetroCake\RetroArch\retroarch.cfg
echo audio_rate_control_delta = "0.005000">> C:\RetroCake\RetroArch\retroarch.cfg
echo audio_max_timing_skew = "0.050000">> C:\RetroCake\RetroArch\retroarch.cfg
echo audio_volume = "0.000000">> C:\RetroCake\RetroArch\retroarch.cfg
echo audio_mixer_volume = "0.000000">> C:\RetroCake\RetroArch\retroarch.cfg
echo input_overlay_opacity = "0.700000">> C:\RetroCake\RetroArch\retroarch.cfg
echo input_overlay_scale = "1.000000">> C:\RetroCake\RetroArch\retroarch.cfg
echo menu_wallpaper_opacity = "0.300000">> C:\RetroCake\RetroArch\retroarch.cfg
echo menu_framebuffer_opacity = "0.900000">> C:\RetroCake\RetroArch\retroarch.cfg
echo menu_footer_opacity = "1.000000">> C:\RetroCake\RetroArch\retroarch.cfg
echo menu_header_opacity = "1.000000">> C:\RetroCake\RetroArch\retroarch.cfg
echo video_message_pos_x = "0.050000">> C:\RetroCake\RetroArch\retroarch.cfg
echo video_message_pos_y = "0.050000">> C:\RetroCake\RetroArch\retroarch.cfg
echo video_font_size = "32.000000">> C:\RetroCake\RetroArch\retroarch.cfg
echo fastforward_ratio = "0.000000">> C:\RetroCake\RetroArch\retroarch.cfg
echo slowmotion_ratio = "3.000000">> C:\RetroCake\RetroArch\retroarch.cfg
echo input_axis_threshold = "0.500000">> C:\RetroCake\RetroArch\retroarch.cfg
echo state_slot = "0">> C:\RetroCake\RetroArch\retroarch.cfg
echo netplay_check_frames = "30">> C:\RetroCake\RetroArch\retroarch.cfg
echo audio_wasapi_sh_buffer_length = "-16">> C:\RetroCake\RetroArch\retroarch.cfg
echo input_bind_timeout = "5">> C:\RetroCake\RetroArch\retroarch.cfg
echo input_turbo_period = "6">> C:\RetroCake\RetroArch\retroarch.cfg
echo input_duty_cycle = "3">> C:\RetroCake\RetroArch\retroarch.cfg
echo input_max_users = "5">> C:\RetroCake\RetroArch\retroarch.cfg
echo input_menu_toggle_gamepad_combo = "4">> C:\RetroCake\RetroArch\retroarch.cfg
echo audio_latency = "64">> C:\RetroCake\RetroArch\retroarch.cfg
echo audio_block_frames = "0">> C:\RetroCake\RetroArch\retroarch.cfg
echo rewind_granularity = "1">> C:\RetroCake\RetroArch\retroarch.cfg
echo autosave_interval = "0">> C:\RetroCake\RetroArch\retroarch.cfg
echo libretro_log_level = "1">> C:\RetroCake\RetroArch\retroarch.cfg
echo keyboard_gamepad_mapping_type = "1">> C:\RetroCake\RetroArch\retroarch.cfg
echo input_poll_type_behavior = "2">> C:\RetroCake\RetroArch\retroarch.cfg
echo video_monitor_index = "0">> C:\RetroCake\RetroArch\retroarch.cfg
echo video_fullscreen_x = "0">> C:\RetroCake\RetroArch\retroarch.cfg
echo video_fullscreen_y = "0">> C:\RetroCake\RetroArch\retroarch.cfg
echo video_window_x = "0">> C:\RetroCake\RetroArch\retroarch.cfg
echo video_window_y = "0">> C:\RetroCake\RetroArch\retroarch.cfg
echo network_cmd_port = "55355">> C:\RetroCake\RetroArch\retroarch.cfg
echo network_remote_base_port = "55400">> C:\RetroCake\RetroArch\retroarch.cfg
echo dpi_override_value = "200">> C:\RetroCake\RetroArch\retroarch.cfg
echo menu_thumbnails = "3">> C:\RetroCake\RetroArch\retroarch.cfg
echo xmb_alpha_factor = "75">> C:\RetroCake\RetroArch\retroarch.cfg
echo xmb_scale_factor = "100">> C:\RetroCake\RetroArch\retroarch.cfg
echo xmb_theme = "0">> C:\RetroCake\RetroArch\retroarch.cfg
echo xmb_menu_color_theme = "4">> C:\RetroCake\RetroArch\retroarch.cfg
echo materialui_menu_color_theme = "0">> C:\RetroCake\RetroArch\retroarch.cfg
echo menu_shader_pipeline = "2">> C:\RetroCake\RetroArch\retroarch.cfg
echo audio_out_rate = "48000">> C:\RetroCake\RetroArch\retroarch.cfg
echo custom_viewport_width = "960">> C:\RetroCake\RetroArch\retroarch.cfg
echo custom_viewport_height = "720">> C:\RetroCake\RetroArch\retroarch.cfg
echo custom_viewport_x = "0">> C:\RetroCake\RetroArch\retroarch.cfg
echo custom_viewport_y = "0">> C:\RetroCake\RetroArch\retroarch.cfg
echo content_history_size = "100">> C:\RetroCake\RetroArch\retroarch.cfg
echo video_hard_sync_frames = "0">> C:\RetroCake\RetroArch\retroarch.cfg
echo video_frame_delay = "0">> C:\RetroCake\RetroArch\retroarch.cfg
echo video_max_swapchain_images = "3">> C:\RetroCake\RetroArch\retroarch.cfg
echo video_swap_interval = "1">> C:\RetroCake\RetroArch\retroarch.cfg
echo video_rotation = "0">> C:\RetroCake\RetroArch\retroarch.cfg
echo aspect_ratio_index = "21">> C:\RetroCake\RetroArch\retroarch.cfg
echo netplay_ip_port = "55435">> C:\RetroCake\RetroArch\retroarch.cfg
echo netplay_input_latency_frames_min = "0">> C:\RetroCake\RetroArch\retroarch.cfg
echo netplay_input_latency_frames_range = "0">> C:\RetroCake\RetroArch\retroarch.cfg
echo user_language = "0">> C:\RetroCake\RetroArch\retroarch.cfg
echo bundle_assets_extract_version_current = "0">> C:\RetroCake\RetroArch\retroarch.cfg
echo bundle_assets_extract_last_version = "0">> C:\RetroCake\RetroArch\retroarch.cfg
echo input_overlay_show_physical_inputs_port = "0">> C:\RetroCake\RetroArch\retroarch.cfg
echo input_device_p1 = "0">> C:\RetroCake\RetroArch\retroarch.cfg
echo input_player1_joypad_index = "0">> C:\RetroCake\RetroArch\retroarch.cfg
echo input_libretro_device_p1 = "1">> C:\RetroCake\RetroArch\retroarch.cfg
echo input_player1_analog_dpad_mode = "0">> C:\RetroCake\RetroArch\retroarch.cfg
echo input_player1_mouse_index = "0">> C:\RetroCake\RetroArch\retroarch.cfg
echo input_device_p2 = "0">> C:\RetroCake\RetroArch\retroarch.cfg
echo input_player2_joypad_index = "1">> C:\RetroCake\RetroArch\retroarch.cfg
echo input_libretro_device_p2 = "1">> C:\RetroCake\RetroArch\retroarch.cfg
echo input_player2_analog_dpad_mode = "0">> C:\RetroCake\RetroArch\retroarch.cfg
echo input_player2_mouse_index = "0">> C:\RetroCake\RetroArch\retroarch.cfg
echo input_device_p3 = "0">> C:\RetroCake\RetroArch\retroarch.cfg
echo input_player3_joypad_index = "2">> C:\RetroCake\RetroArch\retroarch.cfg
echo input_libretro_device_p3 = "1">> C:\RetroCake\RetroArch\retroarch.cfg
echo input_player3_analog_dpad_mode = "0">> C:\RetroCake\RetroArch\retroarch.cfg
echo input_player3_mouse_index = "0">> C:\RetroCake\RetroArch\retroarch.cfg
echo input_device_p4 = "0">> C:\RetroCake\RetroArch\retroarch.cfg
echo input_player4_joypad_index = "3">> C:\RetroCake\RetroArch\retroarch.cfg
echo input_libretro_device_p4 = "1">> C:\RetroCake\RetroArch\retroarch.cfg
echo input_player4_analog_dpad_mode = "0">> C:\RetroCake\RetroArch\retroarch.cfg
echo input_player4_mouse_index = "0">> C:\RetroCake\RetroArch\retroarch.cfg
echo input_device_p5 = "0">> C:\RetroCake\RetroArch\retroarch.cfg
echo input_player5_joypad_index = "4">> C:\RetroCake\RetroArch\retroarch.cfg
echo input_libretro_device_p5 = "1">> C:\RetroCake\RetroArch\retroarch.cfg
echo input_player5_analog_dpad_mode = "0">> C:\RetroCake\RetroArch\retroarch.cfg
echo input_player5_mouse_index = "0">> C:\RetroCake\RetroArch\retroarch.cfg
echo input_device_p6 = "0">> C:\RetroCake\RetroArch\retroarch.cfg
echo input_player6_joypad_index = "5">> C:\RetroCake\RetroArch\retroarch.cfg
echo input_libretro_device_p6 = "1">> C:\RetroCake\RetroArch\retroarch.cfg
echo input_player6_analog_dpad_mode = "0">> C:\RetroCake\RetroArch\retroarch.cfg
echo input_player6_mouse_index = "0">> C:\RetroCake\RetroArch\retroarch.cfg
echo input_device_p7 = "0">> C:\RetroCake\RetroArch\retroarch.cfg
echo input_player7_joypad_index = "6">> C:\RetroCake\RetroArch\retroarch.cfg
echo input_libretro_device_p7 = "1">> C:\RetroCake\RetroArch\retroarch.cfg
echo input_player7_analog_dpad_mode = "0">> C:\RetroCake\RetroArch\retroarch.cfg
echo input_player7_mouse_index = "0">> C:\RetroCake\RetroArch\retroarch.cfg
echo input_device_p8 = "0">> C:\RetroCake\RetroArch\retroarch.cfg
echo input_player8_joypad_index = "7">> C:\RetroCake\RetroArch\retroarch.cfg
echo input_libretro_device_p8 = "1">> C:\RetroCake\RetroArch\retroarch.cfg
echo input_player8_analog_dpad_mode = "0">> C:\RetroCake\RetroArch\retroarch.cfg
echo input_player8_mouse_index = "0">> C:\RetroCake\RetroArch\retroarch.cfg
echo input_device_p9 = "0">> C:\RetroCake\RetroArch\retroarch.cfg
echo input_player9_joypad_index = "8">> C:\RetroCake\RetroArch\retroarch.cfg
echo input_libretro_device_p9 = "1">> C:\RetroCake\RetroArch\retroarch.cfg
echo input_player9_analog_dpad_mode = "0">> C:\RetroCake\RetroArch\retroarch.cfg
echo input_player9_mouse_index = "0">> C:\RetroCake\RetroArch\retroarch.cfg
echo input_device_p10 = "0">> C:\RetroCake\RetroArch\retroarch.cfg
echo input_player10_joypad_index = "9">> C:\RetroCake\RetroArch\retroarch.cfg
echo input_libretro_device_p10 = "1">> C:\RetroCake\RetroArch\retroarch.cfg
echo input_player10_analog_dpad_mode = "0">> C:\RetroCake\RetroArch\retroarch.cfg
echo input_player10_mouse_index = "0">> C:\RetroCake\RetroArch\retroarch.cfg
echo input_device_p11 = "0">> C:\RetroCake\RetroArch\retroarch.cfg
echo input_player11_joypad_index = "10">> C:\RetroCake\RetroArch\retroarch.cfg
echo input_libretro_device_p11 = "1">> C:\RetroCake\RetroArch\retroarch.cfg
echo input_player11_analog_dpad_mode = "0">> C:\RetroCake\RetroArch\retroarch.cfg
echo input_player11_mouse_index = "0">> C:\RetroCake\RetroArch\retroarch.cfg
echo input_device_p12 = "0">> C:\RetroCake\RetroArch\retroarch.cfg
echo input_player12_joypad_index = "11">> C:\RetroCake\RetroArch\retroarch.cfg
echo input_libretro_device_p12 = "1">> C:\RetroCake\RetroArch\retroarch.cfg
echo input_player12_analog_dpad_mode = "0">> C:\RetroCake\RetroArch\retroarch.cfg
echo input_player12_mouse_index = "0">> C:\RetroCake\RetroArch\retroarch.cfg
echo input_device_p13 = "0">> C:\RetroCake\RetroArch\retroarch.cfg
echo input_player13_joypad_index = "12">> C:\RetroCake\RetroArch\retroarch.cfg
echo input_libretro_device_p13 = "1">> C:\RetroCake\RetroArch\retroarch.cfg
echo input_player13_analog_dpad_mode = "0">> C:\RetroCake\RetroArch\retroarch.cfg
echo input_player13_mouse_index = "0">> C:\RetroCake\RetroArch\retroarch.cfg
echo input_device_p14 = "0">> C:\RetroCake\RetroArch\retroarch.cfg
echo input_player14_joypad_index = "13">> C:\RetroCake\RetroArch\retroarch.cfg
echo input_libretro_device_p14 = "1">> C:\RetroCake\RetroArch\retroarch.cfg
echo input_player14_analog_dpad_mode = "0">> C:\RetroCake\RetroArch\retroarch.cfg
echo input_player14_mouse_index = "0">> C:\RetroCake\RetroArch\retroarch.cfg
echo input_device_p15 = "0">> C:\RetroCake\RetroArch\retroarch.cfg
echo input_player15_joypad_index = "14">> C:\RetroCake\RetroArch\retroarch.cfg
echo input_libretro_device_p15 = "1">> C:\RetroCake\RetroArch\retroarch.cfg
echo input_player15_analog_dpad_mode = "0">> C:\RetroCake\RetroArch\retroarch.cfg
echo input_player15_mouse_index = "0">> C:\RetroCake\RetroArch\retroarch.cfg
echo input_device_p16 = "0">> C:\RetroCake\RetroArch\retroarch.cfg
echo input_player16_joypad_index = "15">> C:\RetroCake\RetroArch\retroarch.cfg
echo input_libretro_device_p16 = "1">> C:\RetroCake\RetroArch\retroarch.cfg
echo input_player16_analog_dpad_mode = "0">> C:\RetroCake\RetroArch\retroarch.cfg
echo input_player16_mouse_index = "0">> C:\RetroCake\RetroArch\retroarch.cfg
echo ui_companion_start_on_boot = "true">> C:\RetroCake\RetroArch\retroarch.cfg
echo ui_companion_enable = "false">> C:\RetroCake\RetroArch\retroarch.cfg
echo video_gpu_record = "false">> C:\RetroCake\RetroArch\retroarch.cfg
echo input_remap_binds_enable = "true">> C:\RetroCake\RetroArch\retroarch.cfg
echo all_users_control_menu = "false">> C:\RetroCake\RetroArch\retroarch.cfg
echo menu_swap_ok_cancel_buttons = "true">> C:\RetroCake\RetroArch\retroarch.cfg
echo netplay_public_announce = "true">> C:\RetroCake\RetroArch\retroarch.cfg
echo netplay_start_as_spectator = "false">> C:\RetroCake\RetroArch\retroarch.cfg
echo netplay_allow_slaves = "true">> C:\RetroCake\RetroArch\retroarch.cfg
echo netplay_require_slaves = "false">> C:\RetroCake\RetroArch\retroarch.cfg
echo netplay_stateless_mode = "false">> C:\RetroCake\RetroArch\retroarch.cfg
echo netplay_client_swap_input = "true">> C:\RetroCake\RetroArch\retroarch.cfg
echo netplay_use_mitm_server = "false">> C:\RetroCake\RetroArch\retroarch.cfg
echo input_descriptor_label_show = "true">> C:\RetroCake\RetroArch\retroarch.cfg
echo input_descriptor_hide_unbound = "false">> C:\RetroCake\RetroArch\retroarch.cfg
echo load_dummy_on_core_shutdown = "true">> C:\RetroCake\RetroArch\retroarch.cfg
echo check_firmware_before_loading = "false">> C:\RetroCake\RetroArch\retroarch.cfg
echo builtin_mediaplayer_enable = "true">> C:\RetroCake\RetroArch\retroarch.cfg
echo builtin_imageviewer_enable = "true">> C:\RetroCake\RetroArch\retroarch.cfg
echo fps_show = "false">> C:\RetroCake\RetroArch\retroarch.cfg
echo ui_menubar_enable = "true">> C:\RetroCake\RetroArch\retroarch.cfg
echo suspend_screensaver_enable = "true">> C:\RetroCake\RetroArch\retroarch.cfg
echo rewind_enable = "false">> C:\RetroCake\RetroArch\retroarch.cfg
echo audio_sync = "true">> C:\RetroCake\RetroArch\retroarch.cfg
echo video_shader_enable = "false">> C:\RetroCake\RetroArch\retroarch.cfg
echo video_aspect_ratio_auto = "false">> C:\RetroCake\RetroArch\retroarch.cfg
echo video_allow_rotate = "true">> C:\RetroCake\RetroArch\retroarch.cfg
echo video_windowed_fullscreen = "true">> C:\RetroCake\RetroArch\retroarch.cfg
echo video_crop_overscan = "true">> C:\RetroCake\RetroArch\retroarch.cfg
echo video_scale_integer = "false">> C:\RetroCake\RetroArch\retroarch.cfg
echo video_smooth = "true">> C:\RetroCake\RetroArch\retroarch.cfg
echo video_force_aspect = "true">> C:\RetroCake\RetroArch\retroarch.cfg
echo video_threaded = "false">> C:\RetroCake\RetroArch\retroarch.cfg
echo video_shared_context = "false">> C:\RetroCake\RetroArch\retroarch.cfg
echo auto_screenshot_filename = "true">> C:\RetroCake\RetroArch\retroarch.cfg
echo video_force_srgb_disable = "false">> C:\RetroCake\RetroArch\retroarch.cfg
echo video_fullscreen = "true">> C:\RetroCake\RetroArch\retroarch.cfg
echo bundle_assets_extract_enable = "false">> C:\RetroCake\RetroArch\retroarch.cfg
echo video_vsync = "true">> C:\RetroCake\RetroArch\retroarch.cfg
echo video_hard_sync = "false">> C:\RetroCake\RetroArch\retroarch.cfg
echo video_black_frame_insertion = "false">> C:\RetroCake\RetroArch\retroarch.cfg
echo video_disable_composition = "false">> C:\RetroCake\RetroArch\retroarch.cfg
echo pause_nonactive = "true">> C:\RetroCake\RetroArch\retroarch.cfg
echo video_gpu_screenshot = "true">> C:\RetroCake\RetroArch\retroarch.cfg
echo video_post_filter_record = "false">> C:\RetroCake\RetroArch\retroarch.cfg
echo keyboard_gamepad_enable = "true">> C:\RetroCake\RetroArch\retroarch.cfg
echo core_set_supports_no_game_enable = "true">> C:\RetroCake\RetroArch\retroarch.cfg
echo audio_enable = "true">> C:\RetroCake\RetroArch\retroarch.cfg
echo audio_mute_enable = "false">> C:\RetroCake\RetroArch\retroarch.cfg
echo audio_mixer_mute_enable = "false">> C:\RetroCake\RetroArch\retroarch.cfg
echo location_allow = "false">> C:\RetroCake\RetroArch\retroarch.cfg
echo video_font_enable = "true">> C:\RetroCake\RetroArch\retroarch.cfg
echo core_updater_auto_extract_archive = "true">> C:\RetroCake\RetroArch\retroarch.cfg
echo camera_allow = "false">> C:\RetroCake\RetroArch\retroarch.cfg
echo menu_unified_controls = "false">> C:\RetroCake\RetroArch\retroarch.cfg
echo threaded_data_runloop_enable = "true">> C:\RetroCake\RetroArch\retroarch.cfg
echo menu_throttle_framerate = "true">> C:\RetroCake\RetroArch\retroarch.cfg
echo menu_linear_filter = "true">> C:\RetroCake\RetroArch\retroarch.cfg
echo menu_horizontal_animation = "true">> C:\RetroCake\RetroArch\retroarch.cfg
echo dpi_override_enable = "true">> C:\RetroCake\RetroArch\retroarch.cfg
echo menu_pause_libretro = "true">> C:\RetroCake\RetroArch\retroarch.cfg
echo menu_mouse_enable = "true">> C:\RetroCake\RetroArch\retroarch.cfg
echo menu_pointer_enable = "false">> C:\RetroCake\RetroArch\retroarch.cfg
echo menu_timedate_enable = "true">> C:\RetroCake\RetroArch\retroarch.cfg
echo menu_battery_level_enable = "true">> C:\RetroCake\RetroArch\retroarch.cfg
echo menu_core_enable = "true">> C:\RetroCake\RetroArch\retroarch.cfg
echo menu_dynamic_wallpaper_enable = "false">> C:\RetroCake\RetroArch\retroarch.cfg
echo materialui_icons_enable = "true">> C:\RetroCake\RetroArch\retroarch.cfg
echo xmb_shadows_enable = "true">> C:\RetroCake\RetroArch\retroarch.cfg
echo xmb_show_settings = "true">> C:\RetroCake\RetroArch\retroarch.cfg
echo xmb_show_favorites = "true">> C:\RetroCake\RetroArch\retroarch.cfg
echo xmb_show_images = "true">> C:\RetroCake\RetroArch\retroarch.cfg
echo xmb_show_music = "true">> C:\RetroCake\RetroArch\retroarch.cfg
echo menu_show_online_updater = "true">> C:\RetroCake\RetroArch\retroarch.cfg
echo menu_show_core_updater = "true">> C:\RetroCake\RetroArch\retroarch.cfg
echo xmb_show_video = "true">> C:\RetroCake\RetroArch\retroarch.cfg
echo xmb_show_netplay = "true">> C:\RetroCake\RetroArch\retroarch.cfg
echo xmb_show_history = "true">> C:\RetroCake\RetroArch\retroarch.cfg
echo xmb_show_add = "true">> C:\RetroCake\RetroArch\retroarch.cfg
echo filter_by_current_core = "false">> C:\RetroCake\RetroArch\retroarch.cfg
echo rgui_show_start_screen = "false">> C:\RetroCake\RetroArch\retroarch.cfg
echo menu_navigation_wraparound_enable = "true">> C:\RetroCake\RetroArch\retroarch.cfg
echo menu_navigation_browser_filter_supported_extensions_enable = "true">> C:\RetroCake\RetroArch\retroarch.cfg
echo menu_show_advanced_settings = "true">> C:\RetroCake\RetroArch\retroarch.cfg
echo cheevos_enable = "false">> C:\RetroCake\RetroArch\retroarch.cfg
echo cheevos_test_unofficial = "false">> C:\RetroCake\RetroArch\retroarch.cfg
echo cheevos_hardcore_mode_enable = "false">> C:\RetroCake\RetroArch\retroarch.cfg
echo cheevos_verbose_enable = "false">> C:\RetroCake\RetroArch\retroarch.cfg
echo input_overlay_enable = "true">> C:\RetroCake\RetroArch\retroarch.cfg
echo input_overlay_enable_autopreferred = "true">> C:\RetroCake\RetroArch\retroarch.cfg
echo input_overlay_show_physical_inputs = "false">> C:\RetroCake\RetroArch\retroarch.cfg
echo input_overlay_hide_in_menu = "true">> C:\RetroCake\RetroArch\retroarch.cfg
echo network_cmd_enable = "false">> C:\RetroCake\RetroArch\retroarch.cfg
echo stdin_cmd_enable = "false">> C:\RetroCake\RetroArch\retroarch.cfg
echo network_remote_enable = "false">> C:\RetroCake\RetroArch\retroarch.cfg
echo netplay_nat_traversal = "true">> C:\RetroCake\RetroArch\retroarch.cfg
echo block_sram_overwrite = "false">> C:\RetroCake\RetroArch\retroarch.cfg
echo savestate_auto_index = "false">> C:\RetroCake\RetroArch\retroarch.cfg
echo savestate_auto_save = "false">> C:\RetroCake\RetroArch\retroarch.cfg
echo savestate_auto_load = "false">> C:\RetroCake\RetroArch\retroarch.cfg
echo savestate_thumbnail_enable = "false">> C:\RetroCake\RetroArch\retroarch.cfg
echo history_list_enable = "true">> C:\RetroCake\RetroArch\retroarch.cfg
echo playlist_entry_remove = "true">> C:\RetroCake\RetroArch\retroarch.cfg
echo game_specific_options = "true">> C:\RetroCake\RetroArch\retroarch.cfg
echo auto_overrides_enable = "true">> C:\RetroCake\RetroArch\retroarch.cfg
echo auto_remaps_enable = "true">> C:\RetroCake\RetroArch\retroarch.cfg
echo auto_shaders_enable = "true">> C:\RetroCake\RetroArch\retroarch.cfg
echo sort_savefiles_enable = "false">> C:\RetroCake\RetroArch\retroarch.cfg
echo sort_savestates_enable = "false">> C:\RetroCake\RetroArch\retroarch.cfg
echo show_hidden_files = "false">> C:\RetroCake\RetroArch\retroarch.cfg
echo input_autodetect_enable = "true">> C:\RetroCake\RetroArch\retroarch.cfg
echo audio_rate_control = "true">> C:\RetroCake\RetroArch\retroarch.cfg
echo audio_wasapi_exclusive_mode = "true">> C:\RetroCake\RetroArch\retroarch.cfg
echo audio_wasapi_float_format = "false">> C:\RetroCake\RetroArch\retroarch.cfg
echo savestates_in_content_dir = "false">> C:\RetroCake\RetroArch\retroarch.cfg
echo savefiles_in_content_dir = "false">> C:\RetroCake\RetroArch\retroarch.cfg
echo systemfiles_in_content_dir = "false">> C:\RetroCake\RetroArch\retroarch.cfg
echo screenshots_in_content_dir = "false">> C:\RetroCake\RetroArch\retroarch.cfg
echo custom_bgm_enable = "false">> C:\RetroCake\RetroArch\retroarch.cfg
echo network_remote_enable_user_p1 = "false">> C:\RetroCake\RetroArch\retroarch.cfg
echo network_remote_enable_user_p2 = "false">> C:\RetroCake\RetroArch\retroarch.cfg
echo network_remote_enable_user_p3 = "false">> C:\RetroCake\RetroArch\retroarch.cfg
echo network_remote_enable_user_p4 = "false">> C:\RetroCake\RetroArch\retroarch.cfg
echo network_remote_enable_user_p5 = "false">> C:\RetroCake\RetroArch\retroarch.cfg
echo network_remote_enable_user_p6 = "false">> C:\RetroCake\RetroArch\retroarch.cfg
echo network_remote_enable_user_p7 = "false">> C:\RetroCake\RetroArch\retroarch.cfg
echo network_remote_enable_user_p8 = "false">> C:\RetroCake\RetroArch\retroarch.cfg
echo network_remote_enable_user_p9 = "false">> C:\RetroCake\RetroArch\retroarch.cfg
echo network_remote_enable_user_p10 = "false">> C:\RetroCake\RetroArch\retroarch.cfg
echo network_remote_enable_user_p11 = "false">> C:\RetroCake\RetroArch\retroarch.cfg
echo network_remote_enable_user_p12 = "false">> C:\RetroCake\RetroArch\retroarch.cfg
echo network_remote_enable_user_p13 = "false">> C:\RetroCake\RetroArch\retroarch.cfg
echo network_remote_enable_user_p14 = "false">> C:\RetroCake\RetroArch\retroarch.cfg
echo network_remote_enable_user_p15 = "false">> C:\RetroCake\RetroArch\retroarch.cfg
echo network_remote_enable_user_p16 = "false">> C:\RetroCake\RetroArch\retroarch.cfg
echo log_verbosity = "false">> C:\RetroCake\RetroArch\retroarch.cfg
echo perfcnt_enable = "false">> C:\RetroCake\RetroArch\retroarch.cfg
echo video_message_color = "ffffff">> C:\RetroCake\RetroArch\retroarch.cfg
echo menu_entry_normal_color = "ffffffff">> C:\RetroCake\RetroArch\retroarch.cfg
echo menu_entry_hover_color = "ff64ff64">> C:\RetroCake\RetroArch\retroarch.cfg
echo menu_title_color = "ff64ff64">> C:\RetroCake\RetroArch\retroarch.cfg
echo gamma_correction = "false">> C:\RetroCake\RetroArch\retroarch.cfg
echo flicker_filter_enable = "false">> C:\RetroCake\RetroArch\retroarch.cfg
echo soft_filter_enable = "false">> C:\RetroCake\RetroArch\retroarch.cfg
echo soft_filter_index = "0">> C:\RetroCake\RetroArch\retroarch.cfg
echo current_resolution_id = "0">> C:\RetroCake\RetroArch\retroarch.cfg
echo flicker_filter_index = "0">> C:\RetroCake\RetroArch\retroarch.cfg
echo input_player1_b = "z">> C:\RetroCake\RetroArch\retroarch.cfg
echo input_player1_b_btn = "nul">> C:\RetroCake\RetroArch\retroarch.cfg
echo input_player1_b_axis = "nul">> C:\RetroCake\RetroArch\retroarch.cfg
echo input_player1_y = "a">> C:\RetroCake\RetroArch\retroarch.cfg
echo input_player1_y_btn = "nul">> C:\RetroCake\RetroArch\retroarch.cfg
echo input_player1_y_axis = "nul">> C:\RetroCake\RetroArch\retroarch.cfg
echo input_player1_select = "rshift">> C:\RetroCake\RetroArch\retroarch.cfg
echo input_player1_select_btn = "nul">> C:\RetroCake\RetroArch\retroarch.cfg
echo input_player1_select_axis = "nul">> C:\RetroCake\RetroArch\retroarch.cfg
echo input_player1_start = "enter">> C:\RetroCake\RetroArch\retroarch.cfg
echo input_player1_start_btn = "nul">> C:\RetroCake\RetroArch\retroarch.cfg
echo input_player1_start_axis = "nul">> C:\RetroCake\RetroArch\retroarch.cfg
echo input_player1_up = "up">> C:\RetroCake\RetroArch\retroarch.cfg
echo input_player1_up_btn = "nul">> C:\RetroCake\RetroArch\retroarch.cfg
echo input_player1_up_axis = "nul">> C:\RetroCake\RetroArch\retroarch.cfg
echo input_player1_down = "down">> C:\RetroCake\RetroArch\retroarch.cfg
echo input_player1_down_btn = "nul">> C:\RetroCake\RetroArch\retroarch.cfg
echo input_player1_down_axis = "nul">> C:\RetroCake\RetroArch\retroarch.cfg
echo input_player1_left = "left">> C:\RetroCake\RetroArch\retroarch.cfg
echo input_player1_left_btn = "nul">> C:\RetroCake\RetroArch\retroarch.cfg
echo input_player1_left_axis = "nul">> C:\RetroCake\RetroArch\retroarch.cfg
echo input_player1_right = "right">> C:\RetroCake\RetroArch\retroarch.cfg
echo input_player1_right_btn = "nul">> C:\RetroCake\RetroArch\retroarch.cfg
echo input_player1_right_axis = "nul">> C:\RetroCake\RetroArch\retroarch.cfg
echo input_player1_a = "x">> C:\RetroCake\RetroArch\retroarch.cfg
echo input_player1_a_btn = "nul">> C:\RetroCake\RetroArch\retroarch.cfg
echo input_player1_a_axis = "nul">> C:\RetroCake\RetroArch\retroarch.cfg
echo input_player1_x = "s">> C:\RetroCake\RetroArch\retroarch.cfg
echo input_player1_x_btn = "nul">> C:\RetroCake\RetroArch\retroarch.cfg
echo input_player1_x_axis = "nul">> C:\RetroCake\RetroArch\retroarch.cfg
echo input_player1_l = "q">> C:\RetroCake\RetroArch\retroarch.cfg
echo input_player1_l_btn = "nul">> C:\RetroCake\RetroArch\retroarch.cfg
echo input_player1_l_axis = "nul">> C:\RetroCake\RetroArch\retroarch.cfg
echo input_player1_r = "w">> C:\RetroCake\RetroArch\retroarch.cfg
echo input_player1_r_btn = "nul">> C:\RetroCake\RetroArch\retroarch.cfg
echo input_player1_r_axis = "nul">> C:\RetroCake\RetroArch\retroarch.cfg
echo input_player1_l2 = "nul">> C:\RetroCake\RetroArch\retroarch.cfg
echo input_player1_l2_btn = "nul">> C:\RetroCake\RetroArch\retroarch.cfg
echo input_player1_l2_axis = "nul">> C:\RetroCake\RetroArch\retroarch.cfg
echo input_player1_r2 = "nul">> C:\RetroCake\RetroArch\retroarch.cfg
echo input_player1_r2_btn = "nul">> C:\RetroCake\RetroArch\retroarch.cfg
echo input_player1_r2_axis = "nul">> C:\RetroCake\RetroArch\retroarch.cfg
echo input_player1_l3 = "nul">> C:\RetroCake\RetroArch\retroarch.cfg
echo input_player1_l3_btn = "nul">> C:\RetroCake\RetroArch\retroarch.cfg
echo input_player1_l3_axis = "nul">> C:\RetroCake\RetroArch\retroarch.cfg
echo input_player1_r3 = "nul">> C:\RetroCake\RetroArch\retroarch.cfg
echo input_player1_r3_btn = "nul">> C:\RetroCake\RetroArch\retroarch.cfg
echo input_player1_r3_axis = "nul">> C:\RetroCake\RetroArch\retroarch.cfg
echo input_player1_l_x_plus = "nul">> C:\RetroCake\RetroArch\retroarch.cfg
echo input_player1_l_x_plus_btn = "nul">> C:\RetroCake\RetroArch\retroarch.cfg
echo input_player1_l_x_plus_axis = "nul">> C:\RetroCake\RetroArch\retroarch.cfg
echo input_player1_l_x_minus = "nul">> C:\RetroCake\RetroArch\retroarch.cfg
echo input_player1_l_x_minus_btn = "nul">> C:\RetroCake\RetroArch\retroarch.cfg
echo input_player1_l_x_minus_axis = "nul">> C:\RetroCake\RetroArch\retroarch.cfg
echo input_player1_l_y_plus = "nul">> C:\RetroCake\RetroArch\retroarch.cfg
echo input_player1_l_y_plus_btn = "nul">> C:\RetroCake\RetroArch\retroarch.cfg
echo input_player1_l_y_plus_axis = "nul">> C:\RetroCake\RetroArch\retroarch.cfg
echo input_player1_l_y_minus = "nul">> C:\RetroCake\RetroArch\retroarch.cfg
echo input_player1_l_y_minus_btn = "nul">> C:\RetroCake\RetroArch\retroarch.cfg
echo input_player1_l_y_minus_axis = "nul">> C:\RetroCake\RetroArch\retroarch.cfg
echo input_player1_r_x_plus = "nul">> C:\RetroCake\RetroArch\retroarch.cfg
echo input_player1_r_x_plus_btn = "nul">> C:\RetroCake\RetroArch\retroarch.cfg
echo input_player1_r_x_plus_axis = "nul">> C:\RetroCake\RetroArch\retroarch.cfg
echo input_player1_r_x_minus = "nul">> C:\RetroCake\RetroArch\retroarch.cfg
echo input_player1_r_x_minus_btn = "nul">> C:\RetroCake\RetroArch\retroarch.cfg
echo input_player1_r_x_minus_axis = "nul">> C:\RetroCake\RetroArch\retroarch.cfg
echo input_player1_r_y_plus = "nul">> C:\RetroCake\RetroArch\retroarch.cfg
echo input_player1_r_y_plus_btn = "nul">> C:\RetroCake\RetroArch\retroarch.cfg
echo input_player1_r_y_plus_axis = "nul">> C:\RetroCake\RetroArch\retroarch.cfg
echo input_player1_r_y_minus = "nul">> C:\RetroCake\RetroArch\retroarch.cfg
echo input_player1_r_y_minus_btn = "nul">> C:\RetroCake\RetroArch\retroarch.cfg
echo input_player1_r_y_minus_axis = "nul">> C:\RetroCake\RetroArch\retroarch.cfg
echo input_player1_turbo = "nul">> C:\RetroCake\RetroArch\retroarch.cfg
echo input_player1_turbo_btn = "nul">> C:\RetroCake\RetroArch\retroarch.cfg
echo input_player1_turbo_axis = "nul">> C:\RetroCake\RetroArch\retroarch.cfg
echo input_toggle_fast_forward = "space">> C:\RetroCake\RetroArch\retroarch.cfg
echo input_toggle_fast_forward_btn = "nul">> C:\RetroCake\RetroArch\retroarch.cfg
echo input_toggle_fast_forward_axis = "nul">> C:\RetroCake\RetroArch\retroarch.cfg
echo input_hold_fast_forward = "l">> C:\RetroCake\RetroArch\retroarch.cfg
echo input_hold_fast_forward_btn = "nul">> C:\RetroCake\RetroArch\retroarch.cfg
echo input_hold_fast_forward_axis = "nul">> C:\RetroCake\RetroArch\retroarch.cfg
echo input_load_state = "f4">> C:\RetroCake\RetroArch\retroarch.cfg
echo input_load_state_btn = "nul">> C:\RetroCake\RetroArch\retroarch.cfg
echo input_load_state_axis = "nul">> C:\RetroCake\RetroArch\retroarch.cfg
echo input_save_state = "f2">> C:\RetroCake\RetroArch\retroarch.cfg
echo input_save_state_btn = "nul">> C:\RetroCake\RetroArch\retroarch.cfg
echo input_save_state_axis = "nul">> C:\RetroCake\RetroArch\retroarch.cfg
echo input_toggle_fullscreen = "f">> C:\RetroCake\RetroArch\retroarch.cfg
echo input_toggle_fullscreen_btn = "nul">> C:\RetroCake\RetroArch\retroarch.cfg
echo input_toggle_fullscreen_axis = "nul">> C:\RetroCake\RetroArch\retroarch.cfg
echo input_exit_emulator = "escape">> C:\RetroCake\RetroArch\retroarch.cfg
echo input_exit_emulator_btn = "nul">> C:\RetroCake\RetroArch\retroarch.cfg
echo input_exit_emulator_axis = "nul">> C:\RetroCake\RetroArch\retroarch.cfg
echo input_state_slot_increase = "f7">> C:\RetroCake\RetroArch\retroarch.cfg
echo input_state_slot_increase_btn = "nul">> C:\RetroCake\RetroArch\retroarch.cfg
echo input_state_slot_increase_axis = "nul">> C:\RetroCake\RetroArch\retroarch.cfg
echo input_state_slot_decrease = "f6">> C:\RetroCake\RetroArch\retroarch.cfg
echo input_state_slot_decrease_btn = "nul">> C:\RetroCake\RetroArch\retroarch.cfg
echo input_state_slot_decrease_axis = "nul">> C:\RetroCake\RetroArch\retroarch.cfg
echo input_rewind = "r">> C:\RetroCake\RetroArch\retroarch.cfg
echo input_rewind_btn = "nul">> C:\RetroCake\RetroArch\retroarch.cfg
echo input_rewind_axis = "nul">> C:\RetroCake\RetroArch\retroarch.cfg
echo input_movie_record_toggle = "o">> C:\RetroCake\RetroArch\retroarch.cfg
echo input_movie_record_toggle_btn = "nul">> C:\RetroCake\RetroArch\retroarch.cfg
echo input_movie_record_toggle_axis = "nul">> C:\RetroCake\RetroArch\retroarch.cfg
echo input_pause_toggle = "p">> C:\RetroCake\RetroArch\retroarch.cfg
echo input_pause_toggle_btn = "nul">> C:\RetroCake\RetroArch\retroarch.cfg
echo input_pause_toggle_axis = "nul">> C:\RetroCake\RetroArch\retroarch.cfg
echo input_frame_advance = "k">> C:\RetroCake\RetroArch\retroarch.cfg
echo input_frame_advance_btn = "nul">> C:\RetroCake\RetroArch\retroarch.cfg
echo input_frame_advance_axis = "nul">> C:\RetroCake\RetroArch\retroarch.cfg
echo input_reset = "h">> C:\RetroCake\RetroArch\retroarch.cfg
echo input_reset_btn = "nul">> C:\RetroCake\RetroArch\retroarch.cfg
echo input_reset_axis = "nul">> C:\RetroCake\RetroArch\retroarch.cfg
echo input_shader_next = "m">> C:\RetroCake\RetroArch\retroarch.cfg
echo input_shader_next_btn = "nul">> C:\RetroCake\RetroArch\retroarch.cfg
echo input_shader_next_axis = "nul">> C:\RetroCake\RetroArch\retroarch.cfg
echo input_shader_prev = "n">> C:\RetroCake\RetroArch\retroarch.cfg
echo input_shader_prev_btn = "nul">> C:\RetroCake\RetroArch\retroarch.cfg
echo input_shader_prev_axis = "nul">> C:\RetroCake\RetroArch\retroarch.cfg
echo input_cheat_index_plus = "y">> C:\RetroCake\RetroArch\retroarch.cfg
echo input_cheat_index_plus_btn = "nul">> C:\RetroCake\RetroArch\retroarch.cfg
echo input_cheat_index_plus_axis = "nul">> C:\RetroCake\RetroArch\retroarch.cfg
echo input_cheat_index_minus = "t">> C:\RetroCake\RetroArch\retroarch.cfg
echo input_cheat_index_minus_btn = "nul">> C:\RetroCake\RetroArch\retroarch.cfg
echo input_cheat_index_minus_axis = "nul">> C:\RetroCake\RetroArch\retroarch.cfg
echo input_cheat_toggle = "u">> C:\RetroCake\RetroArch\retroarch.cfg
echo input_cheat_toggle_btn = "nul">> C:\RetroCake\RetroArch\retroarch.cfg
echo input_cheat_toggle_axis = "nul">> C:\RetroCake\RetroArch\retroarch.cfg
echo input_screenshot = "f8">> C:\RetroCake\RetroArch\retroarch.cfg
echo input_screenshot_btn = "nul">> C:\RetroCake\RetroArch\retroarch.cfg
echo input_screenshot_axis = "nul">> C:\RetroCake\RetroArch\retroarch.cfg
echo input_audio_mute = "f9">> C:\RetroCake\RetroArch\retroarch.cfg
echo input_audio_mute_btn = "nul">> C:\RetroCake\RetroArch\retroarch.cfg
echo input_audio_mute_axis = "nul">> C:\RetroCake\RetroArch\retroarch.cfg
echo input_osk_toggle = "f12">> C:\RetroCake\RetroArch\retroarch.cfg
echo input_osk_toggle_btn = "nul">> C:\RetroCake\RetroArch\retroarch.cfg
echo input_osk_toggle_axis = "nul">> C:\RetroCake\RetroArch\retroarch.cfg
echo input_netplay_flip_players_1_2 = "nul">> C:\RetroCake\RetroArch\retroarch.cfg
echo input_netplay_flip_players_1_2_btn = "nul">> C:\RetroCake\RetroArch\retroarch.cfg
echo input_netplay_flip_players_1_2_axis = "nul">> C:\RetroCake\RetroArch\retroarch.cfg
echo input_netplay_game_watch = "i">> C:\RetroCake\RetroArch\retroarch.cfg
echo input_netplay_game_watch_btn = "nul">> C:\RetroCake\RetroArch\retroarch.cfg
echo input_netplay_game_watch_axis = "nul">> C:\RetroCake\RetroArch\retroarch.cfg
echo input_slowmotion = "e">> C:\RetroCake\RetroArch\retroarch.cfg
echo input_slowmotion_btn = "nul">> C:\RetroCake\RetroArch\retroarch.cfg
echo input_slowmotion_axis = "nul">> C:\RetroCake\RetroArch\retroarch.cfg
echo input_enable_hotkey = "nul">> C:\RetroCake\RetroArch\retroarch.cfg
echo input_enable_hotkey_btn = "nul">> C:\RetroCake\RetroArch\retroarch.cfg
echo input_enable_hotkey_axis = "nul">> C:\RetroCake\RetroArch\retroarch.cfg
echo input_volume_up = "add">> C:\RetroCake\RetroArch\retroarch.cfg
echo input_volume_up_btn = "nul">> C:\RetroCake\RetroArch\retroarch.cfg
echo input_volume_up_axis = "nul">> C:\RetroCake\RetroArch\retroarch.cfg
echo input_volume_down = "subtract">> C:\RetroCake\RetroArch\retroarch.cfg
echo input_volume_down_btn = "nul">> C:\RetroCake\RetroArch\retroarch.cfg
echo input_volume_down_axis = "nul">> C:\RetroCake\RetroArch\retroarch.cfg
echo input_overlay_next = "nul">> C:\RetroCake\RetroArch\retroarch.cfg
echo input_overlay_next_btn = "nul">> C:\RetroCake\RetroArch\retroarch.cfg
echo input_overlay_next_axis = "nul">> C:\RetroCake\RetroArch\retroarch.cfg
echo input_disk_eject_toggle = "nul">> C:\RetroCake\RetroArch\retroarch.cfg
echo input_disk_eject_toggle_btn = "nul">> C:\RetroCake\RetroArch\retroarch.cfg
echo input_disk_eject_toggle_axis = "nul">> C:\RetroCake\RetroArch\retroarch.cfg
echo input_disk_next = "nul">> C:\RetroCake\RetroArch\retroarch.cfg
echo input_disk_next_btn = "nul">> C:\RetroCake\RetroArch\retroarch.cfg
echo input_disk_next_axis = "nul">> C:\RetroCake\RetroArch\retroarch.cfg
echo input_disk_prev = "nul">> C:\RetroCake\RetroArch\retroarch.cfg
echo input_disk_prev_btn = "nul">> C:\RetroCake\RetroArch\retroarch.cfg
echo input_disk_prev_axis = "nul">> C:\RetroCake\RetroArch\retroarch.cfg
echo input_grab_mouse_toggle = "f11">> C:\RetroCake\RetroArch\retroarch.cfg
echo input_grab_mouse_toggle_btn = "nul">> C:\RetroCake\RetroArch\retroarch.cfg
echo input_grab_mouse_toggle_axis = "nul">> C:\RetroCake\RetroArch\retroarch.cfg
echo input_game_focus_toggle = "scroll_lock">> C:\RetroCake\RetroArch\retroarch.cfg
echo input_game_focus_toggle_btn = "nul">> C:\RetroCake\RetroArch\retroarch.cfg
echo input_game_focus_toggle_axis = "nul">> C:\RetroCake\RetroArch\retroarch.cfg
echo input_menu_toggle = "f1">> C:\RetroCake\RetroArch\retroarch.cfg
echo input_menu_toggle_btn = "nul">> C:\RetroCake\RetroArch\retroarch.cfg
echo input_menu_toggle_axis = "nul">> C:\RetroCake\RetroArch\retroarch.cfg
echo input_player2_b = "nul">> C:\RetroCake\RetroArch\retroarch.cfg
echo input_player2_b_btn = "nul">> C:\RetroCake\RetroArch\retroarch.cfg
echo input_player2_b_axis = "nul">> C:\RetroCake\RetroArch\retroarch.cfg
echo input_player2_y = "nul">> C:\RetroCake\RetroArch\retroarch.cfg
echo input_player2_y_btn = "nul">> C:\RetroCake\RetroArch\retroarch.cfg
echo input_player2_y_axis = "nul">> C:\RetroCake\RetroArch\retroarch.cfg
echo input_player2_select = "nul">> C:\RetroCake\RetroArch\retroarch.cfg
echo input_player2_select_btn = "nul">> C:\RetroCake\RetroArch\retroarch.cfg
echo input_player2_select_axis = "nul">> C:\RetroCake\RetroArch\retroarch.cfg
echo input_player2_start = "nul">> C:\RetroCake\RetroArch\retroarch.cfg
echo input_player2_start_btn = "nul">> C:\RetroCake\RetroArch\retroarch.cfg
echo input_player2_start_axis = "nul">> C:\RetroCake\RetroArch\retroarch.cfg
echo input_player2_up = "nul">> C:\RetroCake\RetroArch\retroarch.cfg
echo input_player2_up_btn = "nul">> C:\RetroCake\RetroArch\retroarch.cfg
echo input_player2_up_axis = "nul">> C:\RetroCake\RetroArch\retroarch.cfg
echo input_player2_down = "nul">> C:\RetroCake\RetroArch\retroarch.cfg
echo input_player2_down_btn = "nul">> C:\RetroCake\RetroArch\retroarch.cfg
echo input_player2_down_axis = "nul">> C:\RetroCake\RetroArch\retroarch.cfg
echo input_player2_left = "nul">> C:\RetroCake\RetroArch\retroarch.cfg
echo input_player2_left_btn = "nul">> C:\RetroCake\RetroArch\retroarch.cfg
echo input_player2_left_axis = "nul">> C:\RetroCake\RetroArch\retroarch.cfg
echo input_player2_right = "nul">> C:\RetroCake\RetroArch\retroarch.cfg
echo input_player2_right_btn = "nul">> C:\RetroCake\RetroArch\retroarch.cfg
echo input_player2_right_axis = "nul">> C:\RetroCake\RetroArch\retroarch.cfg
echo input_player2_a = "nul">> C:\RetroCake\RetroArch\retroarch.cfg
echo input_player2_a_btn = "nul">> C:\RetroCake\RetroArch\retroarch.cfg
echo input_player2_a_axis = "nul">> C:\RetroCake\RetroArch\retroarch.cfg
echo input_player2_x = "nul">> C:\RetroCake\RetroArch\retroarch.cfg
echo input_player2_x_btn = "nul">> C:\RetroCake\RetroArch\retroarch.cfg
echo input_player2_x_axis = "nul">> C:\RetroCake\RetroArch\retroarch.cfg
echo input_player2_l = "nul">> C:\RetroCake\RetroArch\retroarch.cfg
echo input_player2_l_btn = "nul">> C:\RetroCake\RetroArch\retroarch.cfg
echo input_player2_l_axis = "nul">> C:\RetroCake\RetroArch\retroarch.cfg
echo input_player2_r = "nul">> C:\RetroCake\RetroArch\retroarch.cfg
echo input_player2_r_btn = "nul">> C:\RetroCake\RetroArch\retroarch.cfg
echo input_player2_r_axis = "nul">> C:\RetroCake\RetroArch\retroarch.cfg
echo input_player2_l2 = "nul">> C:\RetroCake\RetroArch\retroarch.cfg
echo input_player2_l2_btn = "nul">> C:\RetroCake\RetroArch\retroarch.cfg
echo input_player2_l2_axis = "nul">> C:\RetroCake\RetroArch\retroarch.cfg
echo input_player2_r2 = "nul">> C:\RetroCake\RetroArch\retroarch.cfg
echo input_player2_r2_btn = "nul">> C:\RetroCake\RetroArch\retroarch.cfg
echo input_player2_r2_axis = "nul">> C:\RetroCake\RetroArch\retroarch.cfg
echo input_player2_l3 = "nul">> C:\RetroCake\RetroArch\retroarch.cfg
echo input_player2_l3_btn = "nul">> C:\RetroCake\RetroArch\retroarch.cfg
echo input_player2_l3_axis = "nul">> C:\RetroCake\RetroArch\retroarch.cfg
echo input_player2_r3 = "nul">> C:\RetroCake\RetroArch\retroarch.cfg
echo input_player2_r3_btn = "nul">> C:\RetroCake\RetroArch\retroarch.cfg
echo input_player2_r3_axis = "nul">> C:\RetroCake\RetroArch\retroarch.cfg
echo input_player2_l_x_plus = "nul">> C:\RetroCake\RetroArch\retroarch.cfg
echo input_player2_l_x_plus_btn = "nul">> C:\RetroCake\RetroArch\retroarch.cfg
echo input_player2_l_x_plus_axis = "nul">> C:\RetroCake\RetroArch\retroarch.cfg
echo input_player2_l_x_minus = "nul">> C:\RetroCake\RetroArch\retroarch.cfg
echo input_player2_l_x_minus_btn = "nul">> C:\RetroCake\RetroArch\retroarch.cfg
echo input_player2_l_x_minus_axis = "nul">> C:\RetroCake\RetroArch\retroarch.cfg
echo input_player2_l_y_plus = "nul">> C:\RetroCake\RetroArch\retroarch.cfg
echo input_player2_l_y_plus_btn = "nul">> C:\RetroCake\RetroArch\retroarch.cfg
echo input_player2_l_y_plus_axis = "nul">> C:\RetroCake\RetroArch\retroarch.cfg
echo input_player2_l_y_minus = "nul">> C:\RetroCake\RetroArch\retroarch.cfg
echo input_player2_l_y_minus_btn = "nul">> C:\RetroCake\RetroArch\retroarch.cfg
echo input_player2_l_y_minus_axis = "nul">> C:\RetroCake\RetroArch\retroarch.cfg
echo input_player2_r_x_plus = "nul">> C:\RetroCake\RetroArch\retroarch.cfg
echo input_player2_r_x_plus_btn = "nul">> C:\RetroCake\RetroArch\retroarch.cfg
echo input_player2_r_x_plus_axis = "nul">> C:\RetroCake\RetroArch\retroarch.cfg
echo input_player2_r_x_minus = "nul">> C:\RetroCake\RetroArch\retroarch.cfg
echo input_player2_r_x_minus_btn = "nul">> C:\RetroCake\RetroArch\retroarch.cfg
echo input_player2_r_x_minus_axis = "nul">> C:\RetroCake\RetroArch\retroarch.cfg
echo input_player2_r_y_plus = "nul">> C:\RetroCake\RetroArch\retroarch.cfg
echo input_player2_r_y_plus_btn = "nul">> C:\RetroCake\RetroArch\retroarch.cfg
echo input_player2_r_y_plus_axis = "nul">> C:\RetroCake\RetroArch\retroarch.cfg
echo input_player2_r_y_minus = "nul">> C:\RetroCake\RetroArch\retroarch.cfg
echo input_player2_r_y_minus_btn = "nul">> C:\RetroCake\RetroArch\retroarch.cfg
echo input_player2_r_y_minus_axis = "nul">> C:\RetroCake\RetroArch\retroarch.cfg
echo input_player2_turbo = "nul">> C:\RetroCake\RetroArch\retroarch.cfg
echo input_player2_turbo_btn = "nul">> C:\RetroCake\RetroArch\retroarch.cfg
echo input_player2_turbo_axis = "nul">> C:\RetroCake\RetroArch\retroarch.cfg
echo input_player3_b = "nul">> C:\RetroCake\RetroArch\retroarch.cfg
echo input_player3_b_btn = "nul">> C:\RetroCake\RetroArch\retroarch.cfg
echo input_player3_b_axis = "nul">> C:\RetroCake\RetroArch\retroarch.cfg
echo input_player3_y = "nul">> C:\RetroCake\RetroArch\retroarch.cfg
echo input_player3_y_btn = "nul">> C:\RetroCake\RetroArch\retroarch.cfg
echo input_player3_y_axis = "nul">> C:\RetroCake\RetroArch\retroarch.cfg
echo input_player3_select = "nul">> C:\RetroCake\RetroArch\retroarch.cfg
echo input_player3_select_btn = "nul">> C:\RetroCake\RetroArch\retroarch.cfg
echo input_player3_select_axis = "nul">> C:\RetroCake\RetroArch\retroarch.cfg
echo input_player3_start = "nul">> C:\RetroCake\RetroArch\retroarch.cfg
echo input_player3_start_btn = "nul">> C:\RetroCake\RetroArch\retroarch.cfg
echo input_player3_start_axis = "nul">> C:\RetroCake\RetroArch\retroarch.cfg
echo input_player3_up = "nul">> C:\RetroCake\RetroArch\retroarch.cfg
echo input_player3_up_btn = "nul">> C:\RetroCake\RetroArch\retroarch.cfg
echo input_player3_up_axis = "nul">> C:\RetroCake\RetroArch\retroarch.cfg
echo input_player3_down = "nul">> C:\RetroCake\RetroArch\retroarch.cfg
echo input_player3_down_btn = "nul">> C:\RetroCake\RetroArch\retroarch.cfg
echo input_player3_down_axis = "nul">> C:\RetroCake\RetroArch\retroarch.cfg
echo input_player3_left = "nul">> C:\RetroCake\RetroArch\retroarch.cfg
echo input_player3_left_btn = "nul">> C:\RetroCake\RetroArch\retroarch.cfg
echo input_player3_left_axis = "nul">> C:\RetroCake\RetroArch\retroarch.cfg
echo input_player3_right = "nul">> C:\RetroCake\RetroArch\retroarch.cfg
echo input_player3_right_btn = "nul">> C:\RetroCake\RetroArch\retroarch.cfg
echo input_player3_right_axis = "nul">> C:\RetroCake\RetroArch\retroarch.cfg
echo input_player3_a = "nul">> C:\RetroCake\RetroArch\retroarch.cfg
echo input_player3_a_btn = "nul">> C:\RetroCake\RetroArch\retroarch.cfg
echo input_player3_a_axis = "nul">> C:\RetroCake\RetroArch\retroarch.cfg
echo input_player3_x = "nul">> C:\RetroCake\RetroArch\retroarch.cfg
echo input_player3_x_btn = "nul">> C:\RetroCake\RetroArch\retroarch.cfg
echo input_player3_x_axis = "nul">> C:\RetroCake\RetroArch\retroarch.cfg
echo input_player3_l = "nul">> C:\RetroCake\RetroArch\retroarch.cfg
echo input_player3_l_btn = "nul">> C:\RetroCake\RetroArch\retroarch.cfg
echo input_player3_l_axis = "nul">> C:\RetroCake\RetroArch\retroarch.cfg
echo input_player3_r = "nul">> C:\RetroCake\RetroArch\retroarch.cfg
echo input_player3_r_btn = "nul">> C:\RetroCake\RetroArch\retroarch.cfg
echo input_player3_r_axis = "nul">> C:\RetroCake\RetroArch\retroarch.cfg
echo input_player3_l2 = "nul">> C:\RetroCake\RetroArch\retroarch.cfg
echo input_player3_l2_btn = "nul">> C:\RetroCake\RetroArch\retroarch.cfg
echo input_player3_l2_axis = "nul">> C:\RetroCake\RetroArch\retroarch.cfg
echo input_player3_r2 = "nul">> C:\RetroCake\RetroArch\retroarch.cfg
echo input_player3_r2_btn = "nul">> C:\RetroCake\RetroArch\retroarch.cfg
echo input_player3_r2_axis = "nul">> C:\RetroCake\RetroArch\retroarch.cfg
echo input_player3_l3 = "nul">> C:\RetroCake\RetroArch\retroarch.cfg
echo input_player3_l3_btn = "nul">> C:\RetroCake\RetroArch\retroarch.cfg
echo input_player3_l3_axis = "nul">> C:\RetroCake\RetroArch\retroarch.cfg
echo input_player3_r3 = "nul">> C:\RetroCake\RetroArch\retroarch.cfg
echo input_player3_r3_btn = "nul">> C:\RetroCake\RetroArch\retroarch.cfg
echo input_player3_r3_axis = "nul">> C:\RetroCake\RetroArch\retroarch.cfg
echo input_player3_l_x_plus = "nul">> C:\RetroCake\RetroArch\retroarch.cfg
echo input_player3_l_x_plus_btn = "nul">> C:\RetroCake\RetroArch\retroarch.cfg
echo input_player3_l_x_plus_axis = "nul">> C:\RetroCake\RetroArch\retroarch.cfg
echo input_player3_l_x_minus = "nul">> C:\RetroCake\RetroArch\retroarch.cfg
echo input_player3_l_x_minus_btn = "nul">> C:\RetroCake\RetroArch\retroarch.cfg
echo input_player3_l_x_minus_axis = "nul">> C:\RetroCake\RetroArch\retroarch.cfg
echo input_player3_l_y_plus = "nul">> C:\RetroCake\RetroArch\retroarch.cfg
echo input_player3_l_y_plus_btn = "nul">> C:\RetroCake\RetroArch\retroarch.cfg
echo input_player3_l_y_plus_axis = "nul">> C:\RetroCake\RetroArch\retroarch.cfg
echo input_player3_l_y_minus = "nul">> C:\RetroCake\RetroArch\retroarch.cfg
echo input_player3_l_y_minus_btn = "nul">> C:\RetroCake\RetroArch\retroarch.cfg
echo input_player3_l_y_minus_axis = "nul">> C:\RetroCake\RetroArch\retroarch.cfg
echo input_player3_r_x_plus = "nul">> C:\RetroCake\RetroArch\retroarch.cfg
echo input_player3_r_x_plus_btn = "nul">> C:\RetroCake\RetroArch\retroarch.cfg
echo input_player3_r_x_plus_axis = "nul">> C:\RetroCake\RetroArch\retroarch.cfg
echo input_player3_r_x_minus = "nul">> C:\RetroCake\RetroArch\retroarch.cfg
echo input_player3_r_x_minus_btn = "nul">> C:\RetroCake\RetroArch\retroarch.cfg
echo input_player3_r_x_minus_axis = "nul">> C:\RetroCake\RetroArch\retroarch.cfg
echo input_player3_r_y_plus = "nul">> C:\RetroCake\RetroArch\retroarch.cfg
echo input_player3_r_y_plus_btn = "nul">> C:\RetroCake\RetroArch\retroarch.cfg
echo input_player3_r_y_plus_axis = "nul">> C:\RetroCake\RetroArch\retroarch.cfg
echo input_player3_r_y_minus = "nul">> C:\RetroCake\RetroArch\retroarch.cfg
echo input_player3_r_y_minus_btn = "nul">> C:\RetroCake\RetroArch\retroarch.cfg
echo input_player3_r_y_minus_axis = "nul">> C:\RetroCake\RetroArch\retroarch.cfg
echo input_player3_turbo = "nul">> C:\RetroCake\RetroArch\retroarch.cfg
echo input_player3_turbo_btn = "nul">> C:\RetroCake\RetroArch\retroarch.cfg
echo input_player3_turbo_axis = "nul">> C:\RetroCake\RetroArch\retroarch.cfg
echo input_player4_b = "nul">> C:\RetroCake\RetroArch\retroarch.cfg
echo input_player4_b_btn = "nul">> C:\RetroCake\RetroArch\retroarch.cfg
echo input_player4_b_axis = "nul">> C:\RetroCake\RetroArch\retroarch.cfg
echo input_player4_y = "nul">> C:\RetroCake\RetroArch\retroarch.cfg
echo input_player4_y_btn = "nul">> C:\RetroCake\RetroArch\retroarch.cfg
echo input_player4_y_axis = "nul">> C:\RetroCake\RetroArch\retroarch.cfg
echo input_player4_select = "nul">> C:\RetroCake\RetroArch\retroarch.cfg
echo input_player4_select_btn = "nul">> C:\RetroCake\RetroArch\retroarch.cfg
echo input_player4_select_axis = "nul">> C:\RetroCake\RetroArch\retroarch.cfg
echo input_player4_start = "nul">> C:\RetroCake\RetroArch\retroarch.cfg
echo input_player4_start_btn = "nul">> C:\RetroCake\RetroArch\retroarch.cfg
echo input_player4_start_axis = "nul">> C:\RetroCake\RetroArch\retroarch.cfg
echo input_player4_up = "nul">> C:\RetroCake\RetroArch\retroarch.cfg
echo input_player4_up_btn = "nul">> C:\RetroCake\RetroArch\retroarch.cfg
echo input_player4_up_axis = "nul">> C:\RetroCake\RetroArch\retroarch.cfg
echo input_player4_down = "nul">> C:\RetroCake\RetroArch\retroarch.cfg
echo input_player4_down_btn = "nul">> C:\RetroCake\RetroArch\retroarch.cfg
echo input_player4_down_axis = "nul">> C:\RetroCake\RetroArch\retroarch.cfg
echo input_player4_left = "nul">> C:\RetroCake\RetroArch\retroarch.cfg
echo input_player4_left_btn = "nul">> C:\RetroCake\RetroArch\retroarch.cfg
echo input_player4_left_axis = "nul">> C:\RetroCake\RetroArch\retroarch.cfg
echo input_player4_right = "nul">> C:\RetroCake\RetroArch\retroarch.cfg
echo input_player4_right_btn = "nul">> C:\RetroCake\RetroArch\retroarch.cfg
echo input_player4_right_axis = "nul">> C:\RetroCake\RetroArch\retroarch.cfg
echo input_player4_a = "nul">> C:\RetroCake\RetroArch\retroarch.cfg
echo input_player4_a_btn = "nul">> C:\RetroCake\RetroArch\retroarch.cfg
echo input_player4_a_axis = "nul">> C:\RetroCake\RetroArch\retroarch.cfg
echo input_player4_x = "nul">> C:\RetroCake\RetroArch\retroarch.cfg
echo input_player4_x_btn = "nul">> C:\RetroCake\RetroArch\retroarch.cfg
echo input_player4_x_axis = "nul">> C:\RetroCake\RetroArch\retroarch.cfg
echo input_player4_l = "nul">> C:\RetroCake\RetroArch\retroarch.cfg
echo input_player4_l_btn = "nul">> C:\RetroCake\RetroArch\retroarch.cfg
echo input_player4_l_axis = "nul">> C:\RetroCake\RetroArch\retroarch.cfg
echo input_player4_r = "nul">> C:\RetroCake\RetroArch\retroarch.cfg
echo input_player4_r_btn = "nul">> C:\RetroCake\RetroArch\retroarch.cfg
echo input_player4_r_axis = "nul">> C:\RetroCake\RetroArch\retroarch.cfg
echo input_player4_l2 = "nul">> C:\RetroCake\RetroArch\retroarch.cfg
echo input_player4_l2_btn = "nul">> C:\RetroCake\RetroArch\retroarch.cfg
echo input_player4_l2_axis = "nul">> C:\RetroCake\RetroArch\retroarch.cfg
echo input_player4_r2 = "nul">> C:\RetroCake\RetroArch\retroarch.cfg
echo input_player4_r2_btn = "nul">> C:\RetroCake\RetroArch\retroarch.cfg
echo input_player4_r2_axis = "nul">> C:\RetroCake\RetroArch\retroarch.cfg
echo input_player4_l3 = "nul">> C:\RetroCake\RetroArch\retroarch.cfg
echo input_player4_l3_btn = "nul">> C:\RetroCake\RetroArch\retroarch.cfg
echo input_player4_l3_axis = "nul">> C:\RetroCake\RetroArch\retroarch.cfg
echo input_player4_r3 = "nul">> C:\RetroCake\RetroArch\retroarch.cfg
echo input_player4_r3_btn = "nul">> C:\RetroCake\RetroArch\retroarch.cfg
echo input_player4_r3_axis = "nul">> C:\RetroCake\RetroArch\retroarch.cfg
echo input_player4_l_x_plus = "nul">> C:\RetroCake\RetroArch\retroarch.cfg
echo input_player4_l_x_plus_btn = "nul">> C:\RetroCake\RetroArch\retroarch.cfg
echo input_player4_l_x_plus_axis = "nul">> C:\RetroCake\RetroArch\retroarch.cfg
echo input_player4_l_x_minus = "nul">> C:\RetroCake\RetroArch\retroarch.cfg
echo input_player4_l_x_minus_btn = "nul">> C:\RetroCake\RetroArch\retroarch.cfg
echo input_player4_l_x_minus_axis = "nul">> C:\RetroCake\RetroArch\retroarch.cfg
echo input_player4_l_y_plus = "nul">> C:\RetroCake\RetroArch\retroarch.cfg
echo input_player4_l_y_plus_btn = "nul">> C:\RetroCake\RetroArch\retroarch.cfg
echo input_player4_l_y_plus_axis = "nul">> C:\RetroCake\RetroArch\retroarch.cfg
echo input_player4_l_y_minus = "nul">> C:\RetroCake\RetroArch\retroarch.cfg
echo input_player4_l_y_minus_btn = "nul">> C:\RetroCake\RetroArch\retroarch.cfg
echo input_player4_l_y_minus_axis = "nul">> C:\RetroCake\RetroArch\retroarch.cfg
echo input_player4_r_x_plus = "nul">> C:\RetroCake\RetroArch\retroarch.cfg
echo input_player4_r_x_plus_btn = "nul">> C:\RetroCake\RetroArch\retroarch.cfg
echo input_player4_r_x_plus_axis = "nul">> C:\RetroCake\RetroArch\retroarch.cfg
echo input_player4_r_x_minus = "nul">> C:\RetroCake\RetroArch\retroarch.cfg
echo input_player4_r_x_minus_btn = "nul">> C:\RetroCake\RetroArch\retroarch.cfg
echo input_player4_r_x_minus_axis = "nul">> C:\RetroCake\RetroArch\retroarch.cfg
echo input_player4_r_y_plus = "nul">> C:\RetroCake\RetroArch\retroarch.cfg
echo input_player4_r_y_plus_btn = "nul">> C:\RetroCake\RetroArch\retroarch.cfg
echo input_player4_r_y_plus_axis = "nul">> C:\RetroCake\RetroArch\retroarch.cfg
echo input_player4_r_y_minus = "nul">> C:\RetroCake\RetroArch\retroarch.cfg
echo input_player4_r_y_minus_btn = "nul">> C:\RetroCake\RetroArch\retroarch.cfg
echo input_player4_r_y_minus_axis = "nul">> C:\RetroCake\RetroArch\retroarch.cfg
echo input_player4_turbo = "nul">> C:\RetroCake\RetroArch\retroarch.cfg
echo input_player4_turbo_btn = "nul">> C:\RetroCake\RetroArch\retroarch.cfg
echo input_player4_turbo_axis = "nul">> C:\RetroCake\RetroArch\retroarch.cfg
echo input_player5_b = "nul">> C:\RetroCake\RetroArch\retroarch.cfg
echo input_player5_b_btn = "nul">> C:\RetroCake\RetroArch\retroarch.cfg
echo input_player5_b_axis = "nul">> C:\RetroCake\RetroArch\retroarch.cfg
echo input_player5_y = "nul">> C:\RetroCake\RetroArch\retroarch.cfg
echo input_player5_y_btn = "nul">> C:\RetroCake\RetroArch\retroarch.cfg
echo input_player5_y_axis = "nul">> C:\RetroCake\RetroArch\retroarch.cfg
echo input_player5_select = "nul">> C:\RetroCake\RetroArch\retroarch.cfg
echo input_player5_select_btn = "nul">> C:\RetroCake\RetroArch\retroarch.cfg
echo input_player5_select_axis = "nul">> C:\RetroCake\RetroArch\retroarch.cfg
echo input_player5_start = "nul">> C:\RetroCake\RetroArch\retroarch.cfg
echo input_player5_start_btn = "nul">> C:\RetroCake\RetroArch\retroarch.cfg
echo input_player5_start_axis = "nul">> C:\RetroCake\RetroArch\retroarch.cfg
echo input_player5_up = "nul">> C:\RetroCake\RetroArch\retroarch.cfg
echo input_player5_up_btn = "nul">> C:\RetroCake\RetroArch\retroarch.cfg
echo input_player5_up_axis = "nul">> C:\RetroCake\RetroArch\retroarch.cfg
echo input_player5_down = "nul">> C:\RetroCake\RetroArch\retroarch.cfg
echo input_player5_down_btn = "nul">> C:\RetroCake\RetroArch\retroarch.cfg
echo input_player5_down_axis = "nul">> C:\RetroCake\RetroArch\retroarch.cfg
echo input_player5_left = "nul">> C:\RetroCake\RetroArch\retroarch.cfg
echo input_player5_left_btn = "nul">> C:\RetroCake\RetroArch\retroarch.cfg
echo input_player5_left_axis = "nul">> C:\RetroCake\RetroArch\retroarch.cfg
echo input_player5_right = "nul">> C:\RetroCake\RetroArch\retroarch.cfg
echo input_player5_right_btn = "nul">> C:\RetroCake\RetroArch\retroarch.cfg
echo input_player5_right_axis = "nul">> C:\RetroCake\RetroArch\retroarch.cfg
echo input_player5_a = "nul">> C:\RetroCake\RetroArch\retroarch.cfg
echo input_player5_a_btn = "nul">> C:\RetroCake\RetroArch\retroarch.cfg
echo input_player5_a_axis = "nul">> C:\RetroCake\RetroArch\retroarch.cfg
echo input_player5_x = "nul">> C:\RetroCake\RetroArch\retroarch.cfg
echo input_player5_x_btn = "nul">> C:\RetroCake\RetroArch\retroarch.cfg
echo input_player5_x_axis = "nul">> C:\RetroCake\RetroArch\retroarch.cfg
echo input_player5_l = "nul">> C:\RetroCake\RetroArch\retroarch.cfg
echo input_player5_l_btn = "nul">> C:\RetroCake\RetroArch\retroarch.cfg
echo input_player5_l_axis = "nul">> C:\RetroCake\RetroArch\retroarch.cfg
echo input_player5_r = "nul">> C:\RetroCake\RetroArch\retroarch.cfg
echo input_player5_r_btn = "nul">> C:\RetroCake\RetroArch\retroarch.cfg
echo input_player5_r_axis = "nul">> C:\RetroCake\RetroArch\retroarch.cfg
echo input_player5_l2 = "nul">> C:\RetroCake\RetroArch\retroarch.cfg
echo input_player5_l2_btn = "nul">> C:\RetroCake\RetroArch\retroarch.cfg
echo input_player5_l2_axis = "nul">> C:\RetroCake\RetroArch\retroarch.cfg
echo input_player5_r2 = "nul">> C:\RetroCake\RetroArch\retroarch.cfg
echo input_player5_r2_btn = "nul">> C:\RetroCake\RetroArch\retroarch.cfg
echo input_player5_r2_axis = "nul">> C:\RetroCake\RetroArch\retroarch.cfg
echo input_player5_l3 = "nul">> C:\RetroCake\RetroArch\retroarch.cfg
echo input_player5_l3_btn = "nul">> C:\RetroCake\RetroArch\retroarch.cfg
echo input_player5_l3_axis = "nul">> C:\RetroCake\RetroArch\retroarch.cfg
echo input_player5_r3 = "nul">> C:\RetroCake\RetroArch\retroarch.cfg
echo input_player5_r3_btn = "nul">> C:\RetroCake\RetroArch\retroarch.cfg
echo input_player5_r3_axis = "nul">> C:\RetroCake\RetroArch\retroarch.cfg
echo input_player5_l_x_plus = "nul">> C:\RetroCake\RetroArch\retroarch.cfg
echo input_player5_l_x_plus_btn = "nul">> C:\RetroCake\RetroArch\retroarch.cfg
echo input_player5_l_x_plus_axis = "nul">> C:\RetroCake\RetroArch\retroarch.cfg
echo input_player5_l_x_minus = "nul">> C:\RetroCake\RetroArch\retroarch.cfg
echo input_player5_l_x_minus_btn = "nul">> C:\RetroCake\RetroArch\retroarch.cfg
echo input_player5_l_x_minus_axis = "nul">> C:\RetroCake\RetroArch\retroarch.cfg
echo input_player5_l_y_plus = "nul">> C:\RetroCake\RetroArch\retroarch.cfg
echo input_player5_l_y_plus_btn = "nul">> C:\RetroCake\RetroArch\retroarch.cfg
echo input_player5_l_y_plus_axis = "nul">> C:\RetroCake\RetroArch\retroarch.cfg
echo input_player5_l_y_minus = "nul">> C:\RetroCake\RetroArch\retroarch.cfg
echo input_player5_l_y_minus_btn = "nul">> C:\RetroCake\RetroArch\retroarch.cfg
echo input_player5_l_y_minus_axis = "nul">> C:\RetroCake\RetroArch\retroarch.cfg
echo input_player5_r_x_plus = "nul">> C:\RetroCake\RetroArch\retroarch.cfg
echo input_player5_r_x_plus_btn = "nul">> C:\RetroCake\RetroArch\retroarch.cfg
echo input_player5_r_x_plus_axis = "nul">> C:\RetroCake\RetroArch\retroarch.cfg
echo input_player5_r_x_minus = "nul">> C:\RetroCake\RetroArch\retroarch.cfg
echo input_player5_r_x_minus_btn = "nul">> C:\RetroCake\RetroArch\retroarch.cfg
echo input_player5_r_x_minus_axis = "nul">> C:\RetroCake\RetroArch\retroarch.cfg
echo input_player5_r_y_plus = "nul">> C:\RetroCake\RetroArch\retroarch.cfg
echo input_player5_r_y_plus_btn = "nul">> C:\RetroCake\RetroArch\retroarch.cfg
echo input_player5_r_y_plus_axis = "nul">> C:\RetroCake\RetroArch\retroarch.cfg
echo input_player5_r_y_minus = "nul">> C:\RetroCake\RetroArch\retroarch.cfg
echo input_player5_r_y_minus_btn = "nul">> C:\RetroCake\RetroArch\retroarch.cfg
echo input_player5_r_y_minus_axis = "nul">> C:\RetroCake\RetroArch\retroarch.cfg
echo input_player5_turbo = "nul">> C:\RetroCake\RetroArch\retroarch.cfg
echo input_player5_turbo_btn = "nul">> C:\RetroCake\RetroArch\retroarch.cfg
echo input_player5_turbo_axis = "nul">> C:\RetroCake\RetroArch\retroarch.cfg
echo input_player6_b = "nul">> C:\RetroCake\RetroArch\retroarch.cfg
echo input_player6_b_btn = "nul">> C:\RetroCake\RetroArch\retroarch.cfg
echo input_player6_b_axis = "nul">> C:\RetroCake\RetroArch\retroarch.cfg
echo input_player6_y = "nul">> C:\RetroCake\RetroArch\retroarch.cfg
echo input_player6_y_btn = "nul">> C:\RetroCake\RetroArch\retroarch.cfg
echo input_player6_y_axis = "nul">> C:\RetroCake\RetroArch\retroarch.cfg
echo input_player6_select = "nul">> C:\RetroCake\RetroArch\retroarch.cfg
echo input_player6_select_btn = "nul">> C:\RetroCake\RetroArch\retroarch.cfg
echo input_player6_select_axis = "nul">> C:\RetroCake\RetroArch\retroarch.cfg
echo input_player6_start = "nul">> C:\RetroCake\RetroArch\retroarch.cfg
echo input_player6_start_btn = "nul">> C:\RetroCake\RetroArch\retroarch.cfg
echo input_player6_start_axis = "nul">> C:\RetroCake\RetroArch\retroarch.cfg
echo input_player6_up = "nul">> C:\RetroCake\RetroArch\retroarch.cfg
echo input_player6_up_btn = "nul">> C:\RetroCake\RetroArch\retroarch.cfg
echo input_player6_up_axis = "nul">> C:\RetroCake\RetroArch\retroarch.cfg
echo input_player6_down = "nul">> C:\RetroCake\RetroArch\retroarch.cfg
echo input_player6_down_btn = "nul">> C:\RetroCake\RetroArch\retroarch.cfg
echo input_player6_down_axis = "nul">> C:\RetroCake\RetroArch\retroarch.cfg
echo input_player6_left = "nul">> C:\RetroCake\RetroArch\retroarch.cfg
echo input_player6_left_btn = "nul">> C:\RetroCake\RetroArch\retroarch.cfg
echo input_player6_left_axis = "nul">> C:\RetroCake\RetroArch\retroarch.cfg
echo input_player6_right = "nul">> C:\RetroCake\RetroArch\retroarch.cfg
echo input_player6_right_btn = "nul">> C:\RetroCake\RetroArch\retroarch.cfg
echo input_player6_right_axis = "nul">> C:\RetroCake\RetroArch\retroarch.cfg
echo input_player6_a = "nul">> C:\RetroCake\RetroArch\retroarch.cfg
echo input_player6_a_btn = "nul">> C:\RetroCake\RetroArch\retroarch.cfg
echo input_player6_a_axis = "nul">> C:\RetroCake\RetroArch\retroarch.cfg
echo input_player6_x = "nul">> C:\RetroCake\RetroArch\retroarch.cfg
echo input_player6_x_btn = "nul">> C:\RetroCake\RetroArch\retroarch.cfg
echo input_player6_x_axis = "nul">> C:\RetroCake\RetroArch\retroarch.cfg
echo input_player6_l = "nul">> C:\RetroCake\RetroArch\retroarch.cfg
echo input_player6_l_btn = "nul">> C:\RetroCake\RetroArch\retroarch.cfg
echo input_player6_l_axis = "nul">> C:\RetroCake\RetroArch\retroarch.cfg
echo input_player6_r = "nul">> C:\RetroCake\RetroArch\retroarch.cfg
echo input_player6_r_btn = "nul">> C:\RetroCake\RetroArch\retroarch.cfg
echo input_player6_r_axis = "nul">> C:\RetroCake\RetroArch\retroarch.cfg
echo input_player6_l2 = "nul">> C:\RetroCake\RetroArch\retroarch.cfg
echo input_player6_l2_btn = "nul">> C:\RetroCake\RetroArch\retroarch.cfg
echo input_player6_l2_axis = "nul">> C:\RetroCake\RetroArch\retroarch.cfg
echo input_player6_r2 = "nul">> C:\RetroCake\RetroArch\retroarch.cfg
echo input_player6_r2_btn = "nul">> C:\RetroCake\RetroArch\retroarch.cfg
echo input_player6_r2_axis = "nul">> C:\RetroCake\RetroArch\retroarch.cfg
echo input_player6_l3 = "nul">> C:\RetroCake\RetroArch\retroarch.cfg
echo input_player6_l3_btn = "nul">> C:\RetroCake\RetroArch\retroarch.cfg
echo input_player6_l3_axis = "nul">> C:\RetroCake\RetroArch\retroarch.cfg
echo input_player6_r3 = "nul">> C:\RetroCake\RetroArch\retroarch.cfg
echo input_player6_r3_btn = "nul">> C:\RetroCake\RetroArch\retroarch.cfg
echo input_player6_r3_axis = "nul">> C:\RetroCake\RetroArch\retroarch.cfg
echo input_player6_l_x_plus = "nul">> C:\RetroCake\RetroArch\retroarch.cfg
echo input_player6_l_x_plus_btn = "nul">> C:\RetroCake\RetroArch\retroarch.cfg
echo input_player6_l_x_plus_axis = "nul">> C:\RetroCake\RetroArch\retroarch.cfg
echo input_player6_l_x_minus = "nul">> C:\RetroCake\RetroArch\retroarch.cfg
echo input_player6_l_x_minus_btn = "nul">> C:\RetroCake\RetroArch\retroarch.cfg
echo input_player6_l_x_minus_axis = "nul">> C:\RetroCake\RetroArch\retroarch.cfg
echo input_player6_l_y_plus = "nul">> C:\RetroCake\RetroArch\retroarch.cfg
echo input_player6_l_y_plus_btn = "nul">> C:\RetroCake\RetroArch\retroarch.cfg
echo input_player6_l_y_plus_axis = "nul">> C:\RetroCake\RetroArch\retroarch.cfg
echo input_player6_l_y_minus = "nul">> C:\RetroCake\RetroArch\retroarch.cfg
echo input_player6_l_y_minus_btn = "nul">> C:\RetroCake\RetroArch\retroarch.cfg
echo input_player6_l_y_minus_axis = "nul">> C:\RetroCake\RetroArch\retroarch.cfg
echo input_player6_r_x_plus = "nul">> C:\RetroCake\RetroArch\retroarch.cfg
echo input_player6_r_x_plus_btn = "nul">> C:\RetroCake\RetroArch\retroarch.cfg
echo input_player6_r_x_plus_axis = "nul">> C:\RetroCake\RetroArch\retroarch.cfg
echo input_player6_r_x_minus = "nul">> C:\RetroCake\RetroArch\retroarch.cfg
echo input_player6_r_x_minus_btn = "nul">> C:\RetroCake\RetroArch\retroarch.cfg
echo input_player6_r_x_minus_axis = "nul">> C:\RetroCake\RetroArch\retroarch.cfg
echo input_player6_r_y_plus = "nul">> C:\RetroCake\RetroArch\retroarch.cfg
echo input_player6_r_y_plus_btn = "nul">> C:\RetroCake\RetroArch\retroarch.cfg
echo input_player6_r_y_plus_axis = "nul">> C:\RetroCake\RetroArch\retroarch.cfg
echo input_player6_r_y_minus = "nul">> C:\RetroCake\RetroArch\retroarch.cfg
echo input_player6_r_y_minus_btn = "nul">> C:\RetroCake\RetroArch\retroarch.cfg
echo input_player6_r_y_minus_axis = "nul">> C:\RetroCake\RetroArch\retroarch.cfg
echo input_player6_turbo = "nul">> C:\RetroCake\RetroArch\retroarch.cfg
echo input_player6_turbo_btn = "nul">> C:\RetroCake\RetroArch\retroarch.cfg
echo input_player6_turbo_axis = "nul">> C:\RetroCake\RetroArch\retroarch.cfg
echo input_player7_b = "nul">> C:\RetroCake\RetroArch\retroarch.cfg
echo input_player7_b_btn = "nul">> C:\RetroCake\RetroArch\retroarch.cfg
echo input_player7_b_axis = "nul">> C:\RetroCake\RetroArch\retroarch.cfg
echo input_player7_y = "nul">> C:\RetroCake\RetroArch\retroarch.cfg
echo input_player7_y_btn = "nul">> C:\RetroCake\RetroArch\retroarch.cfg
echo input_player7_y_axis = "nul">> C:\RetroCake\RetroArch\retroarch.cfg
echo input_player7_select = "nul">> C:\RetroCake\RetroArch\retroarch.cfg
echo input_player7_select_btn = "nul">> C:\RetroCake\RetroArch\retroarch.cfg
echo input_player7_select_axis = "nul">> C:\RetroCake\RetroArch\retroarch.cfg
echo input_player7_start = "nul">> C:\RetroCake\RetroArch\retroarch.cfg
echo input_player7_start_btn = "nul">> C:\RetroCake\RetroArch\retroarch.cfg
echo input_player7_start_axis = "nul">> C:\RetroCake\RetroArch\retroarch.cfg
echo input_player7_up = "nul">> C:\RetroCake\RetroArch\retroarch.cfg
echo input_player7_up_btn = "nul">> C:\RetroCake\RetroArch\retroarch.cfg
echo input_player7_up_axis = "nul">> C:\RetroCake\RetroArch\retroarch.cfg
echo input_player7_down = "nul">> C:\RetroCake\RetroArch\retroarch.cfg
echo input_player7_down_btn = "nul">> C:\RetroCake\RetroArch\retroarch.cfg
echo input_player7_down_axis = "nul">> C:\RetroCake\RetroArch\retroarch.cfg
echo input_player7_left = "nul">> C:\RetroCake\RetroArch\retroarch.cfg
echo input_player7_left_btn = "nul">> C:\RetroCake\RetroArch\retroarch.cfg
echo input_player7_left_axis = "nul">> C:\RetroCake\RetroArch\retroarch.cfg
echo input_player7_right = "nul">> C:\RetroCake\RetroArch\retroarch.cfg
echo input_player7_right_btn = "nul">> C:\RetroCake\RetroArch\retroarch.cfg
echo input_player7_right_axis = "nul">> C:\RetroCake\RetroArch\retroarch.cfg
echo input_player7_a = "nul">> C:\RetroCake\RetroArch\retroarch.cfg
echo input_player7_a_btn = "nul">> C:\RetroCake\RetroArch\retroarch.cfg
echo input_player7_a_axis = "nul">> C:\RetroCake\RetroArch\retroarch.cfg
echo input_player7_x = "nul">> C:\RetroCake\RetroArch\retroarch.cfg
echo input_player7_x_btn = "nul">> C:\RetroCake\RetroArch\retroarch.cfg
echo input_player7_x_axis = "nul">> C:\RetroCake\RetroArch\retroarch.cfg
echo input_player7_l = "nul">> C:\RetroCake\RetroArch\retroarch.cfg
echo input_player7_l_btn = "nul">> C:\RetroCake\RetroArch\retroarch.cfg
echo input_player7_l_axis = "nul">> C:\RetroCake\RetroArch\retroarch.cfg
echo input_player7_r = "nul">> C:\RetroCake\RetroArch\retroarch.cfg
echo input_player7_r_btn = "nul">> C:\RetroCake\RetroArch\retroarch.cfg
echo input_player7_r_axis = "nul">> C:\RetroCake\RetroArch\retroarch.cfg
echo input_player7_l2 = "nul">> C:\RetroCake\RetroArch\retroarch.cfg
echo input_player7_l2_btn = "nul">> C:\RetroCake\RetroArch\retroarch.cfg
echo input_player7_l2_axis = "nul">> C:\RetroCake\RetroArch\retroarch.cfg
echo input_player7_r2 = "nul">> C:\RetroCake\RetroArch\retroarch.cfg
echo input_player7_r2_btn = "nul">> C:\RetroCake\RetroArch\retroarch.cfg
echo input_player7_r2_axis = "nul">> C:\RetroCake\RetroArch\retroarch.cfg
echo input_player7_l3 = "nul">> C:\RetroCake\RetroArch\retroarch.cfg
echo input_player7_l3_btn = "nul">> C:\RetroCake\RetroArch\retroarch.cfg
echo input_player7_l3_axis = "nul">> C:\RetroCake\RetroArch\retroarch.cfg
echo input_player7_r3 = "nul">> C:\RetroCake\RetroArch\retroarch.cfg
echo input_player7_r3_btn = "nul">> C:\RetroCake\RetroArch\retroarch.cfg
echo input_player7_r3_axis = "nul">> C:\RetroCake\RetroArch\retroarch.cfg
echo input_player7_l_x_plus = "nul">> C:\RetroCake\RetroArch\retroarch.cfg
echo input_player7_l_x_plus_btn = "nul">> C:\RetroCake\RetroArch\retroarch.cfg
echo input_player7_l_x_plus_axis = "nul">> C:\RetroCake\RetroArch\retroarch.cfg
echo input_player7_l_x_minus = "nul">> C:\RetroCake\RetroArch\retroarch.cfg
echo input_player7_l_x_minus_btn = "nul">> C:\RetroCake\RetroArch\retroarch.cfg
echo input_player7_l_x_minus_axis = "nul">> C:\RetroCake\RetroArch\retroarch.cfg
echo input_player7_l_y_plus = "nul">> C:\RetroCake\RetroArch\retroarch.cfg
echo input_player7_l_y_plus_btn = "nul">> C:\RetroCake\RetroArch\retroarch.cfg
echo input_player7_l_y_plus_axis = "nul">> C:\RetroCake\RetroArch\retroarch.cfg
echo input_player7_l_y_minus = "nul">> C:\RetroCake\RetroArch\retroarch.cfg
echo input_player7_l_y_minus_btn = "nul">> C:\RetroCake\RetroArch\retroarch.cfg
echo input_player7_l_y_minus_axis = "nul">> C:\RetroCake\RetroArch\retroarch.cfg
echo input_player7_r_x_plus = "nul">> C:\RetroCake\RetroArch\retroarch.cfg
echo input_player7_r_x_plus_btn = "nul">> C:\RetroCake\RetroArch\retroarch.cfg
echo input_player7_r_x_plus_axis = "nul">> C:\RetroCake\RetroArch\retroarch.cfg
echo input_player7_r_x_minus = "nul">> C:\RetroCake\RetroArch\retroarch.cfg
echo input_player7_r_x_minus_btn = "nul">> C:\RetroCake\RetroArch\retroarch.cfg
echo input_player7_r_x_minus_axis = "nul">> C:\RetroCake\RetroArch\retroarch.cfg
echo input_player7_r_y_plus = "nul">> C:\RetroCake\RetroArch\retroarch.cfg
echo input_player7_r_y_plus_btn = "nul">> C:\RetroCake\RetroArch\retroarch.cfg
echo input_player7_r_y_plus_axis = "nul">> C:\RetroCake\RetroArch\retroarch.cfg
echo input_player7_r_y_minus = "nul">> C:\RetroCake\RetroArch\retroarch.cfg
echo input_player7_r_y_minus_btn = "nul">> C:\RetroCake\RetroArch\retroarch.cfg
echo input_player7_r_y_minus_axis = "nul">> C:\RetroCake\RetroArch\retroarch.cfg
echo input_player7_turbo = "nul">> C:\RetroCake\RetroArch\retroarch.cfg
echo input_player7_turbo_btn = "nul">> C:\RetroCake\RetroArch\retroarch.cfg
echo input_player7_turbo_axis = "nul">> C:\RetroCake\RetroArch\retroarch.cfg
echo input_player8_b = "nul">> C:\RetroCake\RetroArch\retroarch.cfg
echo input_player8_b_btn = "nul">> C:\RetroCake\RetroArch\retroarch.cfg
echo input_player8_b_axis = "nul">> C:\RetroCake\RetroArch\retroarch.cfg
echo input_player8_y = "nul">> C:\RetroCake\RetroArch\retroarch.cfg
echo input_player8_y_btn = "nul">> C:\RetroCake\RetroArch\retroarch.cfg
echo input_player8_y_axis = "nul">> C:\RetroCake\RetroArch\retroarch.cfg
echo input_player8_select = "nul">> C:\RetroCake\RetroArch\retroarch.cfg
echo input_player8_select_btn = "nul">> C:\RetroCake\RetroArch\retroarch.cfg
echo input_player8_select_axis = "nul">> C:\RetroCake\RetroArch\retroarch.cfg
echo input_player8_start = "nul">> C:\RetroCake\RetroArch\retroarch.cfg
echo input_player8_start_btn = "nul">> C:\RetroCake\RetroArch\retroarch.cfg
echo input_player8_start_axis = "nul">> C:\RetroCake\RetroArch\retroarch.cfg
echo input_player8_up = "nul">> C:\RetroCake\RetroArch\retroarch.cfg
echo input_player8_up_btn = "nul">> C:\RetroCake\RetroArch\retroarch.cfg
echo input_player8_up_axis = "nul">> C:\RetroCake\RetroArch\retroarch.cfg
echo input_player8_down = "nul">> C:\RetroCake\RetroArch\retroarch.cfg
echo input_player8_down_btn = "nul">> C:\RetroCake\RetroArch\retroarch.cfg
echo input_player8_down_axis = "nul">> C:\RetroCake\RetroArch\retroarch.cfg
echo input_player8_left = "nul">> C:\RetroCake\RetroArch\retroarch.cfg
echo input_player8_left_btn = "nul">> C:\RetroCake\RetroArch\retroarch.cfg
echo input_player8_left_axis = "nul">> C:\RetroCake\RetroArch\retroarch.cfg
echo input_player8_right = "nul">> C:\RetroCake\RetroArch\retroarch.cfg
echo input_player8_right_btn = "nul">> C:\RetroCake\RetroArch\retroarch.cfg
echo input_player8_right_axis = "nul">> C:\RetroCake\RetroArch\retroarch.cfg
echo input_player8_a = "nul">> C:\RetroCake\RetroArch\retroarch.cfg
echo input_player8_a_btn = "nul">> C:\RetroCake\RetroArch\retroarch.cfg
echo input_player8_a_axis = "nul">> C:\RetroCake\RetroArch\retroarch.cfg
echo input_player8_x = "nul">> C:\RetroCake\RetroArch\retroarch.cfg
echo input_player8_x_btn = "nul">> C:\RetroCake\RetroArch\retroarch.cfg
echo input_player8_x_axis = "nul">> C:\RetroCake\RetroArch\retroarch.cfg
echo input_player8_l = "nul">> C:\RetroCake\RetroArch\retroarch.cfg
echo input_player8_l_btn = "nul">> C:\RetroCake\RetroArch\retroarch.cfg
echo input_player8_l_axis = "nul">> C:\RetroCake\RetroArch\retroarch.cfg
echo input_player8_r = "nul">> C:\RetroCake\RetroArch\retroarch.cfg
echo input_player8_r_btn = "nul">> C:\RetroCake\RetroArch\retroarch.cfg
echo input_player8_r_axis = "nul">> C:\RetroCake\RetroArch\retroarch.cfg
echo input_player8_l2 = "nul">> C:\RetroCake\RetroArch\retroarch.cfg
echo input_player8_l2_btn = "nul">> C:\RetroCake\RetroArch\retroarch.cfg
echo input_player8_l2_axis = "nul">> C:\RetroCake\RetroArch\retroarch.cfg
echo input_player8_r2 = "nul">> C:\RetroCake\RetroArch\retroarch.cfg
echo input_player8_r2_btn = "nul">> C:\RetroCake\RetroArch\retroarch.cfg
echo input_player8_r2_axis = "nul">> C:\RetroCake\RetroArch\retroarch.cfg
echo input_player8_l3 = "nul">> C:\RetroCake\RetroArch\retroarch.cfg
echo input_player8_l3_btn = "nul">> C:\RetroCake\RetroArch\retroarch.cfg
echo input_player8_l3_axis = "nul">> C:\RetroCake\RetroArch\retroarch.cfg
echo input_player8_r3 = "nul">> C:\RetroCake\RetroArch\retroarch.cfg
echo input_player8_r3_btn = "nul">> C:\RetroCake\RetroArch\retroarch.cfg
echo input_player8_r3_axis = "nul">> C:\RetroCake\RetroArch\retroarch.cfg
echo input_player8_l_x_plus = "nul">> C:\RetroCake\RetroArch\retroarch.cfg
echo input_player8_l_x_plus_btn = "nul">> C:\RetroCake\RetroArch\retroarch.cfg
echo input_player8_l_x_plus_axis = "nul">> C:\RetroCake\RetroArch\retroarch.cfg
echo input_player8_l_x_minus = "nul">> C:\RetroCake\RetroArch\retroarch.cfg
echo input_player8_l_x_minus_btn = "nul">> C:\RetroCake\RetroArch\retroarch.cfg
echo input_player8_l_x_minus_axis = "nul">> C:\RetroCake\RetroArch\retroarch.cfg
echo input_player8_l_y_plus = "nul">> C:\RetroCake\RetroArch\retroarch.cfg
echo input_player8_l_y_plus_btn = "nul">> C:\RetroCake\RetroArch\retroarch.cfg
echo input_player8_l_y_plus_axis = "nul">> C:\RetroCake\RetroArch\retroarch.cfg
echo input_player8_l_y_minus = "nul">> C:\RetroCake\RetroArch\retroarch.cfg
echo input_player8_l_y_minus_btn = "nul">> C:\RetroCake\RetroArch\retroarch.cfg
echo input_player8_l_y_minus_axis = "nul">> C:\RetroCake\RetroArch\retroarch.cfg
echo input_player8_r_x_plus = "nul">> C:\RetroCake\RetroArch\retroarch.cfg
echo input_player8_r_x_plus_btn = "nul">> C:\RetroCake\RetroArch\retroarch.cfg
echo input_player8_r_x_plus_axis = "nul">> C:\RetroCake\RetroArch\retroarch.cfg
echo input_player8_r_x_minus = "nul">> C:\RetroCake\RetroArch\retroarch.cfg
echo input_player8_r_x_minus_btn = "nul">> C:\RetroCake\RetroArch\retroarch.cfg
echo input_player8_r_x_minus_axis = "nul">> C:\RetroCake\RetroArch\retroarch.cfg
echo input_player8_r_y_plus = "nul">> C:\RetroCake\RetroArch\retroarch.cfg
echo input_player8_r_y_plus_btn = "nul">> C:\RetroCake\RetroArch\retroarch.cfg
echo input_player8_r_y_plus_axis = "nul">> C:\RetroCake\RetroArch\retroarch.cfg
echo input_player8_r_y_minus = "nul">> C:\RetroCake\RetroArch\retroarch.cfg
echo input_player8_r_y_minus_btn = "nul">> C:\RetroCake\RetroArch\retroarch.cfg
echo input_player8_r_y_minus_axis = "nul">> C:\RetroCake\RetroArch\retroarch.cfg
echo input_player8_turbo = "nul">> C:\RetroCake\RetroArch\retroarch.cfg
echo input_player8_turbo_btn = "nul">> C:\RetroCake\RetroArch\retroarch.cfg
echo input_player8_turbo_axis = "nul">> C:\RetroCake\RetroArch\retroarch.cfg
echo input_player9_b = "nul">> C:\RetroCake\RetroArch\retroarch.cfg
echo input_player9_b_btn = "nul">> C:\RetroCake\RetroArch\retroarch.cfg
echo input_player9_b_axis = "nul">> C:\RetroCake\RetroArch\retroarch.cfg
echo input_player9_y = "nul">> C:\RetroCake\RetroArch\retroarch.cfg
echo input_player9_y_btn = "nul">> C:\RetroCake\RetroArch\retroarch.cfg
echo input_player9_y_axis = "nul">> C:\RetroCake\RetroArch\retroarch.cfg
echo input_player9_select = "nul">> C:\RetroCake\RetroArch\retroarch.cfg
echo input_player9_select_btn = "nul">> C:\RetroCake\RetroArch\retroarch.cfg
echo input_player9_select_axis = "nul">> C:\RetroCake\RetroArch\retroarch.cfg
echo input_player9_start = "nul">> C:\RetroCake\RetroArch\retroarch.cfg
echo input_player9_start_btn = "nul">> C:\RetroCake\RetroArch\retroarch.cfg
echo input_player9_start_axis = "nul">> C:\RetroCake\RetroArch\retroarch.cfg
echo input_player9_up = "nul">> C:\RetroCake\RetroArch\retroarch.cfg
echo input_player9_up_btn = "nul">> C:\RetroCake\RetroArch\retroarch.cfg
echo input_player9_up_axis = "nul">> C:\RetroCake\RetroArch\retroarch.cfg
echo input_player9_down = "nul">> C:\RetroCake\RetroArch\retroarch.cfg
echo input_player9_down_btn = "nul">> C:\RetroCake\RetroArch\retroarch.cfg
echo input_player9_down_axis = "nul">> C:\RetroCake\RetroArch\retroarch.cfg
echo input_player9_left = "nul">> C:\RetroCake\RetroArch\retroarch.cfg
echo input_player9_left_btn = "nul">> C:\RetroCake\RetroArch\retroarch.cfg
echo input_player9_left_axis = "nul">> C:\RetroCake\RetroArch\retroarch.cfg
echo input_player9_right = "nul">> C:\RetroCake\RetroArch\retroarch.cfg
echo input_player9_right_btn = "nul">> C:\RetroCake\RetroArch\retroarch.cfg
echo input_player9_right_axis = "nul">> C:\RetroCake\RetroArch\retroarch.cfg
echo input_player9_a = "nul">> C:\RetroCake\RetroArch\retroarch.cfg
echo input_player9_a_btn = "nul">> C:\RetroCake\RetroArch\retroarch.cfg
echo input_player9_a_axis = "nul">> C:\RetroCake\RetroArch\retroarch.cfg
echo input_player9_x = "nul">> C:\RetroCake\RetroArch\retroarch.cfg
echo input_player9_x_btn = "nul">> C:\RetroCake\RetroArch\retroarch.cfg
echo input_player9_x_axis = "nul">> C:\RetroCake\RetroArch\retroarch.cfg
echo input_player9_l = "nul">> C:\RetroCake\RetroArch\retroarch.cfg
echo input_player9_l_btn = "nul">> C:\RetroCake\RetroArch\retroarch.cfg
echo input_player9_l_axis = "nul">> C:\RetroCake\RetroArch\retroarch.cfg
echo input_player9_r = "nul">> C:\RetroCake\RetroArch\retroarch.cfg
echo input_player9_r_btn = "nul">> C:\RetroCake\RetroArch\retroarch.cfg
echo input_player9_r_axis = "nul">> C:\RetroCake\RetroArch\retroarch.cfg
echo input_player9_l2 = "nul">> C:\RetroCake\RetroArch\retroarch.cfg
echo input_player9_l2_btn = "nul">> C:\RetroCake\RetroArch\retroarch.cfg
echo input_player9_l2_axis = "nul">> C:\RetroCake\RetroArch\retroarch.cfg
echo input_player9_r2 = "nul">> C:\RetroCake\RetroArch\retroarch.cfg
echo input_player9_r2_btn = "nul">> C:\RetroCake\RetroArch\retroarch.cfg
echo input_player9_r2_axis = "nul">> C:\RetroCake\RetroArch\retroarch.cfg
echo input_player9_l3 = "nul">> C:\RetroCake\RetroArch\retroarch.cfg
echo input_player9_l3_btn = "nul">> C:\RetroCake\RetroArch\retroarch.cfg
echo input_player9_l3_axis = "nul">> C:\RetroCake\RetroArch\retroarch.cfg
echo input_player9_r3 = "nul">> C:\RetroCake\RetroArch\retroarch.cfg
echo input_player9_r3_btn = "nul">> C:\RetroCake\RetroArch\retroarch.cfg
echo input_player9_r3_axis = "nul">> C:\RetroCake\RetroArch\retroarch.cfg
echo input_player9_l_x_plus = "nul">> C:\RetroCake\RetroArch\retroarch.cfg
echo input_player9_l_x_plus_btn = "nul">> C:\RetroCake\RetroArch\retroarch.cfg
echo input_player9_l_x_plus_axis = "nul">> C:\RetroCake\RetroArch\retroarch.cfg
echo input_player9_l_x_minus = "nul">> C:\RetroCake\RetroArch\retroarch.cfg
echo input_player9_l_x_minus_btn = "nul">> C:\RetroCake\RetroArch\retroarch.cfg
echo input_player9_l_x_minus_axis = "nul">> C:\RetroCake\RetroArch\retroarch.cfg
echo input_player9_l_y_plus = "nul">> C:\RetroCake\RetroArch\retroarch.cfg
echo input_player9_l_y_plus_btn = "nul">> C:\RetroCake\RetroArch\retroarch.cfg
echo input_player9_l_y_plus_axis = "nul">> C:\RetroCake\RetroArch\retroarch.cfg
echo input_player9_l_y_minus = "nul">> C:\RetroCake\RetroArch\retroarch.cfg
echo input_player9_l_y_minus_btn = "nul">> C:\RetroCake\RetroArch\retroarch.cfg
echo input_player9_l_y_minus_axis = "nul">> C:\RetroCake\RetroArch\retroarch.cfg
echo input_player9_r_x_plus = "nul">> C:\RetroCake\RetroArch\retroarch.cfg
echo input_player9_r_x_plus_btn = "nul">> C:\RetroCake\RetroArch\retroarch.cfg
echo input_player9_r_x_plus_axis = "nul">> C:\RetroCake\RetroArch\retroarch.cfg
echo input_player9_r_x_minus = "nul">> C:\RetroCake\RetroArch\retroarch.cfg
echo input_player9_r_x_minus_btn = "nul">> C:\RetroCake\RetroArch\retroarch.cfg
echo input_player9_r_x_minus_axis = "nul">> C:\RetroCake\RetroArch\retroarch.cfg
echo input_player9_r_y_plus = "nul">> C:\RetroCake\RetroArch\retroarch.cfg
echo input_player9_r_y_plus_btn = "nul">> C:\RetroCake\RetroArch\retroarch.cfg
echo input_player9_r_y_plus_axis = "nul">> C:\RetroCake\RetroArch\retroarch.cfg
echo input_player9_r_y_minus = "nul">> C:\RetroCake\RetroArch\retroarch.cfg
echo input_player9_r_y_minus_btn = "nul">> C:\RetroCake\RetroArch\retroarch.cfg
echo input_player9_r_y_minus_axis = "nul">> C:\RetroCake\RetroArch\retroarch.cfg
echo input_player9_turbo = "nul">> C:\RetroCake\RetroArch\retroarch.cfg
echo input_player9_turbo_btn = "nul">> C:\RetroCake\RetroArch\retroarch.cfg
echo input_player9_turbo_axis = "nul">> C:\RetroCake\RetroArch\retroarch.cfg
echo input_player10_b = "nul">> C:\RetroCake\RetroArch\retroarch.cfg
echo input_player10_b_btn = "nul">> C:\RetroCake\RetroArch\retroarch.cfg
echo input_player10_b_axis = "nul">> C:\RetroCake\RetroArch\retroarch.cfg
echo input_player10_y = "nul">> C:\RetroCake\RetroArch\retroarch.cfg
echo input_player10_y_btn = "nul">> C:\RetroCake\RetroArch\retroarch.cfg
echo input_player10_y_axis = "nul">> C:\RetroCake\RetroArch\retroarch.cfg
echo input_player10_select = "nul">> C:\RetroCake\RetroArch\retroarch.cfg
echo input_player10_select_btn = "nul">> C:\RetroCake\RetroArch\retroarch.cfg
echo input_player10_select_axis = "nul">> C:\RetroCake\RetroArch\retroarch.cfg
echo input_player10_start = "nul">> C:\RetroCake\RetroArch\retroarch.cfg
echo input_player10_start_btn = "nul">> C:\RetroCake\RetroArch\retroarch.cfg
echo input_player10_start_axis = "nul">> C:\RetroCake\RetroArch\retroarch.cfg
echo input_player10_up = "nul">> C:\RetroCake\RetroArch\retroarch.cfg
echo input_player10_up_btn = "nul">> C:\RetroCake\RetroArch\retroarch.cfg
echo input_player10_up_axis = "nul">> C:\RetroCake\RetroArch\retroarch.cfg
echo input_player10_down = "nul">> C:\RetroCake\RetroArch\retroarch.cfg
echo input_player10_down_btn = "nul">> C:\RetroCake\RetroArch\retroarch.cfg
echo input_player10_down_axis = "nul">> C:\RetroCake\RetroArch\retroarch.cfg
echo input_player10_left = "nul">> C:\RetroCake\RetroArch\retroarch.cfg
echo input_player10_left_btn = "nul">> C:\RetroCake\RetroArch\retroarch.cfg
echo input_player10_left_axis = "nul">> C:\RetroCake\RetroArch\retroarch.cfg
echo input_player10_right = "nul">> C:\RetroCake\RetroArch\retroarch.cfg
echo input_player10_right_btn = "nul">> C:\RetroCake\RetroArch\retroarch.cfg
echo input_player10_right_axis = "nul">> C:\RetroCake\RetroArch\retroarch.cfg
echo input_player10_a = "nul">> C:\RetroCake\RetroArch\retroarch.cfg
echo input_player10_a_btn = "nul">> C:\RetroCake\RetroArch\retroarch.cfg
echo input_player10_a_axis = "nul">> C:\RetroCake\RetroArch\retroarch.cfg
echo input_player10_x = "nul">> C:\RetroCake\RetroArch\retroarch.cfg
echo input_player10_x_btn = "nul">> C:\RetroCake\RetroArch\retroarch.cfg
echo input_player10_x_axis = "nul">> C:\RetroCake\RetroArch\retroarch.cfg
echo input_player10_l = "nul">> C:\RetroCake\RetroArch\retroarch.cfg
echo input_player10_l_btn = "nul">> C:\RetroCake\RetroArch\retroarch.cfg
echo input_player10_l_axis = "nul">> C:\RetroCake\RetroArch\retroarch.cfg
echo input_player10_r = "nul">> C:\RetroCake\RetroArch\retroarch.cfg
echo input_player10_r_btn = "nul">> C:\RetroCake\RetroArch\retroarch.cfg
echo input_player10_r_axis = "nul">> C:\RetroCake\RetroArch\retroarch.cfg
echo input_player10_l2 = "nul">> C:\RetroCake\RetroArch\retroarch.cfg
echo input_player10_l2_btn = "nul">> C:\RetroCake\RetroArch\retroarch.cfg
echo input_player10_l2_axis = "nul">> C:\RetroCake\RetroArch\retroarch.cfg
echo input_player10_r2 = "nul">> C:\RetroCake\RetroArch\retroarch.cfg
echo input_player10_r2_btn = "nul">> C:\RetroCake\RetroArch\retroarch.cfg
echo input_player10_r2_axis = "nul">> C:\RetroCake\RetroArch\retroarch.cfg
echo input_player10_l3 = "nul">> C:\RetroCake\RetroArch\retroarch.cfg
echo input_player10_l3_btn = "nul">> C:\RetroCake\RetroArch\retroarch.cfg
echo input_player10_l3_axis = "nul">> C:\RetroCake\RetroArch\retroarch.cfg
echo input_player10_r3 = "nul">> C:\RetroCake\RetroArch\retroarch.cfg
echo input_player10_r3_btn = "nul">> C:\RetroCake\RetroArch\retroarch.cfg
echo input_player10_r3_axis = "nul">> C:\RetroCake\RetroArch\retroarch.cfg
echo input_player10_l_x_plus = "nul">> C:\RetroCake\RetroArch\retroarch.cfg
echo input_player10_l_x_plus_btn = "nul">> C:\RetroCake\RetroArch\retroarch.cfg
echo input_player10_l_x_plus_axis = "nul">> C:\RetroCake\RetroArch\retroarch.cfg
echo input_player10_l_x_minus = "nul">> C:\RetroCake\RetroArch\retroarch.cfg
echo input_player10_l_x_minus_btn = "nul">> C:\RetroCake\RetroArch\retroarch.cfg
echo input_player10_l_x_minus_axis = "nul">> C:\RetroCake\RetroArch\retroarch.cfg
echo input_player10_l_y_plus = "nul">> C:\RetroCake\RetroArch\retroarch.cfg
echo input_player10_l_y_plus_btn = "nul">> C:\RetroCake\RetroArch\retroarch.cfg
echo input_player10_l_y_plus_axis = "nul">> C:\RetroCake\RetroArch\retroarch.cfg
echo input_player10_l_y_minus = "nul">> C:\RetroCake\RetroArch\retroarch.cfg
echo input_player10_l_y_minus_btn = "nul">> C:\RetroCake\RetroArch\retroarch.cfg
echo input_player10_l_y_minus_axis = "nul">> C:\RetroCake\RetroArch\retroarch.cfg
echo input_player10_r_x_plus = "nul">> C:\RetroCake\RetroArch\retroarch.cfg
echo input_player10_r_x_plus_btn = "nul">> C:\RetroCake\RetroArch\retroarch.cfg
echo input_player10_r_x_plus_axis = "nul">> C:\RetroCake\RetroArch\retroarch.cfg
echo input_player10_r_x_minus = "nul">> C:\RetroCake\RetroArch\retroarch.cfg
echo input_player10_r_x_minus_btn = "nul">> C:\RetroCake\RetroArch\retroarch.cfg
echo input_player10_r_x_minus_axis = "nul">> C:\RetroCake\RetroArch\retroarch.cfg
echo input_player10_r_y_plus = "nul">> C:\RetroCake\RetroArch\retroarch.cfg
echo input_player10_r_y_plus_btn = "nul">> C:\RetroCake\RetroArch\retroarch.cfg
echo input_player10_r_y_plus_axis = "nul">> C:\RetroCake\RetroArch\retroarch.cfg
echo input_player10_r_y_minus = "nul">> C:\RetroCake\RetroArch\retroarch.cfg
echo input_player10_r_y_minus_btn = "nul">> C:\RetroCake\RetroArch\retroarch.cfg
echo input_player10_r_y_minus_axis = "nul">> C:\RetroCake\RetroArch\retroarch.cfg
echo input_player10_turbo = "nul">> C:\RetroCake\RetroArch\retroarch.cfg
echo input_player10_turbo_btn = "nul">> C:\RetroCake\RetroArch\retroarch.cfg
echo input_player10_turbo_axis = "nul">> C:\RetroCake\RetroArch\retroarch.cfg
echo input_player11_b = "nul">> C:\RetroCake\RetroArch\retroarch.cfg
echo input_player11_b_btn = "nul">> C:\RetroCake\RetroArch\retroarch.cfg
echo input_player11_b_axis = "nul">> C:\RetroCake\RetroArch\retroarch.cfg
echo input_player11_y = "nul">> C:\RetroCake\RetroArch\retroarch.cfg
echo input_player11_y_btn = "nul">> C:\RetroCake\RetroArch\retroarch.cfg
echo input_player11_y_axis = "nul">> C:\RetroCake\RetroArch\retroarch.cfg
echo input_player11_select = "nul">> C:\RetroCake\RetroArch\retroarch.cfg
echo input_player11_select_btn = "nul">> C:\RetroCake\RetroArch\retroarch.cfg
echo input_player11_select_axis = "nul">> C:\RetroCake\RetroArch\retroarch.cfg
echo input_player11_start = "nul">> C:\RetroCake\RetroArch\retroarch.cfg
echo input_player11_start_btn = "nul">> C:\RetroCake\RetroArch\retroarch.cfg
echo input_player11_start_axis = "nul">> C:\RetroCake\RetroArch\retroarch.cfg
echo input_player11_up = "nul">> C:\RetroCake\RetroArch\retroarch.cfg
echo input_player11_up_btn = "nul">> C:\RetroCake\RetroArch\retroarch.cfg
echo input_player11_up_axis = "nul">> C:\RetroCake\RetroArch\retroarch.cfg
echo input_player11_down = "nul">> C:\RetroCake\RetroArch\retroarch.cfg
echo input_player11_down_btn = "nul">> C:\RetroCake\RetroArch\retroarch.cfg
echo input_player11_down_axis = "nul">> C:\RetroCake\RetroArch\retroarch.cfg
echo input_player11_left = "nul">> C:\RetroCake\RetroArch\retroarch.cfg
echo input_player11_left_btn = "nul">> C:\RetroCake\RetroArch\retroarch.cfg
echo input_player11_left_axis = "nul">> C:\RetroCake\RetroArch\retroarch.cfg
echo input_player11_right = "nul">> C:\RetroCake\RetroArch\retroarch.cfg
echo input_player11_right_btn = "nul">> C:\RetroCake\RetroArch\retroarch.cfg
echo input_player11_right_axis = "nul">> C:\RetroCake\RetroArch\retroarch.cfg
echo input_player11_a = "nul">> C:\RetroCake\RetroArch\retroarch.cfg
echo input_player11_a_btn = "nul">> C:\RetroCake\RetroArch\retroarch.cfg
echo input_player11_a_axis = "nul">> C:\RetroCake\RetroArch\retroarch.cfg
echo input_player11_x = "nul">> C:\RetroCake\RetroArch\retroarch.cfg
echo input_player11_x_btn = "nul">> C:\RetroCake\RetroArch\retroarch.cfg
echo input_player11_x_axis = "nul">> C:\RetroCake\RetroArch\retroarch.cfg
echo input_player11_l = "nul">> C:\RetroCake\RetroArch\retroarch.cfg
echo input_player11_l_btn = "nul">> C:\RetroCake\RetroArch\retroarch.cfg
echo input_player11_l_axis = "nul">> C:\RetroCake\RetroArch\retroarch.cfg
echo input_player11_r = "nul">> C:\RetroCake\RetroArch\retroarch.cfg
echo input_player11_r_btn = "nul">> C:\RetroCake\RetroArch\retroarch.cfg
echo input_player11_r_axis = "nul">> C:\RetroCake\RetroArch\retroarch.cfg
echo input_player11_l2 = "nul">> C:\RetroCake\RetroArch\retroarch.cfg
echo input_player11_l2_btn = "nul">> C:\RetroCake\RetroArch\retroarch.cfg
echo input_player11_l2_axis = "nul">> C:\RetroCake\RetroArch\retroarch.cfg
echo input_player11_r2 = "nul">> C:\RetroCake\RetroArch\retroarch.cfg
echo input_player11_r2_btn = "nul">> C:\RetroCake\RetroArch\retroarch.cfg
echo input_player11_r2_axis = "nul">> C:\RetroCake\RetroArch\retroarch.cfg
echo input_player11_l3 = "nul">> C:\RetroCake\RetroArch\retroarch.cfg
echo input_player11_l3_btn = "nul">> C:\RetroCake\RetroArch\retroarch.cfg
echo input_player11_l3_axis = "nul">> C:\RetroCake\RetroArch\retroarch.cfg
echo input_player11_r3 = "nul">> C:\RetroCake\RetroArch\retroarch.cfg
echo input_player11_r3_btn = "nul">> C:\RetroCake\RetroArch\retroarch.cfg
echo input_player11_r3_axis = "nul">> C:\RetroCake\RetroArch\retroarch.cfg
echo input_player11_l_x_plus = "nul">> C:\RetroCake\RetroArch\retroarch.cfg
echo input_player11_l_x_plus_btn = "nul">> C:\RetroCake\RetroArch\retroarch.cfg
echo input_player11_l_x_plus_axis = "nul">> C:\RetroCake\RetroArch\retroarch.cfg
echo input_player11_l_x_minus = "nul">> C:\RetroCake\RetroArch\retroarch.cfg
echo input_player11_l_x_minus_btn = "nul">> C:\RetroCake\RetroArch\retroarch.cfg
echo input_player11_l_x_minus_axis = "nul">> C:\RetroCake\RetroArch\retroarch.cfg
echo input_player11_l_y_plus = "nul">> C:\RetroCake\RetroArch\retroarch.cfg
echo input_player11_l_y_plus_btn = "nul">> C:\RetroCake\RetroArch\retroarch.cfg
echo input_player11_l_y_plus_axis = "nul">> C:\RetroCake\RetroArch\retroarch.cfg
echo input_player11_l_y_minus = "nul">> C:\RetroCake\RetroArch\retroarch.cfg
echo input_player11_l_y_minus_btn = "nul">> C:\RetroCake\RetroArch\retroarch.cfg
echo input_player11_l_y_minus_axis = "nul">> C:\RetroCake\RetroArch\retroarch.cfg
echo input_player11_r_x_plus = "nul">> C:\RetroCake\RetroArch\retroarch.cfg
echo input_player11_r_x_plus_btn = "nul">> C:\RetroCake\RetroArch\retroarch.cfg
echo input_player11_r_x_plus_axis = "nul">> C:\RetroCake\RetroArch\retroarch.cfg
echo input_player11_r_x_minus = "nul">> C:\RetroCake\RetroArch\retroarch.cfg
echo input_player11_r_x_minus_btn = "nul">> C:\RetroCake\RetroArch\retroarch.cfg
echo input_player11_r_x_minus_axis = "nul">> C:\RetroCake\RetroArch\retroarch.cfg
echo input_player11_r_y_plus = "nul">> C:\RetroCake\RetroArch\retroarch.cfg
echo input_player11_r_y_plus_btn = "nul">> C:\RetroCake\RetroArch\retroarch.cfg
echo input_player11_r_y_plus_axis = "nul">> C:\RetroCake\RetroArch\retroarch.cfg
echo input_player11_r_y_minus = "nul">> C:\RetroCake\RetroArch\retroarch.cfg
echo input_player11_r_y_minus_btn = "nul">> C:\RetroCake\RetroArch\retroarch.cfg
echo input_player11_r_y_minus_axis = "nul">> C:\RetroCake\RetroArch\retroarch.cfg
echo input_player11_turbo = "nul">> C:\RetroCake\RetroArch\retroarch.cfg
echo input_player11_turbo_btn = "nul">> C:\RetroCake\RetroArch\retroarch.cfg
echo input_player11_turbo_axis = "nul">> C:\RetroCake\RetroArch\retroarch.cfg
echo input_player12_b = "nul">> C:\RetroCake\RetroArch\retroarch.cfg
echo input_player12_b_btn = "nul">> C:\RetroCake\RetroArch\retroarch.cfg
echo input_player12_b_axis = "nul">> C:\RetroCake\RetroArch\retroarch.cfg
echo input_player12_y = "nul">> C:\RetroCake\RetroArch\retroarch.cfg
echo input_player12_y_btn = "nul">> C:\RetroCake\RetroArch\retroarch.cfg
echo input_player12_y_axis = "nul">> C:\RetroCake\RetroArch\retroarch.cfg
echo input_player12_select = "nul">> C:\RetroCake\RetroArch\retroarch.cfg
echo input_player12_select_btn = "nul">> C:\RetroCake\RetroArch\retroarch.cfg
echo input_player12_select_axis = "nul">> C:\RetroCake\RetroArch\retroarch.cfg
echo input_player12_start = "nul">> C:\RetroCake\RetroArch\retroarch.cfg
echo input_player12_start_btn = "nul">> C:\RetroCake\RetroArch\retroarch.cfg
echo input_player12_start_axis = "nul">> C:\RetroCake\RetroArch\retroarch.cfg
echo input_player12_up = "nul">> C:\RetroCake\RetroArch\retroarch.cfg
echo input_player12_up_btn = "nul">> C:\RetroCake\RetroArch\retroarch.cfg
echo input_player12_up_axis = "nul">> C:\RetroCake\RetroArch\retroarch.cfg
echo input_player12_down = "nul">> C:\RetroCake\RetroArch\retroarch.cfg
echo input_player12_down_btn = "nul">> C:\RetroCake\RetroArch\retroarch.cfg
echo input_player12_down_axis = "nul">> C:\RetroCake\RetroArch\retroarch.cfg
echo input_player12_left = "nul">> C:\RetroCake\RetroArch\retroarch.cfg
echo input_player12_left_btn = "nul">> C:\RetroCake\RetroArch\retroarch.cfg
echo input_player12_left_axis = "nul">> C:\RetroCake\RetroArch\retroarch.cfg
echo input_player12_right = "nul">> C:\RetroCake\RetroArch\retroarch.cfg
echo input_player12_right_btn = "nul">> C:\RetroCake\RetroArch\retroarch.cfg
echo input_player12_right_axis = "nul">> C:\RetroCake\RetroArch\retroarch.cfg
echo input_player12_a = "nul">> C:\RetroCake\RetroArch\retroarch.cfg
echo input_player12_a_btn = "nul">> C:\RetroCake\RetroArch\retroarch.cfg
echo input_player12_a_axis = "nul">> C:\RetroCake\RetroArch\retroarch.cfg
echo input_player12_x = "nul">> C:\RetroCake\RetroArch\retroarch.cfg
echo input_player12_x_btn = "nul">> C:\RetroCake\RetroArch\retroarch.cfg
echo input_player12_x_axis = "nul">> C:\RetroCake\RetroArch\retroarch.cfg
echo input_player12_l = "nul">> C:\RetroCake\RetroArch\retroarch.cfg
echo input_player12_l_btn = "nul">> C:\RetroCake\RetroArch\retroarch.cfg
echo input_player12_l_axis = "nul">> C:\RetroCake\RetroArch\retroarch.cfg
echo input_player12_r = "nul">> C:\RetroCake\RetroArch\retroarch.cfg
echo input_player12_r_btn = "nul">> C:\RetroCake\RetroArch\retroarch.cfg
echo input_player12_r_axis = "nul">> C:\RetroCake\RetroArch\retroarch.cfg
echo input_player12_l2 = "nul">> C:\RetroCake\RetroArch\retroarch.cfg
echo input_player12_l2_btn = "nul">> C:\RetroCake\RetroArch\retroarch.cfg
echo input_player12_l2_axis = "nul">> C:\RetroCake\RetroArch\retroarch.cfg
echo input_player12_r2 = "nul">> C:\RetroCake\RetroArch\retroarch.cfg
echo input_player12_r2_btn = "nul">> C:\RetroCake\RetroArch\retroarch.cfg
echo input_player12_r2_axis = "nul">> C:\RetroCake\RetroArch\retroarch.cfg
echo input_player12_l3 = "nul">> C:\RetroCake\RetroArch\retroarch.cfg
echo input_player12_l3_btn = "nul">> C:\RetroCake\RetroArch\retroarch.cfg
echo input_player12_l3_axis = "nul">> C:\RetroCake\RetroArch\retroarch.cfg
echo input_player12_r3 = "nul">> C:\RetroCake\RetroArch\retroarch.cfg
echo input_player12_r3_btn = "nul">> C:\RetroCake\RetroArch\retroarch.cfg
echo input_player12_r3_axis = "nul">> C:\RetroCake\RetroArch\retroarch.cfg
echo input_player12_l_x_plus = "nul">> C:\RetroCake\RetroArch\retroarch.cfg
echo input_player12_l_x_plus_btn = "nul">> C:\RetroCake\RetroArch\retroarch.cfg
echo input_player12_l_x_plus_axis = "nul">> C:\RetroCake\RetroArch\retroarch.cfg
echo input_player12_l_x_minus = "nul">> C:\RetroCake\RetroArch\retroarch.cfg
echo input_player12_l_x_minus_btn = "nul">> C:\RetroCake\RetroArch\retroarch.cfg
echo input_player12_l_x_minus_axis = "nul">> C:\RetroCake\RetroArch\retroarch.cfg
echo input_player12_l_y_plus = "nul">> C:\RetroCake\RetroArch\retroarch.cfg
echo input_player12_l_y_plus_btn = "nul">> C:\RetroCake\RetroArch\retroarch.cfg
echo input_player12_l_y_plus_axis = "nul">> C:\RetroCake\RetroArch\retroarch.cfg
echo input_player12_l_y_minus = "nul">> C:\RetroCake\RetroArch\retroarch.cfg
echo input_player12_l_y_minus_btn = "nul">> C:\RetroCake\RetroArch\retroarch.cfg
echo input_player12_l_y_minus_axis = "nul">> C:\RetroCake\RetroArch\retroarch.cfg
echo input_player12_r_x_plus = "nul">> C:\RetroCake\RetroArch\retroarch.cfg
echo input_player12_r_x_plus_btn = "nul">> C:\RetroCake\RetroArch\retroarch.cfg
echo input_player12_r_x_plus_axis = "nul">> C:\RetroCake\RetroArch\retroarch.cfg
echo input_player12_r_x_minus = "nul">> C:\RetroCake\RetroArch\retroarch.cfg
echo input_player12_r_x_minus_btn = "nul">> C:\RetroCake\RetroArch\retroarch.cfg
echo input_player12_r_x_minus_axis = "nul">> C:\RetroCake\RetroArch\retroarch.cfg
echo input_player12_r_y_plus = "nul">> C:\RetroCake\RetroArch\retroarch.cfg
echo input_player12_r_y_plus_btn = "nul">> C:\RetroCake\RetroArch\retroarch.cfg
echo input_player12_r_y_plus_axis = "nul">> C:\RetroCake\RetroArch\retroarch.cfg
echo input_player12_r_y_minus = "nul">> C:\RetroCake\RetroArch\retroarch.cfg
echo input_player12_r_y_minus_btn = "nul">> C:\RetroCake\RetroArch\retroarch.cfg
echo input_player12_r_y_minus_axis = "nul">> C:\RetroCake\RetroArch\retroarch.cfg
echo input_player12_turbo = "nul">> C:\RetroCake\RetroArch\retroarch.cfg
echo input_player12_turbo_btn = "nul">> C:\RetroCake\RetroArch\retroarch.cfg
echo input_player12_turbo_axis = "nul">> C:\RetroCake\RetroArch\retroarch.cfg
echo input_player13_b = "nul">> C:\RetroCake\RetroArch\retroarch.cfg
echo input_player13_b_btn = "nul">> C:\RetroCake\RetroArch\retroarch.cfg
echo input_player13_b_axis = "nul">> C:\RetroCake\RetroArch\retroarch.cfg
echo input_player13_y = "nul">> C:\RetroCake\RetroArch\retroarch.cfg
echo input_player13_y_btn = "nul">> C:\RetroCake\RetroArch\retroarch.cfg
echo input_player13_y_axis = "nul">> C:\RetroCake\RetroArch\retroarch.cfg
echo input_player13_select = "nul">> C:\RetroCake\RetroArch\retroarch.cfg
echo input_player13_select_btn = "nul">> C:\RetroCake\RetroArch\retroarch.cfg
echo input_player13_select_axis = "nul">> C:\RetroCake\RetroArch\retroarch.cfg
echo input_player13_start = "nul">> C:\RetroCake\RetroArch\retroarch.cfg
echo input_player13_start_btn = "nul">> C:\RetroCake\RetroArch\retroarch.cfg
echo input_player13_start_axis = "nul">> C:\RetroCake\RetroArch\retroarch.cfg
echo input_player13_up = "nul">> C:\RetroCake\RetroArch\retroarch.cfg
echo input_player13_up_btn = "nul">> C:\RetroCake\RetroArch\retroarch.cfg
echo input_player13_up_axis = "nul">> C:\RetroCake\RetroArch\retroarch.cfg
echo input_player13_down = "nul">> C:\RetroCake\RetroArch\retroarch.cfg
echo input_player13_down_btn = "nul">> C:\RetroCake\RetroArch\retroarch.cfg
echo input_player13_down_axis = "nul">> C:\RetroCake\RetroArch\retroarch.cfg
echo input_player13_left = "nul">> C:\RetroCake\RetroArch\retroarch.cfg
echo input_player13_left_btn = "nul">> C:\RetroCake\RetroArch\retroarch.cfg
echo input_player13_left_axis = "nul">> C:\RetroCake\RetroArch\retroarch.cfg
echo input_player13_right = "nul">> C:\RetroCake\RetroArch\retroarch.cfg
echo input_player13_right_btn = "nul">> C:\RetroCake\RetroArch\retroarch.cfg
echo input_player13_right_axis = "nul">> C:\RetroCake\RetroArch\retroarch.cfg
echo input_player13_a = "nul">> C:\RetroCake\RetroArch\retroarch.cfg
echo input_player13_a_btn = "nul">> C:\RetroCake\RetroArch\retroarch.cfg
echo input_player13_a_axis = "nul">> C:\RetroCake\RetroArch\retroarch.cfg
echo input_player13_x = "nul">> C:\RetroCake\RetroArch\retroarch.cfg
echo input_player13_x_btn = "nul">> C:\RetroCake\RetroArch\retroarch.cfg
echo input_player13_x_axis = "nul">> C:\RetroCake\RetroArch\retroarch.cfg
echo input_player13_l = "nul">> C:\RetroCake\RetroArch\retroarch.cfg
echo input_player13_l_btn = "nul">> C:\RetroCake\RetroArch\retroarch.cfg
echo input_player13_l_axis = "nul">> C:\RetroCake\RetroArch\retroarch.cfg
echo input_player13_r = "nul">> C:\RetroCake\RetroArch\retroarch.cfg
echo input_player13_r_btn = "nul">> C:\RetroCake\RetroArch\retroarch.cfg
echo input_player13_r_axis = "nul">> C:\RetroCake\RetroArch\retroarch.cfg
echo input_player13_l2 = "nul">> C:\RetroCake\RetroArch\retroarch.cfg
echo input_player13_l2_btn = "nul">> C:\RetroCake\RetroArch\retroarch.cfg
echo input_player13_l2_axis = "nul">> C:\RetroCake\RetroArch\retroarch.cfg
echo input_player13_r2 = "nul">> C:\RetroCake\RetroArch\retroarch.cfg
echo input_player13_r2_btn = "nul">> C:\RetroCake\RetroArch\retroarch.cfg
echo input_player13_r2_axis = "nul">> C:\RetroCake\RetroArch\retroarch.cfg
echo input_player13_l3 = "nul">> C:\RetroCake\RetroArch\retroarch.cfg
echo input_player13_l3_btn = "nul">> C:\RetroCake\RetroArch\retroarch.cfg
echo input_player13_l3_axis = "nul">> C:\RetroCake\RetroArch\retroarch.cfg
echo input_player13_r3 = "nul">> C:\RetroCake\RetroArch\retroarch.cfg
echo input_player13_r3_btn = "nul">> C:\RetroCake\RetroArch\retroarch.cfg
echo input_player13_r3_axis = "nul">> C:\RetroCake\RetroArch\retroarch.cfg
echo input_player13_l_x_plus = "nul">> C:\RetroCake\RetroArch\retroarch.cfg
echo input_player13_l_x_plus_btn = "nul">> C:\RetroCake\RetroArch\retroarch.cfg
echo input_player13_l_x_plus_axis = "nul">> C:\RetroCake\RetroArch\retroarch.cfg
echo input_player13_l_x_minus = "nul">> C:\RetroCake\RetroArch\retroarch.cfg
echo input_player13_l_x_minus_btn = "nul">> C:\RetroCake\RetroArch\retroarch.cfg
echo input_player13_l_x_minus_axis = "nul">> C:\RetroCake\RetroArch\retroarch.cfg
echo input_player13_l_y_plus = "nul">> C:\RetroCake\RetroArch\retroarch.cfg
echo input_player13_l_y_plus_btn = "nul">> C:\RetroCake\RetroArch\retroarch.cfg
echo input_player13_l_y_plus_axis = "nul">> C:\RetroCake\RetroArch\retroarch.cfg
echo input_player13_l_y_minus = "nul">> C:\RetroCake\RetroArch\retroarch.cfg
echo input_player13_l_y_minus_btn = "nul">> C:\RetroCake\RetroArch\retroarch.cfg
echo input_player13_l_y_minus_axis = "nul">> C:\RetroCake\RetroArch\retroarch.cfg
echo input_player13_r_x_plus = "nul">> C:\RetroCake\RetroArch\retroarch.cfg
echo input_player13_r_x_plus_btn = "nul">> C:\RetroCake\RetroArch\retroarch.cfg
echo input_player13_r_x_plus_axis = "nul">> C:\RetroCake\RetroArch\retroarch.cfg
echo input_player13_r_x_minus = "nul">> C:\RetroCake\RetroArch\retroarch.cfg
echo input_player13_r_x_minus_btn = "nul">> C:\RetroCake\RetroArch\retroarch.cfg
echo input_player13_r_x_minus_axis = "nul">> C:\RetroCake\RetroArch\retroarch.cfg
echo input_player13_r_y_plus = "nul">> C:\RetroCake\RetroArch\retroarch.cfg
echo input_player13_r_y_plus_btn = "nul">> C:\RetroCake\RetroArch\retroarch.cfg
echo input_player13_r_y_plus_axis = "nul">> C:\RetroCake\RetroArch\retroarch.cfg
echo input_player13_r_y_minus = "nul">> C:\RetroCake\RetroArch\retroarch.cfg
echo input_player13_r_y_minus_btn = "nul">> C:\RetroCake\RetroArch\retroarch.cfg
echo input_player13_r_y_minus_axis = "nul">> C:\RetroCake\RetroArch\retroarch.cfg
echo input_player13_turbo = "nul">> C:\RetroCake\RetroArch\retroarch.cfg
echo input_player13_turbo_btn = "nul">> C:\RetroCake\RetroArch\retroarch.cfg
echo input_player13_turbo_axis = "nul">> C:\RetroCake\RetroArch\retroarch.cfg
echo input_player14_b = "nul">> C:\RetroCake\RetroArch\retroarch.cfg
echo input_player14_b_btn = "nul">> C:\RetroCake\RetroArch\retroarch.cfg
echo input_player14_b_axis = "nul">> C:\RetroCake\RetroArch\retroarch.cfg
echo input_player14_y = "nul">> C:\RetroCake\RetroArch\retroarch.cfg
echo input_player14_y_btn = "nul">> C:\RetroCake\RetroArch\retroarch.cfg
echo input_player14_y_axis = "nul">> C:\RetroCake\RetroArch\retroarch.cfg
echo input_player14_select = "nul">> C:\RetroCake\RetroArch\retroarch.cfg
echo input_player14_select_btn = "nul">> C:\RetroCake\RetroArch\retroarch.cfg
echo input_player14_select_axis = "nul">> C:\RetroCake\RetroArch\retroarch.cfg
echo input_player14_start = "nul">> C:\RetroCake\RetroArch\retroarch.cfg
echo input_player14_start_btn = "nul">> C:\RetroCake\RetroArch\retroarch.cfg
echo input_player14_start_axis = "nul">> C:\RetroCake\RetroArch\retroarch.cfg
echo input_player14_up = "nul">> C:\RetroCake\RetroArch\retroarch.cfg
echo input_player14_up_btn = "nul">> C:\RetroCake\RetroArch\retroarch.cfg
echo input_player14_up_axis = "nul">> C:\RetroCake\RetroArch\retroarch.cfg
echo input_player14_down = "nul">> C:\RetroCake\RetroArch\retroarch.cfg
echo input_player14_down_btn = "nul">> C:\RetroCake\RetroArch\retroarch.cfg
echo input_player14_down_axis = "nul">> C:\RetroCake\RetroArch\retroarch.cfg
echo input_player14_left = "nul">> C:\RetroCake\RetroArch\retroarch.cfg
echo input_player14_left_btn = "nul">> C:\RetroCake\RetroArch\retroarch.cfg
echo input_player14_left_axis = "nul">> C:\RetroCake\RetroArch\retroarch.cfg
echo input_player14_right = "nul">> C:\RetroCake\RetroArch\retroarch.cfg
echo input_player14_right_btn = "nul">> C:\RetroCake\RetroArch\retroarch.cfg
echo input_player14_right_axis = "nul">> C:\RetroCake\RetroArch\retroarch.cfg
echo input_player14_a = "nul">> C:\RetroCake\RetroArch\retroarch.cfg
echo input_player14_a_btn = "nul">> C:\RetroCake\RetroArch\retroarch.cfg
echo input_player14_a_axis = "nul">> C:\RetroCake\RetroArch\retroarch.cfg
echo input_player14_x = "nul">> C:\RetroCake\RetroArch\retroarch.cfg
echo input_player14_x_btn = "nul">> C:\RetroCake\RetroArch\retroarch.cfg
echo input_player14_x_axis = "nul">> C:\RetroCake\RetroArch\retroarch.cfg
echo input_player14_l = "nul">> C:\RetroCake\RetroArch\retroarch.cfg
echo input_player14_l_btn = "nul">> C:\RetroCake\RetroArch\retroarch.cfg
echo input_player14_l_axis = "nul">> C:\RetroCake\RetroArch\retroarch.cfg
echo input_player14_r = "nul">> C:\RetroCake\RetroArch\retroarch.cfg
echo input_player14_r_btn = "nul">> C:\RetroCake\RetroArch\retroarch.cfg
echo input_player14_r_axis = "nul">> C:\RetroCake\RetroArch\retroarch.cfg
echo input_player14_l2 = "nul">> C:\RetroCake\RetroArch\retroarch.cfg
echo input_player14_l2_btn = "nul">> C:\RetroCake\RetroArch\retroarch.cfg
echo input_player14_l2_axis = "nul">> C:\RetroCake\RetroArch\retroarch.cfg
echo input_player14_r2 = "nul">> C:\RetroCake\RetroArch\retroarch.cfg
echo input_player14_r2_btn = "nul">> C:\RetroCake\RetroArch\retroarch.cfg
echo input_player14_r2_axis = "nul">> C:\RetroCake\RetroArch\retroarch.cfg
echo input_player14_l3 = "nul">> C:\RetroCake\RetroArch\retroarch.cfg
echo input_player14_l3_btn = "nul">> C:\RetroCake\RetroArch\retroarch.cfg
echo input_player14_l3_axis = "nul">> C:\RetroCake\RetroArch\retroarch.cfg
echo input_player14_r3 = "nul">> C:\RetroCake\RetroArch\retroarch.cfg
echo input_player14_r3_btn = "nul">> C:\RetroCake\RetroArch\retroarch.cfg
echo input_player14_r3_axis = "nul">> C:\RetroCake\RetroArch\retroarch.cfg
echo input_player14_l_x_plus = "nul">> C:\RetroCake\RetroArch\retroarch.cfg
echo input_player14_l_x_plus_btn = "nul">> C:\RetroCake\RetroArch\retroarch.cfg
echo input_player14_l_x_plus_axis = "nul">> C:\RetroCake\RetroArch\retroarch.cfg
echo input_player14_l_x_minus = "nul">> C:\RetroCake\RetroArch\retroarch.cfg
echo input_player14_l_x_minus_btn = "nul">> C:\RetroCake\RetroArch\retroarch.cfg
echo input_player14_l_x_minus_axis = "nul">> C:\RetroCake\RetroArch\retroarch.cfg
echo input_player14_l_y_plus = "nul">> C:\RetroCake\RetroArch\retroarch.cfg
echo input_player14_l_y_plus_btn = "nul">> C:\RetroCake\RetroArch\retroarch.cfg
echo input_player14_l_y_plus_axis = "nul">> C:\RetroCake\RetroArch\retroarch.cfg
echo input_player14_l_y_minus = "nul">> C:\RetroCake\RetroArch\retroarch.cfg
echo input_player14_l_y_minus_btn = "nul">> C:\RetroCake\RetroArch\retroarch.cfg
echo input_player14_l_y_minus_axis = "nul">> C:\RetroCake\RetroArch\retroarch.cfg
echo input_player14_r_x_plus = "nul">> C:\RetroCake\RetroArch\retroarch.cfg
echo input_player14_r_x_plus_btn = "nul">> C:\RetroCake\RetroArch\retroarch.cfg
echo input_player14_r_x_plus_axis = "nul">> C:\RetroCake\RetroArch\retroarch.cfg
echo input_player14_r_x_minus = "nul">> C:\RetroCake\RetroArch\retroarch.cfg
echo input_player14_r_x_minus_btn = "nul">> C:\RetroCake\RetroArch\retroarch.cfg
echo input_player14_r_x_minus_axis = "nul">> C:\RetroCake\RetroArch\retroarch.cfg
echo input_player14_r_y_plus = "nul">> C:\RetroCake\RetroArch\retroarch.cfg
echo input_player14_r_y_plus_btn = "nul">> C:\RetroCake\RetroArch\retroarch.cfg
echo input_player14_r_y_plus_axis = "nul">> C:\RetroCake\RetroArch\retroarch.cfg
echo input_player14_r_y_minus = "nul">> C:\RetroCake\RetroArch\retroarch.cfg
echo input_player14_r_y_minus_btn = "nul">> C:\RetroCake\RetroArch\retroarch.cfg
echo input_player14_r_y_minus_axis = "nul">> C:\RetroCake\RetroArch\retroarch.cfg
echo input_player14_turbo = "nul">> C:\RetroCake\RetroArch\retroarch.cfg
echo input_player14_turbo_btn = "nul">> C:\RetroCake\RetroArch\retroarch.cfg
echo input_player14_turbo_axis = "nul">> C:\RetroCake\RetroArch\retroarch.cfg
echo input_player15_b = "nul">> C:\RetroCake\RetroArch\retroarch.cfg
echo input_player15_b_btn = "nul">> C:\RetroCake\RetroArch\retroarch.cfg
echo input_player15_b_axis = "nul">> C:\RetroCake\RetroArch\retroarch.cfg
echo input_player15_y = "nul">> C:\RetroCake\RetroArch\retroarch.cfg
echo input_player15_y_btn = "nul">> C:\RetroCake\RetroArch\retroarch.cfg
echo input_player15_y_axis = "nul">> C:\RetroCake\RetroArch\retroarch.cfg
echo input_player15_select = "nul">> C:\RetroCake\RetroArch\retroarch.cfg
echo input_player15_select_btn = "nul">> C:\RetroCake\RetroArch\retroarch.cfg
echo input_player15_select_axis = "nul">> C:\RetroCake\RetroArch\retroarch.cfg
echo input_player15_start = "nul">> C:\RetroCake\RetroArch\retroarch.cfg
echo input_player15_start_btn = "nul">> C:\RetroCake\RetroArch\retroarch.cfg
echo input_player15_start_axis = "nul">> C:\RetroCake\RetroArch\retroarch.cfg
echo input_player15_up = "nul">> C:\RetroCake\RetroArch\retroarch.cfg
echo input_player15_up_btn = "nul">> C:\RetroCake\RetroArch\retroarch.cfg
echo input_player15_up_axis = "nul">> C:\RetroCake\RetroArch\retroarch.cfg
echo input_player15_down = "nul">> C:\RetroCake\RetroArch\retroarch.cfg
echo input_player15_down_btn = "nul">> C:\RetroCake\RetroArch\retroarch.cfg
echo input_player15_down_axis = "nul">> C:\RetroCake\RetroArch\retroarch.cfg
echo input_player15_left = "nul">> C:\RetroCake\RetroArch\retroarch.cfg
echo input_player15_left_btn = "nul">> C:\RetroCake\RetroArch\retroarch.cfg
echo input_player15_left_axis = "nul">> C:\RetroCake\RetroArch\retroarch.cfg
echo input_player15_right = "nul">> C:\RetroCake\RetroArch\retroarch.cfg
echo input_player15_right_btn = "nul">> C:\RetroCake\RetroArch\retroarch.cfg
echo input_player15_right_axis = "nul">> C:\RetroCake\RetroArch\retroarch.cfg
echo input_player15_a = "nul">> C:\RetroCake\RetroArch\retroarch.cfg
echo input_player15_a_btn = "nul">> C:\RetroCake\RetroArch\retroarch.cfg
echo input_player15_a_axis = "nul">> C:\RetroCake\RetroArch\retroarch.cfg
echo input_player15_x = "nul">> C:\RetroCake\RetroArch\retroarch.cfg
echo input_player15_x_btn = "nul">> C:\RetroCake\RetroArch\retroarch.cfg
echo input_player15_x_axis = "nul">> C:\RetroCake\RetroArch\retroarch.cfg
echo input_player15_l = "nul">> C:\RetroCake\RetroArch\retroarch.cfg
echo input_player15_l_btn = "nul">> C:\RetroCake\RetroArch\retroarch.cfg
echo input_player15_l_axis = "nul">> C:\RetroCake\RetroArch\retroarch.cfg
echo input_player15_r = "nul">> C:\RetroCake\RetroArch\retroarch.cfg
echo input_player15_r_btn = "nul">> C:\RetroCake\RetroArch\retroarch.cfg
echo input_player15_r_axis = "nul">> C:\RetroCake\RetroArch\retroarch.cfg
echo input_player15_l2 = "nul">> C:\RetroCake\RetroArch\retroarch.cfg
echo input_player15_l2_btn = "nul">> C:\RetroCake\RetroArch\retroarch.cfg
echo input_player15_l2_axis = "nul">> C:\RetroCake\RetroArch\retroarch.cfg
echo input_player15_r2 = "nul">> C:\RetroCake\RetroArch\retroarch.cfg
echo input_player15_r2_btn = "nul">> C:\RetroCake\RetroArch\retroarch.cfg
echo input_player15_r2_axis = "nul">> C:\RetroCake\RetroArch\retroarch.cfg
echo input_player15_l3 = "nul">> C:\RetroCake\RetroArch\retroarch.cfg
echo input_player15_l3_btn = "nul">> C:\RetroCake\RetroArch\retroarch.cfg
echo input_player15_l3_axis = "nul">> C:\RetroCake\RetroArch\retroarch.cfg
echo input_player15_r3 = "nul">> C:\RetroCake\RetroArch\retroarch.cfg
echo input_player15_r3_btn = "nul">> C:\RetroCake\RetroArch\retroarch.cfg
echo input_player15_r3_axis = "nul">> C:\RetroCake\RetroArch\retroarch.cfg
echo input_player15_l_x_plus = "nul">> C:\RetroCake\RetroArch\retroarch.cfg
echo input_player15_l_x_plus_btn = "nul">> C:\RetroCake\RetroArch\retroarch.cfg
echo input_player15_l_x_plus_axis = "nul">> C:\RetroCake\RetroArch\retroarch.cfg
echo input_player15_l_x_minus = "nul">> C:\RetroCake\RetroArch\retroarch.cfg
echo input_player15_l_x_minus_btn = "nul">> C:\RetroCake\RetroArch\retroarch.cfg
echo input_player15_l_x_minus_axis = "nul">> C:\RetroCake\RetroArch\retroarch.cfg
echo input_player15_l_y_plus = "nul">> C:\RetroCake\RetroArch\retroarch.cfg
echo input_player15_l_y_plus_btn = "nul">> C:\RetroCake\RetroArch\retroarch.cfg
echo input_player15_l_y_plus_axis = "nul">> C:\RetroCake\RetroArch\retroarch.cfg
echo input_player15_l_y_minus = "nul">> C:\RetroCake\RetroArch\retroarch.cfg
echo input_player15_l_y_minus_btn = "nul">> C:\RetroCake\RetroArch\retroarch.cfg
echo input_player15_l_y_minus_axis = "nul">> C:\RetroCake\RetroArch\retroarch.cfg
echo input_player15_r_x_plus = "nul">> C:\RetroCake\RetroArch\retroarch.cfg
echo input_player15_r_x_plus_btn = "nul">> C:\RetroCake\RetroArch\retroarch.cfg
echo input_player15_r_x_plus_axis = "nul">> C:\RetroCake\RetroArch\retroarch.cfg
echo input_player15_r_x_minus = "nul">> C:\RetroCake\RetroArch\retroarch.cfg
echo input_player15_r_x_minus_btn = "nul">> C:\RetroCake\RetroArch\retroarch.cfg
echo input_player15_r_x_minus_axis = "nul">> C:\RetroCake\RetroArch\retroarch.cfg
echo input_player15_r_y_plus = "nul">> C:\RetroCake\RetroArch\retroarch.cfg
echo input_player15_r_y_plus_btn = "nul">> C:\RetroCake\RetroArch\retroarch.cfg
echo input_player15_r_y_plus_axis = "nul">> C:\RetroCake\RetroArch\retroarch.cfg
echo input_player15_r_y_minus = "nul">> C:\RetroCake\RetroArch\retroarch.cfg
echo input_player15_r_y_minus_btn = "nul">> C:\RetroCake\RetroArch\retroarch.cfg
echo input_player15_r_y_minus_axis = "nul">> C:\RetroCake\RetroArch\retroarch.cfg
echo input_player15_turbo = "nul">> C:\RetroCake\RetroArch\retroarch.cfg
echo input_player15_turbo_btn = "nul">> C:\RetroCake\RetroArch\retroarch.cfg
echo input_player15_turbo_axis = "nul">> C:\RetroCake\RetroArch\retroarch.cfg
echo input_player16_b = "nul">> C:\RetroCake\RetroArch\retroarch.cfg
echo input_player16_b_btn = "nul">> C:\RetroCake\RetroArch\retroarch.cfg
echo input_player16_b_axis = "nul">> C:\RetroCake\RetroArch\retroarch.cfg
echo input_player16_y = "nul">> C:\RetroCake\RetroArch\retroarch.cfg
echo input_player16_y_btn = "nul">> C:\RetroCake\RetroArch\retroarch.cfg
echo input_player16_y_axis = "nul">> C:\RetroCake\RetroArch\retroarch.cfg
echo input_player16_select = "nul">> C:\RetroCake\RetroArch\retroarch.cfg
echo input_player16_select_btn = "nul">> C:\RetroCake\RetroArch\retroarch.cfg
echo input_player16_select_axis = "nul">> C:\RetroCake\RetroArch\retroarch.cfg
echo input_player16_start = "nul">> C:\RetroCake\RetroArch\retroarch.cfg
echo input_player16_start_btn = "nul">> C:\RetroCake\RetroArch\retroarch.cfg
echo input_player16_start_axis = "nul">> C:\RetroCake\RetroArch\retroarch.cfg
echo input_player16_up = "nul">> C:\RetroCake\RetroArch\retroarch.cfg
echo input_player16_up_btn = "nul">> C:\RetroCake\RetroArch\retroarch.cfg
echo input_player16_up_axis = "nul">> C:\RetroCake\RetroArch\retroarch.cfg
echo input_player16_down = "nul">> C:\RetroCake\RetroArch\retroarch.cfg
echo input_player16_down_btn = "nul">> C:\RetroCake\RetroArch\retroarch.cfg
echo input_player16_down_axis = "nul">> C:\RetroCake\RetroArch\retroarch.cfg
echo input_player16_left = "nul">> C:\RetroCake\RetroArch\retroarch.cfg
echo input_player16_left_btn = "nul">> C:\RetroCake\RetroArch\retroarch.cfg
echo input_player16_left_axis = "nul">> C:\RetroCake\RetroArch\retroarch.cfg
echo input_player16_right = "nul">> C:\RetroCake\RetroArch\retroarch.cfg
echo input_player16_right_btn = "nul">> C:\RetroCake\RetroArch\retroarch.cfg
echo input_player16_right_axis = "nul">> C:\RetroCake\RetroArch\retroarch.cfg
echo input_player16_a = "nul">> C:\RetroCake\RetroArch\retroarch.cfg
echo input_player16_a_btn = "nul">> C:\RetroCake\RetroArch\retroarch.cfg
echo input_player16_a_axis = "nul">> C:\RetroCake\RetroArch\retroarch.cfg
echo input_player16_x = "nul">> C:\RetroCake\RetroArch\retroarch.cfg
echo input_player16_x_btn = "nul">> C:\RetroCake\RetroArch\retroarch.cfg
echo input_player16_x_axis = "nul">> C:\RetroCake\RetroArch\retroarch.cfg
echo input_player16_l = "nul">> C:\RetroCake\RetroArch\retroarch.cfg
echo input_player16_l_btn = "nul">> C:\RetroCake\RetroArch\retroarch.cfg
echo input_player16_l_axis = "nul">> C:\RetroCake\RetroArch\retroarch.cfg
echo input_player16_r = "nul">> C:\RetroCake\RetroArch\retroarch.cfg
echo input_player16_r_btn = "nul">> C:\RetroCake\RetroArch\retroarch.cfg
echo input_player16_r_axis = "nul">> C:\RetroCake\RetroArch\retroarch.cfg
echo input_player16_l2 = "nul">> C:\RetroCake\RetroArch\retroarch.cfg
echo input_player16_l2_btn = "nul">> C:\RetroCake\RetroArch\retroarch.cfg
echo input_player16_l2_axis = "nul">> C:\RetroCake\RetroArch\retroarch.cfg
echo input_player16_l2_axis = "nul">> C:\RetroCake\RetroArch\retroarch.cfg
echo input_player16_r2 = "nul">> C:\RetroCake\RetroArch\retroarch.cfg
echo input_player16_r2_btn = "nul">> C:\RetroCake\RetroArch\retroarch.cfg
echo input_player16_r2_axis = "nul">> C:\RetroCake\RetroArch\retroarch.cfg
echo input_player16_l3 = "nul">> C:\RetroCake\RetroArch\retroarch.cfg
echo input_player16_l3_btn = "nul">> C:\RetroCake\RetroArch\retroarch.cfg
echo input_player16_l3_axis = "nul">> C:\RetroCake\RetroArch\retroarch.cfg
echo input_player16_r3 = "nul">> C:\RetroCake\RetroArch\retroarch.cfg
echo input_player16_r3_btn = "nul">> C:\RetroCake\RetroArch\retroarch.cfg
echo input_player16_r3_axis = "nul">> C:\RetroCake\RetroArch\retroarch.cfg
echo input_player16_l_x_plus = "nul">> C:\RetroCake\RetroArch\retroarch.cfg
echo input_player16_l_x_plus_btn = "nul">> C:\RetroCake\RetroArch\retroarch.cfg
echo input_player16_l_x_plus_axis = "nul">> C:\RetroCake\RetroArch\retroarch.cfg
echo input_player16_l_x_minus = "nul">> C:\RetroCake\RetroArch\retroarch.cfg
echo input_player16_l_x_minus_btn = "nul">> C:\RetroCake\RetroArch\retroarch.cfg
echo input_player16_l_x_minus_axis = "nul">> C:\RetroCake\RetroArch\retroarch.cfg
echo input_player16_l_y_plus = "nul">> C:\RetroCake\RetroArch\retroarch.cfg
echo input_player16_l_y_plus_btn = "nul">> C:\RetroCake\RetroArch\retroarch.cfg
echo input_player16_l_y_plus_axis = "nul">> C:\RetroCake\RetroArch\retroarch.cfg
echo input_player16_l_y_minus = "nul">> C:\RetroCake\RetroArch\retroarch.cfg
echo input_player16_l_y_minus_btn = "nul">> C:\RetroCake\RetroArch\retroarch.cfg
echo input_player16_l_y_minus_axis = "nul">> C:\RetroCake\RetroArch\retroarch.cfg
echo input_player16_r_x_plus = "nul">> C:\RetroCake\RetroArch\retroarch.cfg
echo input_player16_r_x_plus_btn = "nul">> C:\RetroCake\RetroArch\retroarch.cfg
echo input_player16_r_x_plus_axis = "nul">> C:\RetroCake\RetroArch\retroarch.cfg
echo input_player16_r_x_minus = "nul">> C:\RetroCake\RetroArch\retroarch.cfg
echo input_player16_r_x_minus_btn = "nul">> C:\RetroCake\RetroArch\retroarch.cfg
echo input_player16_r_x_minus_axis = "nul">> C:\RetroCake\RetroArch\retroarch.cfg
echo input_player16_r_y_plus = "nul">> C:\RetroCake\RetroArch\retroarch.cfg
echo input_player16_r_y_plus_btn = "nul">> C:\RetroCake\RetroArch\retroarch.cfg
echo input_player16_r_y_plus_axis = "nul">> C:\RetroCake\RetroArch\retroarch.cfg
echo input_player16_r_y_minus = "nul">> C:\RetroCake\RetroArch\retroarch.cfg
echo input_player16_r_y_minus_btn = "nul">> C:\RetroCake\RetroArch\retroarch.cfg
echo input_player16_r_y_minus_axis = "nul">> C:\RetroCake\RetroArch\retroarch.cfg
echo input_player16_turbo = "nul">> C:\RetroCake\RetroArch\retroarch.cfg
echo input_player16_turbo_btn = "nul">> C:\RetroCake\RetroArch\retroarch.cfg
echo input_player16_turbo_axis = "nul">> C:\RetroCake\RetroArch\retroarch.cfg
echo video_msg_bgcolor_opacity = "1.000000">> C:\RetroCake\RetroArch\retroarch.cfg
echo keymapper_port = "0">> C:\RetroCake\RetroArch\retroarch.cfg
echo video_msg_bgcolor_red = "0">> C:\RetroCake\RetroArch\retroarch.cfg
echo video_msg_bgcolor_green = "0">> C:\RetroCake\RetroArch\retroarch.cfg
echo video_msg_bgcolor_blue = "0">> C:\RetroCake\RetroArch\retroarch.cfg
echo framecount_show = "true">> C:\RetroCake\RetroArch\retroarch.cfg
echo quick_menu_show_take_screenshot = "true">> C:\RetroCake\RetroArch\retroarch.cfg
echo quick_menu_show_save_load_state = "true">> C:\RetroCake\RetroArch\retroarch.cfg
echo quick_menu_show_undo_save_load_state = "true">> C:\RetroCake\RetroArch\retroarch.cfg
echo quick_menu_show_add_to_favorites = "true">> C:\RetroCake\RetroArch\retroarch.cfg
echo quick_menu_show_options = "true">> C:\RetroCake\RetroArch\retroarch.cfg
echo quick_menu_show_controls = "true">> C:\RetroCake\RetroArch\retroarch.cfg
echo quick_menu_show_cheats = "true">> C:\RetroCake\RetroArch\retroarch.cfg
echo quick_menu_show_shaders = "true">> C:\RetroCake\RetroArch\retroarch.cfg
echo quick_menu_show_save_core_overrides = "true">> C:\RetroCake\RetroArch\retroarch.cfg
echo quick_menu_show_save_game_overrides = "true">> C:\RetroCake\RetroArch\retroarch.cfg
echo quick_menu_show_information = "true">> C:\RetroCake\RetroArch\retroarch.cfg
echo kiosk_mode_enable = "false">> C:\RetroCake\RetroArch\retroarch.cfg
echo menu_show_load_core = "true">> C:\RetroCake\RetroArch\retroarch.cfg
echo menu_show_load_content = "true">> C:\RetroCake\RetroArch\retroarch.cfg
echo menu_show_information = "true">> C:\RetroCake\RetroArch\retroarch.cfg
echo menu_show_configurations = "true">> C:\RetroCake\RetroArch\retroarch.cfg
echo menu_show_help = "true">> C:\RetroCake\RetroArch\retroarch.cfg
echo menu_show_quit_retroarch = "true">> C:\RetroCake\RetroArch\retroarch.cfg
echo menu_show_reboot = "true">> C:\RetroCake\RetroArch\retroarch.cfg
echo keymapper_enable = "true">> C:\RetroCake\RetroArch\retroarch.cfg
echo playlist_entry_rename = "true">> C:\RetroCake\RetroArch\retroarch.cfg
echo video_msg_bgcolor_enable = "false">> C:\RetroCake\RetroArch\retroarch.cfg
echo cheevos_leaderboards_enable = "false">> C:\RetroCake\RetroArch\retroarch.cfg
echo xmb_font = "">> C:\RetroCake\RetroArch\retroarch.cfg
echo xmb_show_settings_password = "">> C:\RetroCake\RetroArch\retroarch.cfg
echo kiosk_mode_password = "">> C:\RetroCake\RetroArch\retroarch.cfg
echo netplay_nickname = "">> C:\RetroCake\RetroArch\retroarch.cfg
echo video_filter = "">> C:\RetroCake\RetroArch\retroarch.cfg
echo audio_dsp_plugin = "">> C:\RetroCake\RetroArch\retroarch.cfg
echo netplay_ip_address = "">> C:\RetroCake\RetroArch\retroarch.cfg
echo netplay_password = "">> C:\RetroCake\RetroArch\retroarch.cfg
echo netplay_spectate_password = "">> C:\RetroCake\RetroArch\retroarch.cfg
echo core_options_path = "">> C:\RetroCake\RetroArch\retroarch.cfg
echo video_shader = "">> C:\RetroCake\RetroArch\retroarch.cfg
echo menu_wallpaper = "">> C:\RetroCake\RetroArch\retroarch.cfg
echo input_overlay = "">> C:\RetroCake\RetroArch\retroarch.cfg
echo video_font_path = "">> C:\RetroCake\RetroArch\retroarch.cfg
echo content_history_dir = "">> C:\RetroCake\RetroArch\retroarch.cfg
echo cache_directory = "">> C:\RetroCake\RetroArch\retroarch.cfg
echo resampler_directory = "">> C:\RetroCake\RetroArch\retroarch.cfg
echo recording_output_directory = "">> C:\RetroCake\RetroArch\retroarch.cfg
echo recording_config_directory = "">> C:\RetroCake\RetroArch\retroarch.cfg
echo xmb_font = "">> C:\RetroCake\RetroArch\retroarch.cfg
echo playlist_names = "">> C:\RetroCake\RetroArch\retroarch.cfg
echo playlist_cores = "">> C:\RetroCake\RetroArch\retroarch.cfg
echo audio_device = "">> C:\RetroCake\RetroArch\retroarch.cfg
echo camera_device = "">> C:\RetroCake\RetroArch\retroarch.cfg
echo video_context_driver = "">> C:\RetroCake\RetroArch\retroarch.cfg
echo input_keyboard_layout = "">> C:\RetroCake\RetroArch\retroarch.cfg
echo bundle_assets_src_path = "">> C:\RetroCake\RetroArch\retroarch.cfg
echo bundle_assets_dst_path = "">> C:\RetroCake\RetroArch\retroarch.cfg
echo bundle_assets_dst_path_subdir = "">> C:\RetroCake\RetroArch\retroarch.cfg
goto updatecores


::=================================================================================================================================================================================================================================================================================================================
::=================================================================================================================================================================================================================================================================================================================
::=================================================================================================================================================================================================================================================================================================================
::=================================================================================================================================================================================================================================================================================================================
::=================================================================================================================================================================================================================================================================================================================

:updatecores
cls
mkdir "C:\RetroCake\Temp\cores"
cls
if "%PROCESSOR_ARCHITECTURE%"=="AMD64" (
		goto x64core
	)
if "%PROCESSOR_ARCHITECTURE%"=="x86" (
		goto x86core
	)
:x64core
cls
echo(
echo(
echo(
echo(
echo(
echo(
echo(
echo =================================================================
echo =                                                               =
echo =     Downloading RetroArch cores. This will take some time     =
echo =                                                               =
echo =================================================================
powershell -command "Invoke-WebRequest -Uri http://buildbot.libretro.com/nightly/windows/x86_64/latest/2048_libretro.dll.zip -OutFile "C:\RetroCake\Temp\cores\1.zip"
powershell -command "Invoke-WebRequest -Uri http://buildbot.libretro.com/nightly/windows/x86_64/latest/4do_libretro.dll.zip -OutFile "C:\RetroCake\Temp\cores\3.zip"
powershell -command "Invoke-WebRequest -Uri http://buildbot.libretro.com/nightly/windows/x86_64/latest/atari800_libretro.dll.zip -OutFile "C:\RetroCake\Temp\cores\5.zip"
powershell -command "Invoke-WebRequest -Uri http://buildbot.libretro.com/nightly/windows/x86_64/latest/bluemsx_libretro.dll.zip -OutFile "C:\RetroCake\Temp\cores\6.zip"
powershell -command "Invoke-WebRequest -Uri http://buildbot.libretro.com/nightly/windows/x86_64/latest/bnes_libretro.dll.zip -OutFile "C:\RetroCake\Temp\cores\7.zip"
powershell -command "Invoke-WebRequest -Uri http://buildbot.libretro.com/nightly/windows/x86_64/latest/cap32_libretro.dll.zip -OutFile "C:\RetroCake\Temp\cores\15.zip"
powershell -command "Invoke-WebRequest -Uri http://buildbot.libretro.com/nightly/windows/x86_64/latest/fbalpha_libretro.dll.zip -OutFile "C:\RetroCake\Temp\cores\31.zip"
powershell -command "Invoke-WebRequest -Uri http://buildbot.libretro.com/nightly/windows/x86_64/latest/fceumm_libretro.dll.zip -OutFile "C:\RetroCake\Temp\cores\32.zip"
powershell -command "Invoke-WebRequest -Uri http://buildbot.libretro.com/nightly/windows/x86_64/latest/fuse_libretro.dll.zip -OutFile "C:\RetroCake\Temp\cores\35.zip"
powershell -command "Invoke-WebRequest -Uri http://buildbot.libretro.com/nightly/windows/x86_64/latest/gambatte_libretro.dll.zip -OutFile "C:\RetroCake\Temp\cores\36.zip"
powershell -command "Invoke-WebRequest -Uri http://buildbot.libretro.com/nightly/windows/x86_64/latest/genesis_plus_gx_libretro.dll.zip -OutFile "C:\RetroCake\Temp\cores\37.zip"
powershell -command "Invoke-WebRequest -Uri http://buildbot.libretro.com/nightly/windows/x86_64/latest/gpsp_libretro.dll.zip -OutFile "C:\RetroCake\Temp\cores\39.zip"
powershell -command "Invoke-WebRequest -Uri http://buildbot.libretro.com/nightly/windows/x86_64/latest/handy_libretro.dll.zip -OutFile "C:\RetroCake\Temp\cores\41.zip"
powershell -command "Invoke-WebRequest -Uri http://buildbot.libretro.com/nightly/windows/x86_64/latest/mame2003_libretro.dll.zip -OutFile "C:\RetroCake\Temp\cores\47.zip"
powershell -command "Invoke-WebRequest -Uri http://buildbot.libretro.com/nightly/windows/x86_64/latest/mame2010_libretro.dll.zip -OutFile "C:\RetroCake\Temp\cores\48.zip"
powershell -command "Invoke-WebRequest -Uri http://buildbot.libretro.com/nightly/windows/x86_64/latest/mame2014_libretro.dll.zip -OutFile "C:\RetroCake\Temp\cores\49.zip"
powershell -command "Invoke-WebRequest -Uri http://buildbot.libretro.com/nightly/windows/x86_64/latest/mame_libretro.dll.zip -OutFile "C:\RetroCake\Temp\cores\50.zip"
powershell -command "Invoke-WebRequest -Uri http://buildbot.libretro.com/nightly/windows/x86_64/latest/mednafen_gba_libretro.dll.zip -OutFile "C:\RetroCake\Temp\cores\51.zip"
powershell -command "Invoke-WebRequest -Uri http://buildbot.libretro.com/nightly/windows/x86_64/latest/mednafen_ngp_libretro.dll.zip -OutFile "C:\RetroCake\Temp\cores\53.zip"
powershell -command "Invoke-WebRequest -Uri http://buildbot.libretro.com/nightly/windows/x86_64/latest/mednafen_pce_fast_libretro.dll.zip -OutFile "C:\RetroCake\Temp\cores\54.zip"
powershell -command "Invoke-WebRequest -Uri http://buildbot.libretro.com/nightly/windows/x86_64/latest/mednafen_psx_hw_libretro.dll.zip -OutFile "C:\RetroCake\Temp\cores\56.zip"
powershell -command "Invoke-WebRequest -Uri http://buildbot.libretro.com/nightly/windows/x86_64/latest/mednafen_psx_libretro.dll.zip -OutFile "C:\RetroCake\Temp\cores\57.zip"
powershell -command "Invoke-WebRequest -Uri http://buildbot.libretro.com/nightly/windows/x86_64/latest/mednafen_saturn_libretro.dll.zip -OutFile "C:\RetroCake\Temp\cores\58.zip"
powershell -command "Invoke-WebRequest -Uri http://buildbot.libretro.com/nightly/windows/x86_64/latest/mednafen_supergrafx_libretro.dll.zip -OutFile "C:\RetroCake\Temp\cores\60.zip"
powershell -command "Invoke-WebRequest -Uri http://buildbot.libretro.com/nightly/windows/x86_64/latest/melonds_libretro.dll.zip -OutFile "C:\RetroCake\Temp\cores\63.zip"
powershell -command "Invoke-WebRequest -Uri http://buildbot.libretro.com/nightly/windows/x86_64/latest/mupen64plus_libretro.dll.zip -OutFile "C:\RetroCake\Temp\cores\68.zip"
powershell -command "Invoke-WebRequest -Uri http://buildbot.libretro.com/nightly/windows/x86_64/latest/nestopia_libretro.dll.zip -OutFile "C:\RetroCake\Temp\cores\70.zip"
powershell -command "Invoke-WebRequest -Uri http://buildbot.libretro.com/nightly/windows/x86_64/latest/pcsx_rearmed_libretro.dll.zip -OutFile "C:\RetroCake\Temp\cores\76.zip"
powershell -command "Invoke-WebRequest -Uri http://buildbot.libretro.com/nightly/windows/x86_64/latest/picodrive_libretro.dll.zip -OutFile "C:\RetroCake\Temp\cores\77.zip"
powershell -command "Invoke-WebRequest -Uri http://buildbot.libretro.com/nightly/windows/x86_64/latest/ppsspp_libretro.dll.zip -OutFile "C:\RetroCake\Temp\cores\80.zip"
powershell -command "Invoke-WebRequest -Uri http://buildbot.libretro.com/nightly/windows/x86_64/latest/prosystem_libretro.dll.zip -OutFile "C:\RetroCake\Temp\cores\82.zip"
powershell -command "Invoke-WebRequest -Uri http://buildbot.libretro.com/nightly/windows/x86_64/latest/puae_libretro.dll.zip -OutFile "C:\RetroCake\Temp\cores\83.zip"
powershell -command "Invoke-WebRequest -Uri http://buildbot.libretro.com/nightly/windows/x86_64/latest/px68k_libretro.dll.zip -OutFile "C:\RetroCake\Temp\cores\84.zip"
powershell -command "Invoke-WebRequest -Uri http://buildbot.libretro.com/nightly/windows/x86_64/latest/redream_libretro.dll.zip -OutFile "C:\RetroCake\Temp\cores\86.zip"
powershell -command "Invoke-WebRequest -Uri http://buildbot.libretro.com/nightly/windows/x86_64/latest/reicast_libretro.dll.zip -OutFile "C:\RetroCake\Temp\cores\87.zip"
powershell -command "Invoke-WebRequest -Uri http://buildbot.libretro.com/nightly/windows/x86_64/latest/snes9x2010_libretro.dll.zip -OutFile "C:\RetroCake\Temp\cores\94.zip"
powershell -command "Invoke-WebRequest -Uri http://buildbot.libretro.com/nightly/windows/x86_64/latest/stella_libretro.dll.zip -OutFile "C:\RetroCake\Temp\cores\96.zip"
powershell -command "Invoke-WebRequest -Uri http://buildbot.libretro.com/nightly/windows/x86_64/latest/vecx_libretro.dll.zip -OutFile "C:\RetroCake\Temp\cores\102.zip"
powershell -command "Invoke-WebRequest -Uri http://buildbot.libretro.com/nightly/windows/x86_64/latest/virtualjaguar_libretro.dll.zip -OutFile "C:\RetroCake\Temp\cores\106.zip"
mkdir C:\RetroCake\RetroArch\cores
C:\RetroCake\Tools\7za\7za.exe x "C:\RetroCake\Temp\cores\*.zip" -o"C:\RetroCake\RetroArch\cores" -aoa
cls
echo ================================================
echo =         Cleaning up downloaded files         =
echo ================================================
ping 127.0.0.1 -n 4 >nul
rmdir "C:\RetroCake\Temp\cores" /s /q
IF EXIST C:\RetroCake\Temp\BrandNewBlank goto InstallAllEmu
IF EXIST C:\RetroCake\Temp\BrandNewDef goto InstallAllEmu
IF EXIST C:\RetroCake\Temp\BrandNewCus goto InstallAllEmu
goto completed

:x86core
cls
echo(
echo(
echo(
echo(
echo(
echo(
echo(
echo =================================================================
echo =                                                               =
echo =     Downloading RetroArch cores. This will take some time     =
echo =                                                               =
echo =================================================================
powershell -command "Invoke-WebRequest -Uri http://buildbot.libretro.com/nightly/windows/x86/latest/2048_libretro.dll.zip -OutFile "C:\RetroCake\Temp\cores\1.zip"
powershell -command "Invoke-WebRequest -Uri http://buildbot.libretro.com/nightly/windows/x86/latest/4do_libretro.dll.zip -OutFile "C:\RetroCake\Temp\cores\3.zip"
powershell -command "Invoke-WebRequest -Uri http://buildbot.libretro.com/nightly/windows/x86/latest/atari800_libretro.dll.zip -OutFile "C:\RetroCake\Temp\cores\5.zip"
powershell -command "Invoke-WebRequest -Uri http://buildbot.libretro.com/nightly/windows/x86/latest/bluemsx_libretro.dll.zip -OutFile "C:\RetroCake\Temp\cores\6.zip"
powershell -command "Invoke-WebRequest -Uri http://buildbot.libretro.com/nightly/windows/x86/latest/bnes_libretro.dll.zip -OutFile "C:\RetroCake\Temp\cores\7.zip"
powershell -command "Invoke-WebRequest -Uri http://buildbot.libretro.com/nightly/windows/x86/latest/cap32_libretro.dll.zip -OutFile "C:\RetroCake\Temp\cores\15.zip"
powershell -command "Invoke-WebRequest -Uri http://buildbot.libretro.com/nightly/windows/x86/latest/fbalpha_libretro.dll.zip -OutFile "C:\RetroCake\Temp\cores\31.zip"
powershell -command "Invoke-WebRequest -Uri http://buildbot.libretro.com/nightly/windows/x86/latest/fceumm_libretro.dll.zip -OutFile "C:\RetroCake\Temp\cores\32.zip"
powershell -command "Invoke-WebRequest -Uri http://buildbot.libretro.com/nightly/windows/x86/latest/fuse_libretro.dll.zip -OutFile "C:\RetroCake\Temp\cores\35.zip"
powershell -command "Invoke-WebRequest -Uri http://buildbot.libretro.com/nightly/windows/x86/latest/genesis_plus_gx_libretro.dll.zip -OutFile "C:\RetroCake\Temp\cores\37.zip"
powershell -command "Invoke-WebRequest -Uri http://buildbot.libretro.com/nightly/windows/x86/latest/gpsp_libretro.dll.zip -OutFile "C:\RetroCake\Temp\cores\39.zip"
powershell -command "Invoke-WebRequest -Uri http://buildbot.libretro.com/nightly/windows/x86/latest/handy_libretro.dll.zip -OutFile "C:\RetroCake\Temp\cores\41.zip"
powershell -command "Invoke-WebRequest -Uri http://buildbot.libretro.com/nightly/windows/x86/latest/mame2003_libretro.dll.zip -OutFile "C:\RetroCake\Temp\cores\47.zip"
powershell -command "Invoke-WebRequest -Uri http://buildbot.libretro.com/nightly/windows/x86/latest/mame2010_libretro.dll.zip -OutFile "C:\RetroCake\Temp\cores\48.zip"
powershell -command "Invoke-WebRequest -Uri http://buildbot.libretro.com/nightly/windows/x86/latest/mame2014_libretro.dll.zip -OutFile "C:\RetroCake\Temp\cores\49.zip"
powershell -command "Invoke-WebRequest -Uri http://buildbot.libretro.com/nightly/windows/x86/latest/mame_libretro.dll.zip -OutFile "C:\RetroCake\Temp\cores\50.zip"
powershell -command "Invoke-WebRequest -Uri http://buildbot.libretro.com/nightly/windows/x86/latest/mednafen_gba_libretro.dll.zip -OutFile "C:\RetroCake\Temp\cores\51.zip"
powershell -command "Invoke-WebRequest -Uri http://buildbot.libretro.com/nightly/windows/x86/latest/mednafen_ngp_libretro.dll.zip -OutFile "C:\RetroCake\Temp\cores\53.zip"
powershell -command "Invoke-WebRequest -Uri http://buildbot.libretro.com/nightly/windows/x86/latest/mednafen_pce_fast_libretro.dll.zip -OutFile "C:\RetroCake\Temp\cores\54.zip"
powershell -command "Invoke-WebRequest -Uri http://buildbot.libretro.com/nightly/windows/x86/latest/mednafen_psx_hw_libretro.dll.zip -OutFile "C:\RetroCake\Temp\cores\56.zip"
powershell -command "Invoke-WebRequest -Uri http://buildbot.libretro.com/nightly/windows/x86/latest/mednafen_psx_libretro.dll.zip -OutFile "C:\RetroCake\Temp\cores\57.zip"
powershell -command "Invoke-WebRequest -Uri http://buildbot.libretro.com/nightly/windows/x86/latest/mednafen_saturn_libretro.dll.zip -OutFile "C:\RetroCake\Temp\cores\58.zip"
powershell -command "Invoke-WebRequest -Uri http://buildbot.libretro.com/nightly/windows/x86/latest/mednafen_supergrafx_libretro.dll.zip -OutFile "C:\RetroCake\Temp\cores\60.zip"
powershell -command "Invoke-WebRequest -Uri http://buildbot.libretro.com/nightly/windows/x86/latest/melonds_libretro.dll.zip -OutFile "C:\RetroCake\Temp\cores\63.zip"
powershell -command "Invoke-WebRequest -Uri http://buildbot.libretro.com/nightly/windows/x86/latest/mupen64plus_libretro.dll.zip -OutFile "C:\RetroCake\Temp\cores\68.zip"
powershell -command "Invoke-WebRequest -Uri http://buildbot.libretro.com/nightly/windows/x86/latest/nestopia_libretro.dll.zip -OutFile "C:\RetroCake\Temp\cores\70.zip"
powershell -command "Invoke-WebRequest -Uri http://buildbot.libretro.com/nightly/windows/x86/latest/pcsx_rearmed_libretro.dll.zip -OutFile "C:\RetroCake\Temp\cores\76.zip"
powershell -command "Invoke-WebRequest -Uri http://buildbot.libretro.com/nightly/windows/x86/latest/picodrive_libretro.dll.zip -OutFile "C:\RetroCake\Temp\cores\77.zip"
powershell -command "Invoke-WebRequest -Uri http://buildbot.libretro.com/nightly/windows/x86/latest/ppsspp_libretro.dll.zip -OutFile "C:\RetroCake\Temp\cores\80.zip"
powershell -command "Invoke-WebRequest -Uri http://buildbot.libretro.com/nightly/windows/x86/latest/prosystem_libretro.dll.zip -OutFile "C:\RetroCake\Temp\cores\82.zip"
powershell -command "Invoke-WebRequest -Uri http://buildbot.libretro.com/nightly/windows/x86/latest/puae_libretro.dll.zip -OutFile "C:\RetroCake\Temp\cores\83.zip"
powershell -command "Invoke-WebRequest -Uri http://buildbot.libretro.com/nightly/windows/x86/latest/px68k_libretro.dll.zip -OutFile "C:\RetroCake\Temp\cores\84.zip"
powershell -command "Invoke-WebRequest -Uri http://buildbot.libretro.com/nightly/windows/x86/latest/redream_libretro.dll.zip -OutFile "C:\RetroCake\Temp\cores\86.zip"
powershell -command "Invoke-WebRequest -Uri http://buildbot.libretro.com/nightly/windows/x86/latest/reicast_libretro.dll.zip -OutFile "C:\RetroCake\Temp\cores\87.zip"
powershell -command "Invoke-WebRequest -Uri http://buildbot.libretro.com/nightly/windows/x86/latest/snes9x2010_libretro.dll.zip -OutFile "C:\RetroCake\Temp\cores\94.zip"
powershell -command "Invoke-WebRequest -Uri http://buildbot.libretro.com/nightly/windows/x86/latest/stella_libretro.dll.zip -OutFile "C:\RetroCake\Temp\cores\96.zip"
powershell -command "Invoke-WebRequest -Uri http://buildbot.libretro.com/nightly/windows/x86/latest/vecx_libretro.dll.zip -OutFile "C:\RetroCake\Temp\cores\102.zip"
powershell -command "Invoke-WebRequest -Uri http://buildbot.libretro.com/nightly/windows/x86/latest/virtualjaguar_libretro.dll.zip -OutFile "C:\RetroCake\Temp\cores\106.zip"
mkdir C:\RetroCake\RetroArch\cores
C:\RetroCake\Tools\7za\7za.exe x "C:\RetroCake\Temp\cores\*.zip" -o"C:\RetroCake\RetroArch\cores" -aoa
cls
echo ================================================
echo =         Cleaning up downloaded files         =
echo ================================================
ping 127.0.0.1 -n 4 >nul
rmdir "C:\RetroCake\Temp\cores" /s /q
IF EXIST C:\RetroCake\Temp\BrandNewBlank goto InstallAllEmu
IF EXIST C:\RetroCake\Temp\BrandNewDef goto InstallAllEmu
IF EXIST C:\RetroCake\Temp\BrandNewCus goto InstallAllEmu
goto completed

::=================================================================================================================================================================================================================================================================================================================
::=================================================================================================================================================================================================================================================================================================================
::=================================================================================================================================================================================================================================================================================================================
::=================================================================================================================================================================================================================================================================================================================
::=================================================================================================================================================================================================================================================================================================================

:SysClean
cls
echo ===========================================================================
echo =                                                                         =
Echo =    1.) REMOVE ALL RETROCAKE FILES                                       =
echo =                                                                         =
echo =    2.) REMOVE EMULATIONSTATION AND PREFERENCES                          =
echo =                                                                         =
echo =    3.) REMOVE RETROARCH AND PREFERENCES                                 =
echo =                                                                         =
echo =    4.) REMOVE ADDITIONAL EMULATORS AND PREFERENCES                      =
echo =                                                                         =
echo =    5.) REMOVE RETROCAKE TOOLS (GIT AND 7ZA)                             =
echo =                                                                         =
echo =                                                                         =
echo =    6.) EXIT                                                             =
echo =                                                                         =
echo ===========================================================================
CHOICE /N /C:1234567 /M "Enter Corresponding Menu choice (1, 2, 3, 4, 5, 6, 7)"%1
IF ERRORLEVEL ==6 GOTO menu
IF ERRORLEVEL ==5 GOTO CleanTools
IF ERRORLEVEL ==4 GOTO CleanEmu
IF ERRORLEVEL ==3 GOTO CleanRA
IF ERRORLEVEL ==2 GOTO CleanES
IF ERRORLEVEL ==1 GOTO CleanAll

:CleanAll
cls
echo(
set /P c=Are you sure you want to delete ALL RetroCake Files (Includes Settings)[Y/N]?
if /I "%c%" EQU "Y" goto delall
if /I "%c%" EQU "N" goto menu

:delall
cls
echo =====================================================
echo =                                                   =
Echo = DELETING ALL RETROARCH AND EMULATIONSTATION FILES =
echo =                                                   =
echo =====================================================
cd C:\
IF EXIST C:\RetroCake\ROMS\ move C:\RetroCake\ROMS C:\ROMS
del "%USERPROFILE%\Desktop\RetroCake.lnk"
rmdir "C:\RetroCake" /s /q
rmdir "%USERPROFILE%\.emulationstation" /s /q
goto CleanAllExit

:CleanES
cls
echo(
set /P c=Are you sure you want to delete ALL RetroCake Files (Includes Settings)[Y/N]?
if /I "%c%" EQU "Y" goto delES
if /I "%c%" EQU "N" goto menu

:delES
cls
echo =====================================================
echo =                                                   =
Echo =          DELETING EMULATIONSTATION FILES          =
echo =                                                   =
echo =====================================================
del "%USERPROFILE%\Desktop\RetroCake"
rmdir C:\RetroCake\EmulationStation /s /q
rmdir "%USERPROFILE%\.emulationstation" /s /q
goto CleanAllExit

:CleanRA
cls
echo(
set /P c=Are you sure you want to delete ALL RetroArch Files (Includes Settings)[Y/N]?
if /I "%c%" EQU "Y" goto delRA
if /I "%c%" EQU "N" goto menu

:delRA
cls
echo =====================================================
echo =                                                   =
Echo =             DELETING RETROARCH FILES              =
echo =                                                   =
echo =====================================================
rmdir C:\RetroCake\RetroArch /s /q
goto CleanAllExit

:CleanEmu
cls
echo(
set /P c=Are you sure you want to delete ALL Additional Emulators (Includes Settings)[Y/N]?
if /I "%c%" EQU "Y" goto delEmu
if /I "%c%" EQU "N" goto menu

:delEmu
cls
echo =====================================================
echo =                                                   =
Echo =        DELETING ADDITIONAL EMULATORS FILES        =
echo =                                                   =
echo =====================================================
rmdir C:\RetroCake\Emulators /s /q
goto CleanAllExit

:CleanTools
cls
echo(
set /P c=Are you sure you want to delete ALL RetroCake tools (Includes Settings)[Y/N]?
if /I "%c%" EQU "Y" goto delTools
if /I "%c%" EQU "N" goto menu

:delTools
cls
echo =====================================================
echo =                                                   =
Echo =             DELETING RETROCAKE TOOLS              =
echo =                                                   =
echo =====================================================
rmdir C:\RetroCake\Tools /s /q
goto CleanAllExit


::=================================================================================================================================================================================================================================================================================================================
::=================================================================================================================================================================================================================================================================================================================
::=================================================================================================================================================================================================================================================================================================================
::=================================================================================================================================================================================================================================================================================================================
::=================================================================================================================================================================================================================================================================================================================

:ThemeManager
cls
echo ===========================================================================
echo =                                                                         =
Echo =    1.) INSTALL/UPDATE ALL EMULATIONSTATION THEMES                       =
echo =                                                                         =
echo =    2.) INSTALL/UPDATE INDIVIDUAL THEMES                                 =
echo =                                                                         =
echo =    3.) THEME GALLERY/PREVIEWS                                           =
echo =                                                                         =
echo =    4.) EXIT THEME MANAGER                                               =
echo =                                                                         =
echo ===========================================================================
CHOICE /N /C:1234 /M "Enter Corresponding Menu choice (1, 2, 3, 4)"%1
IF ERRORLEVEL ==4 GOTO menu
IF ERRORLEVEL ==3 GOTO ThemeGallerySetupCheck
IF ERRORLEVEL ==2 GOTO IndThemes
IF ERRORLEVEL ==1 GOTO AllThemes

:ThemeGallerySetupCheck
IF EXIST "%USERPROFILE%\.emulationstation\es-theme-gallery\carbon.png" goto ThemeGallery
goto ThemeGallerySetup

:ThemeGallerySetup
cd "%USERPROFILE%\.emulationstation"
C:\RetroCake\Tools\git\bin\git.exe clone --recursive https://github.com/wetriner/es-theme-gallery.git
goto ThemeGallery

:ThemeGallery
cd "%USERPROFILE%\.emulationstation\es-theme-gallery"
for %%i in (*.png) do echo ^<img src="%%i" title="%%~ni" height="400" width="600" /^> >> Gallery.html
start Gallery.html
cls
echo ===========================================================================
echo =                                                                         =
Echo =       HOVER OVER ANY IMAGE TO SEE WHICH THEME IT BELONGS TO             =
echo =            PRESS ANY KEY WHEN DONE BROWSING THE GALLERY                 =
echo =                                                                         =
echo ===========================================================================
pause > nul
del Gallery.html
goto ThemeManager

:AllThemes

cd "%USERPROFILE%\.emulationstation\themes"

set repo=RetroPie
set theme=carbon
rmdir %theme% /S /Q
C:\RetroCake\Tools\git\bin\git.exe clone --recursive https://github.com/%repo%/es-theme-%theme%.git %theme%
set repo=RetroPie
set theme=carbon-centered
rmdir %theme% /S /Q
C:\RetroCake\Tools\git\bin\git.exe clone --recursive https://github.com/%repo%/es-theme-%theme%.git %theme%
set repo=RetroPie
set theme=carbon-nometa
rmdir %theme% /S /Q
C:\RetroCake\Tools\git\bin\git.exe clone --recursive https://github.com/%repo%/es-theme-%theme%.git %theme%
set repo=RetroPie
set theme=simple
rmdir %theme% /S /Q
C:\RetroCake\Tools\git\bin\git.exe clone --recursive https://github.com/%repo%/es-theme-%theme%.git %theme%
set repo=RetroPie
set theme=simple-dark
rmdir %theme% /S /Q
C:\RetroCake\Tools\git\bin\git.exe clone --recursive https://github.com/%repo%/es-theme-%theme%.git %theme%
set repo=RetroPie
set theme=clean-look
rmdir %theme% /S /Q
C:\RetroCake\Tools\git\bin\git.exe clone --recursive https://github.com/%repo%/es-theme-%theme%.git %theme%
set repo=RetroPie
set theme=color-pi
rmdir %theme% /S /Q
C:\RetroCake\Tools\git\bin\git.exe clone --recursive https://github.com/%repo%/es-theme-%theme%.git %theme%
set repo=RetroPie
set theme=nbba
rmdir %theme% /S /Q
C:\RetroCake\Tools\git\bin\git.exe clone --recursive https://github.com/%repo%/es-theme-%theme%.git %theme%
set repo=RetroPie
set theme=simplified-static-canela
rmdir %theme% /S /Q
C:\RetroCake\Tools\git\bin\git.exe clone --recursive https://github.com/%repo%/es-theme-%theme%.git %theme%
set repo=RetroPie
set theme=turtle-pi
rmdir %theme% /S /Q
C:\RetroCake\Tools\git\bin\git.exe clone --recursive https://github.com/%repo%/es-theme-%theme%.git %theme%
set repo=RetroPie
set theme=zoid
rmdir %theme% /S /Q
C:\RetroCake\Tools\git\bin\git.exe clone --recursive https://github.com/%repo%/es-theme-%theme%.git %theme%
set repo=ehettervik
set theme=pixel
rmdir %theme% /S /Q
C:\RetroCake\Tools\git\bin\git.exe clone --recursive https://github.com/%repo%/es-theme-%theme%.git %theme%
set repo=ehettervik
set theme=pixel-metadata
rmdir %theme% /S /Q
C:\RetroCake\Tools\git\bin\git.exe clone --recursive https://github.com/%repo%/es-theme-%theme%.git %theme%
set repo=ehettervik
set theme=pixel-tft
rmdir %theme% /S /Q
C:\RetroCake\Tools\git\bin\git.exe clone --recursive https://github.com/%repo%/es-theme-%theme%.git %theme%
set repo=ehettervik
set theme=luminous
rmdir %theme% /S /Q
C:\RetroCake\Tools\git\bin\git.exe clone --recursive https://github.com/%repo%/es-theme-%theme%.git %theme%
set repo=ehettervik
set theme=minilumi
rmdir %theme% /S /Q
C:\RetroCake\Tools\git\bin\git.exe clone --recursive https://github.com/%repo%/es-theme-%theme%.git %theme%
set repo=ehettervik
set theme=workbench
rmdir %theme% /S /Q
C:\RetroCake\Tools\git\bin\git.exe clone --recursive https://github.com/%repo%/es-theme-%theme%.git %theme%
set repo=AmadhiX
set theme=eudora
rmdir %theme% /S /Q
C:\RetroCake\Tools\git\bin\git.exe clone --recursive https://github.com/%repo%/es-theme-%theme%.git %theme%
set repo=AmadhiX
set theme=eudora-bigshot
rmdir %theme% /S /Q
C:\RetroCake\Tools\git\bin\git.exe clone --recursive https://github.com/%repo%/es-theme-%theme%.git %theme%
set repo=AmadhiX
set theme=eudora-concise
rmdir %theme% /S /Q
C:\RetroCake\Tools\git\bin\git.exe clone --recursive https://github.com/%repo%/es-theme-%theme%.git %theme%
set repo=ChoccyHobNob
set theme=eudora-updated
rmdir %theme% /S /Q
C:\RetroCake\Tools\git\bin\git.exe clone --recursive https://github.com/%repo%/es-theme-%theme%.git %theme%
set repo=InsecureSpike
set theme=retroplay-clean-canela
rmdir %theme% /S /Q
C:\RetroCake\Tools\git\bin\git.exe clone --recursive https://github.com/%repo%/es-theme-%theme%.git %theme%
set repo=InsecureSpike
set theme=retroplay-clean-detail-canela
rmdir %theme% /S /Q
C:\RetroCake\Tools\git\bin\git.exe clone --recursive https://github.com/%repo%/es-theme-%theme%.git %theme%
set repo=Omnija
set theme=simpler-turtlepi
rmdir %theme% /S /Q
C:\RetroCake\Tools\git\bin\git.exe clone --recursive https://github.com/%repo%/es-theme-%theme%.git %theme%
set repo=Omnija
set theme=simpler-turtlemini
rmdir %theme% /S /Q
C:\RetroCake\Tools\git\bin\git.exe clone --recursive https://github.com/%repo%/es-theme-%theme%.git %theme%
set repo=Omnija
set theme=metro
rmdir %theme% /S /Q
C:\RetroCake\Tools\git\bin\git.exe clone --recursive https://github.com/%repo%/es-theme-%theme%.git %theme%
set repo=lilbud
set theme=material
rmdir %theme% /S /Q
C:\RetroCake\Tools\git\bin\git.exe clone --recursive https://github.com/%repo%/es-theme-%theme%.git %theme%
set repo=mattrixk
set theme=io
rmdir %theme% /S /Q
C:\RetroCake\Tools\git\bin\git.exe clone --recursive https://github.com/%repo%/es-theme-%theme%.git %theme%
set repo=mattrixk
set theme=metapixel
rmdir %theme% /S /Q
C:\RetroCake\Tools\git\bin\git.exe clone --recursive https://github.com/%repo%/es-theme-%theme%.git %theme%
set repo=mattrixk
set theme=spare
rmdir %theme% /S /Q
C:\RetroCake\Tools\git\bin\git.exe clone --recursive https://github.com/%repo%/es-theme-%theme%.git %theme%
set repo=robertybob
set theme=space
rmdir %theme% /S /Q
C:\RetroCake\Tools\git\bin\git.exe clone --recursive https://github.com/%repo%/es-theme-%theme%.git %theme%
set repo=robertybob
set theme=simplebigart
rmdir %theme% /S /Q
C:\RetroCake\Tools\git\bin\git.exe clone --recursive https://github.com/%repo%/es-theme-%theme%.git %theme%
set repo=robertybob
set theme=tv
rmdir %theme% /S /Q
C:\RetroCake\Tools\git\bin\git.exe clone --recursive https://github.com/%repo%/es-theme-%theme%.git %theme%
set repo=HerbFargus
set theme=tronkyfran
rmdir %theme% /S /Q
C:\RetroCake\Tools\git\bin\git.exe clone --recursive https://github.com/%repo%/es-theme-%theme%.git %theme%
set repo=lilbud
set theme=flat
rmdir %theme% /S /Q
C:\RetroCake\Tools\git\bin\git.exe clone --recursive https://github.com/%repo%/es-theme-%theme%.git %theme%
set repo=lilbud
set theme=flat-dark
rmdir %theme% /S /Q
C:\RetroCake\Tools\git\bin\git.exe clone --recursive https://github.com/%repo%/es-theme-%theme%.git %theme%
set repo=lilbud
set theme=minimal
rmdir %theme% /S /Q
C:\RetroCake\Tools\git\bin\git.exe clone --recursive https://github.com/%repo%/es-theme-%theme%.git %theme%
set repo=lilbud
set theme=switch-light
rmdir %theme% /S /Q
C:\RetroCake\Tools\git\bin\git.exe clone --recursive https://github.com/%repo%/es-theme-%theme%.git %theme%
set repo=lilbud
set theme=switch-dark
rmdir %theme% /S /Q
C:\RetroCake\Tools\git\bin\git.exe clone --recursive https://github.com/%repo%/es-theme-%theme%.git %theme%
set repo=FlyingTomahawk
set theme=futura-V
rmdir %theme% /S /Q
C:\RetroCake\Tools\git\bin\git.exe clone --recursive https://github.com/%repo%/es-theme-%theme%.git %theme%
set repo=FlyingTomahawk
set theme=futura-dark-V
rmdir %theme% /S /Q
C:\RetroCake\Tools\git\bin\git.exe clone --recursive https://github.com/%repo%/es-theme-%theme%.git %theme%
set repo=G-rila
set theme=fundamental
rmdir %theme% /S /Q
C:\RetroCake\Tools\git\bin\git.exe clone --recursive https://github.com/%repo%/es-theme-%theme%.git %theme%
set repo=ruckage
set theme=nes-mini
rmdir %theme% /S /Q
C:\RetroCake\Tools\git\bin\git.exe clone --recursive https://github.com/%repo%/es-theme-%theme%.git %theme%
set repo=ruckage
set theme=famicom-mini
rmdir %theme% /S /Q
C:\RetroCake\Tools\git\bin\git.exe clone --recursive https://github.com/%repo%/es-theme-%theme%.git %theme%
set repo=ruckage
set theme=snes-mini
rmdir %theme% /S /Q
C:\RetroCake\Tools\git\bin\git.exe clone --recursive https://github.com/%repo%/es-theme-%theme%.git %theme%
set repo=anthonycaccese
set theme=crt
rmdir %theme% /S /Q
C:\RetroCake\Tools\git\bin\git.exe clone --recursive https://github.com/%repo%/es-theme-%theme%.git %theme%
set repo=anthonycaccese
set theme=crt-centered
rmdir %theme% /S /Q
C:\RetroCake\Tools\git\bin\git.exe clone --recursive https://github.com/%repo%/es-theme-%theme%.git %theme%
set repo=anthonycaccese
set theme=art-book
rmdir %theme% /S /Q
C:\RetroCake\Tools\git\bin\git.exe clone --recursive https://github.com/%repo%/es-theme-%theme%.git %theme%
set repo=anthonycaccese
set theme=art-book-4-3
rmdir %theme% /S /Q
C:\RetroCake\Tools\git\bin\git.exe clone --recursive https://github.com/%repo%/es-theme-%theme%.git %theme%
set repo=anthonycaccese
set theme=art-book-pocket
rmdir %theme% /S /Q
C:\RetroCake\Tools\git\bin\git.exe clone --recursive https://github.com/%repo%/es-theme-%theme%.git %theme%
set repo=anthonycaccese
set theme=tft
rmdir %theme% /S /Q
C:\RetroCake\Tools\git\bin\git.exe clone --recursive https://github.com/%repo%/es-theme-%theme%.git %theme%
set repo=TMNTturtleguy
set theme=ComicBook
rmdir %theme% /S /Q
C:\RetroCake\Tools\git\bin\git.exe clone --recursive https://github.com/%repo%/es-theme-%theme%.git %theme%
set repo=TMNTturtleguy
set theme=ComicBook_4-3
rmdir %theme% /S /Q
C:\RetroCake\Tools\git\bin\git.exe clone --recursive https://github.com/%repo%/es-theme-%theme%.git %theme%
set repo=TMNTturtleguy
set theme=ComicBook_SE-Wheelart
rmdir %theme% /S /Q
C:\RetroCake\Tools\git\bin\git.exe clone --recursive https://github.com/%repo%/es-theme-%theme%.git %theme%
set repo=TMNTturtleguy
set theme=ComicBook_4-3_SE-Wheelart
rmdir %theme% /S /Q
C:\RetroCake\Tools\git\bin\git.exe clone --recursive https://github.com/%repo%/es-theme-%theme%.git %theme%
set repo=ChoccyHobNob
set theme=cygnus
rmdir %theme% /S /Q
C:\RetroCake\Tools\git\bin\git.exe clone --recursive https://github.com/%repo%/es-theme-%theme%.git %theme%
set repo=dmmarti
set theme=steampunk
rmdir %theme% /S /Q
C:\RetroCake\Tools\git\bin\git.exe clone --recursive https://github.com/%repo%/es-theme-%theme%.git %theme%
set repo=dmmarti
set theme=hurstyblue
rmdir %theme% /S /Q
C:\RetroCake\Tools\git\bin\git.exe clone --recursive https://github.com/%repo%/es-theme-%theme%.git %theme%
set repo=dmmarti
set theme=maximuspie
rmdir %theme% /S /Q
C:\RetroCake\Tools\git\bin\git.exe clone --recursive https://github.com/%repo%/es-theme-%theme%.git %theme%
set repo=dmmarti
set theme=showcase
rmdir %theme% /S /Q
C:\RetroCake\Tools\git\bin\git.exe clone --recursive https://github.com/%repo%/es-theme-%theme%.git %theme%
set repo=dmmarti
set theme=kidz
rmdir %theme% /S /Q
C:\RetroCake\Tools\git\bin\git.exe clone --recursive https://github.com/%repo%/es-theme-%theme%.git %theme%
set repo=lipebello
set theme=Retrorama
rmdir %theme% /S /Q
C:\RetroCake\Tools\git\bin\git.exe clone --recursive https://github.com/%repo%/es-theme-%theme%.git %theme%
set repo=lipebello
set theme=SpaceOddity
rmdir %theme% /S /Q
C:\RetroCake\Tools\git\bin\git.exe clone --recursive https://github.com/%repo%/es-theme-%theme%.git %theme%
set repo=rxbrad
set theme=gbz35
rmdir %theme% /S /Q
C:\RetroCake\Tools\git\bin\git.exe clone --recursive https://github.com/%repo%/es-theme-%theme%.git %theme%
set repo=rxbrad
set theme=gbz35-dark
rmdir %theme% /S /Q
C:\RetroCake\Tools\git\bin\git.exe clone --recursive https://github.com/%repo%/es-theme-%theme%.git %theme%
set repo=garaine
set theme=marioblue
rmdir %theme% /S /Q
C:\RetroCake\Tools\git\bin\git.exe clone --recursive https://github.com/%repo%/es-theme-%theme%.git %theme%
set repo=garaine
set theme=bigwood
rmdir %theme% /S /Q
C:\RetroCake\Tools\git\bin\git.exe clone --recursive https://github.com/%repo%/es-theme-%theme%.git %theme%
set repo=MrTomixf
set theme=Royal_Primicia
rmdir %theme% /S /Q
C:\RetroCake\Tools\git\bin\git.exe clone --recursive https://github.com/%repo%/es-theme-%theme%.git %theme%
set repo=RetroHursty69
set theme=magazinemadness
rmdir %theme% /S /Q
C:\RetroCake\Tools\git\bin\git.exe clone --recursive https://github.com/%repo%/es-theme-%theme%.git %theme%
set repo=RetroHursty69
set theme=stirling
rmdir %theme% /S /Q
C:\RetroCake\Tools\git\bin\git.exe clone --recursive https://github.com/%repo%/es-theme-%theme%.git %theme%
set repo=lostless
set theme=playstation
rmdir %theme% /S /Q
C:\RetroCake\Tools\git\bin\git.exe clone --recursive https://github.com/%repo%/es-theme-%theme%.git %theme%
set repo=mrharias
set theme=superdisplay
rmdir %theme% /S /Q
C:\RetroCake\Tools\git\bin\git.exe clone --recursive https://github.com/%repo%/es-theme-%theme%.git %theme%
set repo=coinjunkie
set theme=synthwave
rmdir %theme% /S /Q
C:\RetroCake\Tools\git\bin\git.exe clone --recursive https://github.com/%repo%/es-theme-%theme%.git %theme%
set repo=RetroHursty69
set theme=boxalloyred
rmdir %theme% /S /Q
C:\RetroCake\Tools\git\bin\git.exe clone --recursive https://github.com/%repo%/es-theme-%theme%.git %theme%
set repo=RetroHursty69
set theme=boxalloyblue
rmdir %theme% /S /Q
C:\RetroCake\Tools\git\bin\git.exe clone --recursive https://github.com/%repo%/es-theme-%theme%.git %theme%
set repo=RetroHursty69
set theme=greenilicious
rmdir %theme% /S /Q
C:\RetroCake\Tools\git\bin\git.exe clone --recursive https://github.com/%repo%/es-theme-%theme%.git %theme%
set repo=RetroHursty69
set theme=retroroid
rmdir %theme% /S /Q
C:\RetroCake\Tools\git\bin\git.exe clone --recursive https://github.com/%repo%/es-theme-%theme%.git %theme%
set repo=RetroHursty69
set theme=merryxmas
rmdir %theme% /S /Q
C:\RetroCake\Tools\git\bin\git.exe clone --recursive https://github.com/%repo%/es-theme-%theme%.git %theme%
set repo=Saracade
set theme=scv720
rmdir %theme% /S /Q
C:\RetroCake\Tools\git\bin\git.exe clone --recursive https://github.com/%repo%/es-theme-%theme%.git %theme%

goto ThemeManager

:IndThemes
:page1
cls
echo ===========================================================================
echo =                               Page 1                                    =
Echo =    1.) CARBON                                                           =
echo =    2.) CARBON-CENTERED                                                  =
echo =    3.) CARBON-NOMETA                                                    =
echo =    4.) SIMPLE                                                           =
echo =    5.) SIMPLE-DARK                                                      =
echo =    6.) CLEAN-LOOK                                                       =
echo =    7.) COLOR-PI                                                         =
echo =    8.) NBBA                                                             =
echo =                                                                         =
echo =    9.) Page 2                                                           =
echo =                                                                         =
echo ===========================================================================
CHOICE /N /C:123456789 /M "Enter Corresponding Menu choice (1, 2, 3, 4, 5, 6, 7, 8, 9)"%1
IF ERRORLEVEL ==9 GOTO page2
IF ERRORLEVEL ==8 goto nbba 
IF ERRORLEVEL ==7 goto color-pi 
IF ERRORLEVEL ==6 goto clean-look 
IF ERRORLEVEL ==5 goto simple-dark 
IF ERRORLEVEL ==4 goto simple 
IF ERRORLEVEL ==3 goto carbon-nometa 
IF ERRORLEVEL ==2 goto carbon-centered 
IF ERRORLEVEL ==1 goto carbon 

:page2
cls
echo ===========================================================================
echo =                               Page 2                                    =
Echo =    1.) SIMPLIFIED-STATIC-CANELA                                         =
echo =    2.) TURTLE-PI                                                        =
echo =    3.) ZOID                                                             =
echo =    4.) PIXEL                                                            =
echo =    5.) PIXEL-METADATA                                                   =
echo =    6.) PIXEL-TFT                                                        =
echo =    7.) LUMINOUS                                                         =
echo =    8.) MINILUMI                                                         =
echo =                                                                         =
echo =    9.) Page 3                                                           =
echo =                                                                         =
echo ===========================================================================
CHOICE /N /C:123456789 /M "Enter Corresponding Menu choice (1, 2, 3, 4, 5, 6, 7, 8, 9)"%1
IF ERRORLEVEL ==9 GOTO page3
IF ERRORLEVEL ==8 goto minilumi
IF ERRORLEVEL ==7 goto luminous
IF ERRORLEVEL ==6 goto pixel-tft
IF ERRORLEVEL ==5 goto pixel-metadata
IF ERRORLEVEL ==4 goto pixel
IF ERRORLEVEL ==3 goto zoid
IF ERRORLEVEL ==2 goto turtle-pi 
IF ERRORLEVEL ==1 goto simplified-static-canela

:page3
cls
echo ===========================================================================
echo =                               Page 3                                    =
Echo =    1.) WORKBENCH                                                        =
echo =    2.) EUDORA                                                           =
echo =    3.) EUDORA-BIGSHOT                                                   =
echo =    4.) EUDORA-CONCISE                                                   =
echo =    5.) EUDORA-UPDATED                                                   =
echo =    6.) RETROPLAY-CLEAN-CANELA                                           =
echo =    7.) RETROPLAY-CLEAN-DETAIL-CANELA                                    =
echo =    8.) SIMPLER-TURTLEPI                                                 =
echo =                                                                         =
echo =    9.) Page 4                                                           =
echo =                                                                         =
echo ===========================================================================
CHOICE /N /C:123456789 /M "Enter Corresponding Menu choice (1, 2, 3, 4, 5, 6, 7, 8, 9)"%1
IF ERRORLEVEL ==9 GOTO page4
IF ERRORLEVEL ==8 goto simpler-turtlepi
IF ERRORLEVEL ==7 goto retroplay-clean-detail-canela
IF ERRORLEVEL ==6 goto retroplay-clean-canela
IF ERRORLEVEL ==5 goto eudora-updated
IF ERRORLEVEL ==4 goto eudora-concise
IF ERRORLEVEL ==3 goto eudora-bigshot
IF ERRORLEVEL ==2 goto eudora
IF ERRORLEVEL ==1 goto workbench

:page4
cls
echo ===========================================================================
echo =                               Page 4                                    =
Echo =    1.) SIMPLER-TURTLEMINI                                               =
echo =    2.) METRO                                                            =
echo =    3.) MATERIAL                                                         =
echo =    4.) IO                                                               =
echo =    5.) METAPIXEL                                                        =
echo =    6.) SPARE                                                            =
echo =    7.) SPACE                                                            =
echo =    8.) SIMPLEBIGART                                                     =
echo =                                                                         =
echo =    9.) Page 5                                                           =
echo =                                                                         =
echo ===========================================================================
CHOICE /N /C:123456789 /M "Enter Corresponding Menu choice (1, 2, 3, 4, 5, 6, 7, 8, 9)"%1
IF ERRORLEVEL ==9 GOTO page5
IF ERRORLEVEL ==8 goto simplebigart
IF ERRORLEVEL ==7 goto space
IF ERRORLEVEL ==6 goto spare
IF ERRORLEVEL ==5 goto metapixel
IF ERRORLEVEL ==4 goto io
IF ERRORLEVEL ==3 goto material
IF ERRORLEVEL ==2 goto metro
IF ERRORLEVEL ==1 goto simpler-turtlemini

:page5
cls
echo ===========================================================================
echo =                               Page 5                                    =
Echo =    1.) TV                                                               =
echo =    2.) TRONKYFRAN                                                       =
echo =    3.) FLAT                                                             =
echo =    4.) FLAT-DARK                                                        =
echo =    5.) MINIMAL                                                          =
echo =    6.) SWITCH-LIGHT                                                     =
echo =    7.) SWITCH-DARK                                                      =
echo =    8.) FUTURA-V                                                         =
echo =                                                                         =
echo =    9.) Page 6                                                           =
echo =                                                                         =
echo ===========================================================================
CHOICE /N /C:123456789 /M "Enter Corresponding Menu choice (1, 2, 3, 4, 5, 6, 7, 8, 9)"%1
IF ERRORLEVEL ==9 GOTO page6
IF ERRORLEVEL ==8 goto futura-V
IF ERRORLEVEL ==7 goto switch-dark
IF ERRORLEVEL ==6 goto switch-light
IF ERRORLEVEL ==5 goto minimal
IF ERRORLEVEL ==4 goto flat-dark
IF ERRORLEVEL ==3 goto flat
IF ERRORLEVEL ==2 goto tronkyfran
IF ERRORLEVEL ==1 goto tv

:page6
cls
echo ===========================================================================
echo =                               Page 6                                    =
Echo =    1.) FUTURA-DARK-V                                                    =
echo =    2.) FUNDAMENTAL                                                      =
echo =    3.) NES-MINI                                                         =
echo =    4.) FAMICOM-MINI                                                     =
echo =    5.) SNES-MINI                                                        =
echo =    6.) CRT                                                              =
echo =    7.) CRT-CENTERED                                                     =
echo =    8.) ART-BOOK                                                         =
echo =                                                                         =
echo =    9.) Page 7                                                           =
echo =                                                                         =
echo ===========================================================================
CHOICE /N /C:123456789 /M "Enter Corresponding Menu choice (1, 2, 3, 4, 5, 6, 7, 8, 9)"%1
IF ERRORLEVEL ==9 GOTO page7
IF ERRORLEVEL ==8 goto art-book
IF ERRORLEVEL ==7 goto crt-centered
IF ERRORLEVEL ==6 goto crt
IF ERRORLEVEL ==5 goto snesminiind
IF ERRORLEVEL ==4 goto famicom-mini
IF ERRORLEVEL ==3 goto nes-mini
IF ERRORLEVEL ==2 goto fundamental
IF ERRORLEVEL ==1 goto futura-dark-V

:page7
cls
echo ===========================================================================
echo =                               Page 7                                    =
Echo =    1.) ART-BOOK-4-3                                                     =
echo =    2.) ART-BOOK-POCKET                                                  =
echo =    3.) TFT                                                              =
echo =    4.) COMICBOOK                                                        =
echo =    5.) COMICBOOK_4-3                                                    =
echo =    6.) COMICBOOK_SE-WHEELART                                            =
echo =    7.) COMICBOOK_4-3_SE-WHEELART                                        =
echo =    8.) CYGNUS                                                           =
echo =                                                                         =
echo =    9.) Page 8                                                           =
echo =                                                                         =
echo ===========================================================================
CHOICE /N /C:123456789 /M "Enter Corresponding Menu choice (1, 2, 3, 4, 5, 6, 7, 8, 9)"%1
IF ERRORLEVEL ==9 GOTO page8
IF ERRORLEVEL ==8 goto cygnus
IF ERRORLEVEL ==7 goto ComicBook_4-3_SE-Wheelart
IF ERRORLEVEL ==6 goto ComicBook_SE-Wheelart
IF ERRORLEVEL ==5 goto ComicBook_4-3
IF ERRORLEVEL ==4 goto ComicBook
IF ERRORLEVEL ==3 goto tft
IF ERRORLEVEL ==2 goto art-book-pocket
IF ERRORLEVEL ==1 goto art-book-4-3

:page8
cls
echo ===========================================================================
echo =                               Page 8                                    =
Echo =    1.) STEAMPUNK                                                        =
echo =    2.) HURSTYBLUE                                                       =
echo =    3.) MAXIMUSPIE                                                       =
echo =    4.) SHOWCASE                                                         =
echo =    5.) KIDZ                                                             =
echo =    6.) RETRORAMA                                                        =
echo =    7.) SPACEODDITY                                                      =
echo =    8.) GBZ35                                                            =
echo =                                                                         =
echo =    9.) Page 9                                                           =
echo =                                                                         =
echo ===========================================================================
CHOICE /N /C:123456789 /M "Enter Corresponding Menu choice (1, 2, 3, 4, 5, 6, 7, 8, 9)"%1
IF ERRORLEVEL ==9 GOTO page9
IF ERRORLEVEL ==8 goto gbz35
IF ERRORLEVEL ==7 goto SpaceOddity
IF ERRORLEVEL ==6 goto Retrorama
IF ERRORLEVEL ==5 goto kidz
IF ERRORLEVEL ==4 goto showcase
IF ERRORLEVEL ==3 goto maximuspie
IF ERRORLEVEL ==2 goto hurstyblue
IF ERRORLEVEL ==1 goto steampunk

:page9
cls
echo ===========================================================================
echo =                               Page 9                                    =
Echo =    1.) GBZ35-DARK                                                       =
echo =    2.) MARIOBLUE                                                        =
echo =    3.) BIGWOOD                                                          =
echo =    4.) ROYAL_PRIMICIA                                                   =
echo =    5.) MAGAZINEMADNESS                                                  =
echo =    6.) STIRLING                                                         =
echo =    7.) PLAYSTATION                                                      =
echo =    8.) SUPERDISPLAY                                                     =
echo =                                                                         =
echo =    9.) Page 10                                                          =
echo =                                                                         =
echo ===========================================================================
CHOICE /N /C:123456789 /M "Enter Corresponding Menu choice (1, 2, 3, 4, 5, 6, 7, 8, 9)"%1
IF ERRORLEVEL ==9 GOTO page10
IF ERRORLEVEL ==8 goto superdisplay
IF ERRORLEVEL ==7 goto playstation
IF ERRORLEVEL ==6 goto stirling
IF ERRORLEVEL ==5 goto magazinemadness
IF ERRORLEVEL ==4 goto Royal_Primicia
IF ERRORLEVEL ==3 goto bigwood
IF ERRORLEVEL ==2 goto marioblue
IF ERRORLEVEL ==1 goto gbz35-dark

:page10
cls
echo ===========================================================================
echo =                              Page 10                                    =
Echo =    1.) SCV720                                                           =
echo =    2.) MERRYXMAS                                                        =
echo =    3.) RETROROID                                                        =
echo =    4.) GREENILICIOUS                                                    =
echo =    5.) BOXALLOYBLUE                                                     =
echo =    6.) BOXALLOYRED                                                      =
echo =    7.) SYNTHWAVE                                                        =
echo =                                                                         =
echo =    8.) Return to ThemeManager                                           =
echo =                                                                         =
echo ===========================================================================
CHOICE /N /C:12345678 /M "Enter Corresponding Menu choice (1, 2, 3, 4, 5, 6, 7, 8)"%1
IF ERRORLEVEL ==8 goto ThemeManager
IF ERRORLEVEL ==7 goto synthwave
IF ERRORLEVEL ==6 goto boxalloyred
IF ERRORLEVEL ==5 goto boxalloyblue
IF ERRORLEVEL ==4 goto greenilicious
IF ERRORLEVEL ==3 goto retroroid
IF ERRORLEVEL ==2 goto merryxmas
IF ERRORLEVEL ==1 goto scv720

:carbon
set repo=RetroPie
set theme=carbon
goto insttheme
:carbon-centered
set repo=RetroPie
set theme=carbon-centered
goto insttheme
:carbon-nometa
set repo=RetroPie
set theme=carbon-nometa
goto insttheme
:simple
set repo=RetroPie
set theme=simple
goto insttheme
:simple-dark
set repo=RetroPie
set theme=simple-dark
goto insttheme
:clean-look
set repo=RetroPie
set theme=clean-look
goto insttheme
:color-pi
set repo=RetroPie
set theme=color-pi
goto insttheme
:nbba
set repo=RetroPie
set theme=nbba
goto insttheme
:simplified-static-canela
set repo=RetroPie
set theme=simplified-static-canela
goto insttheme
:turtle-pi
set repo=RetroPie
set theme=turtle-pi
goto insttheme
:zoid
set repo=RetroPie
set theme=zoid
goto insttheme
:pixel
set repo=ehettervik
set theme=pixel
goto insttheme
:pixel-metadata
set repo=ehettervik
set theme=pixel-metadata
goto insttheme
:pixel-tft
set repo=ehettervik
set theme=pixel-tft
goto insttheme
:luminous
set repo=ehettervik
set theme=luminous
goto insttheme
:minilumi
set repo=ehettervik
set theme=minilumi
goto insttheme
:workbench
set repo=ehettervik
set theme=workbench
goto insttheme
:eudora
set repo=AmadhiX
set theme=eudora
goto insttheme
:eudora-bigshot
set repo=AmadhiX
set theme=eudora-bigshot
goto insttheme
:eudora-concise
set repo=AmadhiX
set theme=eudora-concise
goto insttheme
:eudora-updated
set repo=ChoccyHobNob
set theme=eudora-updated
goto insttheme
:retroplay-clean-canela
set repo=InsecureSpike
set theme=retroplay-clean-canela
goto insttheme
:retroplay-clean-detail-canela
set repo=InsecureSpike
set theme=retroplay-clean-detail-canela
goto insttheme
:simpler-turtlepi
set repo=Omnija
set theme=simpler-turtlepi
goto insttheme
:simpler-turtlemini
set repo=Omnija
set theme=simpler-turtlemini
goto insttheme
:metro
set repo=Omnija
set theme=metro
goto insttheme
:material
set repo=lilbud
set theme=material
goto insttheme
:io
set repo=mattrixk
set theme=io
goto insttheme
:metapixel
set repo=mattrixk
set theme=metapixel
goto insttheme
:spare
set repo=mattrixk
set theme=spare
goto insttheme
:space
set repo=robertybob
set theme=space
goto insttheme
:simplebigart
set repo=robertybob
set theme=simplebigart
goto insttheme
:tv
set repo=robertybob
set theme=tv
goto insttheme
:tronkyfran
set repo=HerbFargus
set theme=tronkyfran
goto insttheme
:flat
set repo=lilbud
set theme=flat
goto insttheme
:flat-dark
set repo=lilbud
set theme=flat-dark
goto insttheme
:minimal
set repo=lilbud
set theme=minimal
goto insttheme
:switch-light
set repo=lilbud
set theme=switch-light
goto insttheme
:switch-dark
set repo=lilbud
set theme=switch-dark
goto insttheme
:futura-V
set repo=FlyingTomahawk
set theme=futura-V
goto insttheme
:futura-dark-V
set repo=FlyingTomahawk
set theme=futura-dark-V
goto insttheme
:fundamental
set repo=G-rila
set theme=fundamental
goto insttheme
:nes-mini
set repo=ruckage
set theme=nes-mini
goto insttheme
:famicom-mini
set repo=ruckage
set theme=famicom-mini
goto insttheme
:snesminiind
set repo=ruckage
set theme=snes-mini
goto insttheme
:crt
set repo=anthonycaccese
set theme=crt
goto insttheme
:crt-centered
set repo=anthonycaccese
set theme=crt-centered
goto insttheme
:art-book
set repo=anthonycaccese
set theme=art-book
goto insttheme
:art-book-4-3
set repo=anthonycaccese
set theme=art-book-4-3
goto insttheme
:art-book-pocket
set repo=anthonycaccese
set theme=art-book-pocket
goto insttheme
:tft
set repo=anthonycaccese
set theme=tft
goto insttheme
:ComicBook
set repo=TMNTturtleguy
set theme=ComicBook
goto insttheme
:ComicBook_4-3
set repo=TMNTturtleguy
set theme=ComicBook_4-3
goto insttheme
:ComicBook_SE-Wheelart
set repo=TMNTturtleguy
set theme=ComicBook_SE-Wheelart
goto insttheme
:ComicBook_4-3_SE-Wheelart
set repo=TMNTturtleguy
set theme=ComicBook_4-3_SE-Wheelart
goto insttheme
:cygnus
set repo=ChoccyHobNob
set theme=cygnus
goto insttheme
:steampunk
set repo=dmmarti
set theme=steampunk
goto insttheme
:hurstyblue
set repo=dmmarti
set theme=hurstyblue
goto insttheme
:maximuspie
set repo=dmmarti
set theme=maximuspie
goto insttheme
:showcase
set repo=dmmarti
set theme=showcase
goto insttheme
:kidz
set repo=dmmarti
set theme=kidz
goto insttheme
:Retrorama
set repo=lipebello
set theme=Retrorama
goto insttheme
:SpaceOddity
set repo=lipebello
set theme=SpaceOddity
goto insttheme
:gbz35
set repo=rxbrad
set theme=gbz35
goto insttheme
:gbz35-dark
set repo=rxbrad
set theme=gbz35-dark
goto insttheme
:marioblue
set repo=garaine
set theme=marioblue
goto insttheme
:bigwood
set repo=garaine
set theme=bigwood
goto insttheme
:Royal_Primicia
set repo=MrTomixf
set theme=Royal_Primicia
goto insttheme
:magazinemadness
set repo=RetroHursty69
set theme=magazinemadness
goto insttheme
:stirling
set repo=RetroHursty69
set theme=stirling
goto insttheme
:playstation
set repo=lostless
set theme=playstation
goto insttheme
:superdisplay
set repo=mrharias
set theme=superdisplay
goto insttheme
:synthwave
set repo=coinjunkie
set theme=synthwave
goto insttheme
:boxalloyred
set repo=RetroHursty69
set theme=boxalloyred
goto insttheme
:boxalloyblue
set repo=RetroHursty69
set theme=boxalloyblue
goto insttheme
:greenilicious
set repo=RetroHursty69
set theme=greenilicious
goto insttheme
:retroroid
set repo=RetroHursty69
set theme=retroroid
goto insttheme
:merryxmas
set repo=RetroHursty69
set theme=merryxmas
goto insttheme
:scv720
set repo=Saracade
set theme=scv720
goto insttheme

:insttheme
cd %USERPROFILE%\.emulationstation\themes
rmdir %theme% /S /Q
C:\RetroCake\Tools\git\bin\git.exe clone --recursive https://github.com/%repo%/es-theme-%theme%.git %theme%
goto ThemeManager

::=================================================================================================================================================================================================================================================================================================================
::=================================================================================================================================================================================================================================================================================================================
::=================================================================================================================================================================================================================================================================================================================
::=================================================================================================================================================================================================================================================================================================================
::=================================================================================================================================================================================================================================================================================================================

:AppleWin
cls
echo(
echo(
echo(
echo(
echo(
echo(
echo(
echo =================================================================
echo =                                                               =
echo =                     DOWNLOADING APPLEWIN                      =
echo =                                                               =
echo =================================================================
powershell -command "Invoke-WebRequest -Uri https://github.com/AppleWin/AppleWin/releases/download/v1.26.3.4/AppleWin1.26.3.4.zip -OutFile "C:\RetroCake\Temp\AppleWin.zip""
mkdir C:\RetroCake\Emulators\AppleWin
C:\RetroCake\Tools\7za\7za.exe x "C:\RetroCake\Temp\AppleWin.zip" -o"C:\RetroCake\Emulators\AppleWin" -aoa
cls
echo ================================================
echo =         Cleaning up downloaded files         =
echo ================================================
ping 127.0.0.1 -n 3 > nul
del C:\RetroCake\Temp\AppleWin.zip
if EXIST C:\RetroCake\Emulators\tmp.txt goto Hatari
goto completed

::=================================================================================================================================================================================================================================================================================================================

:Hatari
if "%PROCESSOR_ARCHITECTURE%"=="AMD64" (
		goto hatari64
	)
if "%PROCESSOR_ARCHITECTURE%"=="x86" (
		goto hatari32
	)

:hatari32
cls
echo(
echo(
echo(
echo(
echo(
echo(
echo(
echo =================================================================
echo =                                                               =
echo =                      DOWNLOADING HATARI                       =
echo =                                                               =
echo =================================================================
powershell -command "Invoke-WebRequest -Uri http://download.tuxfamily.org/hatari/2.0.0/hatari-2.0.0_windows.zip -OutFile "C:\RetroCake\Temp\Hatari32.zip""
C:\RetroCake\Tools\7za\7za.exe x "C:\RetroCake\Temp\Hatari32.zip" -o"C:\RetroCake\Emulators" -aoa
cls
echo ================================================
echo =         Cleaning up downloaded files         =
echo ================================================
ren hatari-2.0.0_windows Hatari
ping 127.0.0.1 -n 2 > nul
del C:\RetroCake\Temp\Hatari32.zip
if EXIST C:\RetroCake\Emulators\tmp.txt goto BeebEm
goto completed
	
:hatari64
cls
echo(
echo(
echo(
echo(
echo(
echo(
echo(
echo =================================================================
echo =                                                               =
echo =                      DOWNLOADING HATARI                       =
echo =                                                               =
echo =================================================================
powershell -command "Invoke-WebRequest -Uri http://download.tuxfamily.org/hatari/2.0.0/hatari-2.0.0_windows64.zip -OutFile "C:\RetroCake\Temp\Hatari64.zip""
C:\RetroCake\Tools\7za\7za.exe x "C:\RetroCake\Temp\Hatari64.zip" -o"C:\RetroCake\Emulators" -aoa
cls
echo ================================================
echo =         Cleaning up downloaded files         =
echo ================================================
ping 127.0.0.1 -n 2 > nul
cd C:\RetroCake\Emulators
ren hatari-2.0.0_windows64 Hatari
ping 127.0.0.1 -n 2 > nul
del C:\RetroCake\Temp\Hatari64.zip
if EXIST C:\RetroCake\Emulators\tmp.txt goto BeebEm
goto completed

::=================================================================================================================================================================================================================================================================================================================

:BeebEm
cls
echo(
echo(
echo(
echo(
echo(
echo(
echo(
echo =================================================================
echo =                                                               =
echo =                       DOWNLOADING BEEBEM                      =
echo =                                                               =
echo =================================================================
powershell -command "Invoke-WebRequest -Uri http://www.mkw.me.uk/beebem/BeebEm414.zip -OutFile "C:\RetroCake\Temp\BeebEm.zip""
C:\RetroCake\Tools\7za\7za.exe x "C:\RetroCake\Temp\BeebEm.zip" -o"C:\RetroCake\Emulators" -aoa
cls
echo ================================================
echo =         Cleaning up downloaded files         =
echo ================================================
ping 127.0.0.1 -n 2 > nul
del C:\RetroCake\Temp\BeebEm.zip
if EXIST C:\RetroCake\Emulators\tmp.txt goto XRoar
goto completed

::=================================================================================================================================================================================================================================================================================================================

:XRoar
if "%PROCESSOR_ARCHITECTURE%"=="AMD64" (
		goto xroar64
	)
if "%PROCESSOR_ARCHITECTURE%"=="x86" (
		goto xroar32
	)

:xroar32
cls
echo(
echo(
echo(
echo(
echo(
echo(
echo(
echo =================================================================
echo =                                                               =
echo =                        DOWNLOADING XROAR                      =
echo =                                                               =
echo =================================================================
powershell -command "Invoke-WebRequest -Uri http://www.6809.org.uk/xroar/dl/xroar-0.34.8-w32.zip -OutFile "C:\RetroCake\Temp\XRoar32.zip""
C:\RetroCake\Tools\7za\7za.exe x "C:\RetroCake\Temp\XRoar32.zip" -o"C:\RetroCake\Emulators" -aoa
cls
echo ================================================
echo =         Cleaning up downloaded files         =
echo ================================================
ping 127.0.0.1 -n 2 > nul
cd C:\RetroCake\Emulators
ren xroar-0.34.8-w32 XRoar
ping 127.0.0.1 -n 2 > nul
del C:\RetroCake\Temp\XRoar32.zip
if EXIST C:\RetroCake\Emulators\tmp.txt goto Daphne
goto completed

:xroar64
cls
echo(
echo(
echo(
echo(
echo(
echo(
echo(
echo =================================================================
echo =                                                               =
echo =                        DOWNLOADING XROAR                      =
echo =                                                               =
echo =================================================================
powershell -command "Invoke-WebRequest -Uri http://www.6809.org.uk/xroar/dl/xroar-0.34.8-w64.zip -OutFile "C:\RetroCake\Temp\XRoar64.zip""
C:\RetroCake\Tools\7za\7za.exe x "C:\RetroCake\Temp\XRoar64.zip" -o"C:\RetroCake\Emulators" -aoa
cls
echo ================================================
echo =         Cleaning up downloaded files         =
echo ================================================
ping 127.0.0.1 -n 2 > nul
cd C:\RetroCake\Emulators
ren xroar-0.34.8-w64 XRoar
ping 127.0.0.1 -n 2 > nul
del C:\RetroCake\Temp\XRoar64.zip
if EXIST C:\RetroCake\Emulators\tmp.txt goto Daphne
goto completed

::=================================================================================================================================================================================================================================================================================================================

:Daphne
cls
echo(
echo(
echo(
echo(
echo(
echo(
echo(
echo =================================================================
echo =                                                               =
echo =                      DOWNLOADING DAPHNE                       =
echo =                                                               =
echo =================================================================
powershell -command "Invoke-WebRequest -Uri http://www.daphne-emu.com/download/daphne-1.0v-win32.zip -OutFile "C:\RetroCake\Temp\Daphne.zip""
mkdir C:\RetroCake\Emulators\Daphne
C:\RetroCake\Tools\7za\7za.exe x "C:\RetroCake\Temp\Daphne.zip" -o"C:\RetroCake\Emulators\Daphne" -aoa
cls
echo ================================================
echo =         Cleaning up downloaded files         =
echo ================================================
ping 127.0.0.1 -n 2 > nul
del C:\RetroCake\Temp\Daphne.zip
if EXIST C:\RetroCake\Emulators\tmp.txt goto jzIntv
goto completed

::=================================================================================================================================================================================================================================================================================================================

:jzIntv
cls
echo(
echo(
echo(
echo(
echo(
echo(
echo(
echo =================================================================
echo =                                                               =
echo =                       DOWNLOADING JZINTV                      =
echo =                                                               =
echo =================================================================
powershell -command "Invoke-WebRequest -Uri http://spatula-city.org/~im14u2c/intv/dl/jzintv-20171120-win32.zip -OutFile "C:\RetroCake\Temp\jzintv.zip""
C:\RetroCake\Tools\7za\7za.exe x "C:\RetroCake\Temp\jzintv.zip" -o"C:\RetroCake\Emulators" -aoa
cls
echo ================================================
echo =         Cleaning up downloaded files         =
echo ================================================
ping 127.0.0.1 -n 2 > nul
cd C:\RetroCake\Emulators
ren jzintv-20171120-win32 jzIntv
ping 127.0.0.1 -n 2 > nul
del C:\RetroCake\Temp\jzIntv.zip
if EXIST C:\RetroCake\Emulators\tmp.txt goto PCSX2
goto completed

::=================================================================================================================================================================================================================================================================================================================

:PCSX2
cls
echo(
echo(
echo(
echo(
echo(
echo(
echo(
echo =================================================================
echo =                                                               =
echo =                       DOWNLOADING PCSX2                       =
echo =                                                               =
echo =================================================================
powershell -command "Invoke-WebRequest -Uri http://www.emulator-zone.com/download.php/emulators/ps2/pcsx2/pcsx2-1.4.0-binaries.7z -OutFile "C:\RetroCake\Temp\PCSX2.zip""
C:\RetroCake\Tools\7za\7za.exe x "C:\RetroCake\Temp\PCSX2.zip" -o"C:\RetroCake\Emulators" -aoa
cls
echo ================================================
echo =         Cleaning up downloaded files         =
echo ================================================
ping 127.0.0.1 -n 2 > nul
cd C:\RetroCake\Emulators
ren "PCSX2 1.4.0" PCSX2
ping 127.0.0.1 -n 2 > nul
del C:\RetroCake\Temp\PCSX2.zip
if EXIST C:\RetroCake\Emulators\tmp.txt goto DolphinEmu
goto completed

::=================================================================================================================================================================================================================================================================================================================

:DolphinEmu
cls
echo(
echo(
echo(
echo(
echo(
echo(
echo(
echo =================================================================
echo =                                                               =
echo =                     DOWNLOADING DOLPHIN                       =
echo =                                                               =
echo =================================================================
powershell -command "Invoke-WebRequest -Uri https://download.visualstudio.microsoft.com/download/pr/11100230/15ccb3f02745c7b206ad10373cbca89b/VC_redist.x64.exe -OutFile "C:\RetroCake\Temp\VC_Redist_2017.exe""
powershell -command "Invoke-WebRequest -Uri https://dl.dolphin-emu.org/builds/dolphin-master-5.0-5938-x64.7z -OutFile "C:\RetroCake\Temp\Dolphin.7z""
C:\RetroCake\Tools\7za\7za.exe x "C:\RetroCake\Temp\Dolphin.7z" -o"C:\RetroCake\Emulators" -aoa
cls
echo ================================================
echo =         Cleaning up downloaded files         =
echo ================================================
C:\RetroCake\Temp\VC_Redist_2017.exe /install /quiet
ping 127.0.0.1 -n 2 > nul
cd C:\RetroCake\Emulators
ren Dolphin-x64 Dolphin
ping 127.0.0.1 -n 2 > nul
del C:\RetroCake\Temp\Dolphin.7z
del C:\RetroCake\Temp\VC_Redist_2017.exe
if EXIST C:\RetroCake\Emulators\tmp.txt goto VICE
goto completed

::=================================================================================================================================================================================================================================================================================================================

:VICE
if "%PROCESSOR_ARCHITECTURE%"=="AMD64" (
		goto VICE64
	)
if "%PROCESSOR_ARCHITECTURE%"=="x86" (
		goto VICE32
	)

:VICE32
cls
echo(
echo(
echo(
echo(
echo(
echo(
echo(
echo =================================================================
echo =                                                               =
echo =                       DOWNLOADING VICE                        =
echo =                                                               =
echo =================================================================
powershell -command "Invoke-WebRequest -Uri https://superb-sea2.dl.sourceforge.net/project/vice-emu/releases/binaries/windows/WinVICE-3.1-x86.7z -OutFile "C:\RetroCake\Temp\VICE32.zip""
C:\RetroCake\Tools\7za\7za.exe x "C:\RetroCake\Temp\VICE32.zip" -o"C:\RetroCake\Emulators" -aoa
cls
echo ================================================
echo =         Cleaning up downloaded files         =
echo ================================================
ping 127.0.0.1 -n 2 > nul
cd C:\RetroCake\Emulators
ren WinVICE-3.1-x86 WinVICE
ping 127.0.0.1 -n 2 > nul
del C:\RetroCake\Temp\VICE32.zip
if EXIST C:\RetroCake\Emulators\tmp.txt goto tmpClean
goto completed

:VICE64
cls
echo(
echo(
echo(
echo(
echo(
echo(
echo(
echo =================================================================
echo =                                                               =
echo =                       DOWNLOADING VICE                        =
echo =                                                               =
echo =================================================================
powershell -command "Invoke-WebRequest -Uri https://iweb.dl.sourceforge.net/project/vice-emu/releases/binaries/windows/WinVICE-3.1-x64.7z -OutFile "C:\RetroCake\Temp\VICE64.zip""
C:\RetroCake\Tools\7za\7za.exe x "C:\RetroCake\Temp\VICE64.zip" -o"C:\RetroCake\Emulators" -aoa
cls
echo ================================================
echo =         Cleaning up downloaded files         =
echo ================================================
ping 127.0.0.1 -n 2 > nul
cd C:\RetroCake\Emulators
ren WinVICE-3.1-x64 WinVICE
ping 127.0.0.1 -n 2 > nul
del C:\RetroCake\Temp\VICE64.zip
if EXIST C:\RetroCake\Emulators\tmp.txt goto tmpClean
goto completed

::=================================================================================================================================================================================================================================================================================================================

:tmpClean
del C:\RetroCake\Emulators\tmp.txt /s /q
IF EXIST C:\RetroCake\Temp\BrandNewBlank goto DediAsk
IF EXIST C:\RetroCake\Temp\BrandNewDef goto DediAsk
IF EXIST C:\RetroCake\Temp\BrandNewCus goto DediAsk
goto completed

::=================================================================================================================================================================================================================================================================================================================
::=================================================================================================================================================================================================================================================================================================================
::=================================================================================================================================================================================================================================================================================================================
::=================================================================================================================================================================================================================================================================================================================
::=================================================================================================================================================================================================================================================================================================================

::Informational Echoes
:erroorr
cls
echo =============================================
echo =                                           =
echo =          SOMETHING WENT WRONG D:          =
echo =                                           =
echo =============================================
echo      Press any key to return to main menu
pause >nul
goto menu

::=================================================================================================================================================================================================================================================================================================================

:completed
cls
echo =============================================
echo =                                           =
echo =            OPERATION COMPLETED!           =
echo =                                           =
echo =============================================
echo      Press any key to return to main menu
pause >nul
goto menu

::=================================================================================================================================================================================================================================================================================================================

:cancelled
cls
echo =============================================
echo =                                           =
echo =            OPERATION CANCELLED            =
echo =                                           =
echo =============================================
echo      Press any key to return to main menu
pause >nul
goto menu

::=================================================================================================================================================================================================================================================================================================================

:NoFeat
cls
echo =============================================
echo =                                           =
echo =    THIS FEATURE IS NOT YET IMPLEMENTED    =
echo =                                           =
echo =============================================
echo      Press any key to return to main menu
pause >nul
goto menu

::=================================================================================================================================================================================================================================================================================================================

:UpToDate
cls
echo =============================================
echo =                                           =
echo =            YOU ARE UP TO DATE!            =
echo =                                           =
echo =============================================
echo      Press any key to return to main menu
pause >nul
goto menu

::=================================================================================================================================================================================================================================================================================================================

:CleanAllExit
cls
echo ===================================================
echo =                                                 =
echo = CLEANUP COMPLETED, PLEASE RESTART RETROCAKE.BAT =
echo =  IF YOU HAD ANYTHING IN C:\RETROCAKE\ROMS THEY  =
echo =                ARE NOW IN C:\ROMS               =
echo =                                                 =
echo ===================================================
echo            Press Any Key to Exit
pause >nul
exit

::=================================================================================================================================================================================================================================================================================================================

:AdminFail
cls
echo =============================================
echo =                                           =
echo =           RUN AS ADMINISTRATOR            =
echo =                                           =
echo =============================================
echo            Press Any Key to Exit
pause >nul
exit
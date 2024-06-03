REM Usage: build_cpr.bat <version> 
REM e.g.    >build_cpr.bat 7.0.0.1

set build_folder=C:\EncounterPro\Builds\EncounterPRO-OS\EncounterPRO.OS.Client\%1
set runtimeversion=19.2.0.2797

echo "Building version ----> %1 <---- in %cd%\Client ?"
echo "Assuming this version and mod level are entered in cpr.sra?"
pause
REM /d ... /o ... /r ... /w n    /m n /x 32 /bg n /p "EncounterPRO_OS (tm)" /cp "EncounterPRO Healthcare Resources, Inc." /de "Electronic Medical Record System" /cr "(c) 1994-2021 EncounterPRO Healthcare Resources, Inc.  All Rights Reserved" /v "7.2.1.9" /vn "7.2.1.9" /fv "7.2.1.9" /fvn "7.2.1.9" /ge 2 /le 0 /ps n /pd nyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyy /rt 19.2.0.2797
pbc190.exe /f /d "%cd%\Client\cpr.pbt" /o "%build_folder%\EncounterPRO.OS.Client.exe" /r "%cd%\Client\encounterpro.os.pbr" /w n /m n /x 32 /p "EncounterPRO-OS" /cp "EncounterPRO Foundation, Inc" /de "Electronic Medical Record System" /cr "(c) 1994-2023 EncounterPRO Foundation Inc." /v "%1" /fv "%1" /ge 2 /le 0 /ps n /pd nyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyy /rt %runtimeversion%

echo "Hit any key when build has completed to move pbds to Builds folder"
pause

call assemble_cpr.bat %1 %runtimeversion%


mkdir "%build_folder%Demo"
xcopy "%build_folder%\*.pbd" "%build_folder%Demo" /S /Y
xcopy "%build_folder%\*.exe" "%build_folder%Demo" /S /Y


copy %build_folder%\..\pb.ini "%build_folder%Demo"
copy %build_folder%\..\EncounterPRO.ini "%build_folder%Demo"
copy "%build_folder%\..\..\Resources\Open Source License.rtf" "%build_folder%Demo"

REM now adding runtime into the EPro folder, so we don't need to run runtime installer
xcopy "C:\EncounterPro\Builds\EncounterPRO-OS\EncounterPRO.OS.Client\Runtime %runtimeversion%\*" "%build_folder%Demo" /S /Y


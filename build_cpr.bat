REM Usage: build_cpr.bat <version> 
REM e.g.    >build_cpr.bat 7.0.0.1

set build_folder=C:\EncounterPro\Builds\EncounterPRO-OS\EncounterPRO.OS.Client\%1
set runtimeversion=22.2.0.3441

echo "Building version ----> %1 <---- in %cd%\Client ?"
echo "Assuming this version and mod level are entered in cpr.sra?"
pause
REM /d ... /o ... /r ... /w n    /m n /x 32 /bg n /p "EncounterPRO_OS (tm)" /cp "EncounterPRO Healthcare Resources, Inc." /de "Electronic Medical Record System" /cr "(c) 1994-2021 EncounterPRO Healthcare Resources, Inc.  All Rights Reserved" /v "7.2.1.9" /vn "7.2.1.9" /fv "7.2.1.9" /fvn "7.2.1.9" /ge 2 /le 0 /ps n /pd nyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyy /rt 19.2.0.2797
pbc220.exe /f /d "%cd%\Client\cpr.pbt" /o "%build_folder%\EncounterPRO.OS.Client.exe" /r "%cd%\Client\encounterpro.os.pbr" /w n /m n /x 32 /p "EncounterPRO-OS" /cp "EncounterPRO Foundation, Inc" /de "Electronic Medical Record System" /cr "(c) 1997-2025 EncounterPRO Foundation Inc." /v "%1" /fv "%1" /ge 2 /le 0 /ps n /pd nyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyy /rt %runtimeversion%
/d "C:\EncounterPro\encounterpro_os_2022R3\Client\cpr.pbt" /o "C:\EncounterPro\encounterpro_os_2022R3\Client\EncounterPRO.OS.Client.exe" /r "C:\EncounterPro\encounterpro_os_2022R3\Client\encounterpro.os.pbr" /w n /f /m n /x 32 /bg y /p "EncounterPRO_OS (tm)" /cp "EncounterPRO Healthcare Resources, Inc." /de "Electronic Medical Record System" /cr "(c) 1994-2025 EncounterPRO Healthcare Resources, Inc.  All Rights Reserved" /v "7.3.1.0" /vn "7.3.1.0" /fv "7.3.1.0" /fvn "7.3.1.0" /ge 2 /le 0 /ps n /pd nyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyy /rt 22.2.0.3441
echo "Hit any key when build has completed to move pbds to Builds folder"
pause

call assemble_cpr.bat %1 %runtimeversion%

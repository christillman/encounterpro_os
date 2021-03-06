REM Usage: build_cpr.bat <version> 
REM e.g.    >build_cpr.bat 7.0.0.1

set build_folder=C:\Users\tofft\EncounterPro\Builds\EncounterPRO-OS\EncounterPRO.OS.Client\%1

echo "Building version ----> %1 <---- in %cd%\Client ?"
echo "Assuming this version and mod level are entered in cpr.sra?"
pause

REM /d "C:\Users\tofft\EncounterPr ... /o "C:\Users\tofft\EncounterPro\encounter ..." /r "C:\Users\tofft\EncounterPro ..." /w n /f /m n /x 64 /bg n /p "EncounterPRO (tm)" /cp "EncounterPRO Healthcare Resources, Inc." /de "Electronic Medical Record System" /cr "(c) 1994-2009 EncounterPRO Healthcare Resources, Inc.  All Rights Reserved" /v "7.0.1.1" /vn "7.0.1.1" /fv "7.0.1.1" /fvn "7.0.1.1" /ge 1 /le 0 /ps n 
pbc170.exe /f /d "%cd%\Client\cpr.pbt" /o "%build_folder%\EncounterPRO.OS.Client.exe" /r "%cd%\Client\encounterpro.os.pbr" /w n /m n /x 32 /p "EncounterPRO-OS" /cp "EncounterPRO Foundation, Inc" /de "Electronic Medical Record System" /cr "(c) 2018 EncounterPRO Foundation Inc." /v "%1" /fv "%1"

echo "Hit any key when build has completed to move pbds to Builds folder"
pause

call assemble_cpr.bat %1

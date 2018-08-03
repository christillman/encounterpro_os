REM Usage: build_dbmaint.bat <version> 
REM e.g.    >build_dbmaint.bat 1.0.0.3

set build_folder=C:\Users\tofft\EncounterPro\Builds\EncounterPRO-OS\EncounterPRO.OS.Utilities\%1

echo "Building version ----> %1 <---- in %cd%\Client ?"
pause

pbc170.exe /f /d "%cd%\Client\dbmaint.pbt" /o "%build_folder%\EncounterPRO.DbMaint.exe" /r "%cd%\Client\encounterpro.os.pbr" /w y /m n /x 32 /p "EncounterPRO DB Maintenance" /cp "EncounterPRO Foundation, Inc" /de "Electronic Medical Record System" /cr "(c) 2018 EncounterPRO Foundation Inc." /v "%1" /fv "%1"

echo "Hit any key when build has completed to move pbds to Builds folder"
pause
REM move /Y "Client\base\attributes.pbd" %build_folder%
REM move /Y "Client\base\base_objects.pbd" %build_folder%
REM move /Y "Client\base\basic_functions.pbd" %build_folder%
REM move /Y "Client\base\basic_structures.pbd" %build_folder%
REM move /Y "Client\base\common.pbd" %build_folder%
REM move /Y "Client\base\configure.pbd" %build_folder%
REM move /Y "Client\base\context.pbd" %build_folder%
REM move /Y "Client\base\data_functions.pbd" %build_folder%
REM move /Y "Client\base\pick.pbd" %build_folder%
REM move /Y "Client\base\popup.pbd" %build_folder%
REM move /Y "Client\base\pretty.pbd" %build_folder%
move /Y "Client\shell\common.pbd" %build_folder%
move /Y "Client\shell\chart.pbd" %build_folder%
move /Y "Client\shell\clinicaldatacache.pbd" %build_folder%
move /Y "Client\shell\components.pbd" %build_folder%
move /Y "Client\shell\datawindow.pbd" %build_folder%
move /Y "Client\shell\eproepiegateway.pbd" %build_folder%
move /Y "Client\shell\patient.pbd" %build_folder%
move /Y "Client\shell\security.pbd" %build_folder%
move /Y "Client\shell\shell.pbd" %build_folder%
move /Y "Client\shell\xml.pbd" %build_folder%
move /Y "Client\service\svc_configuration.pbd" %build_folder%
move /Y "Client\service\svc_utility.pbd" %build_folder%
move /Y "Client\dbmaint.pbd" %build_folder%

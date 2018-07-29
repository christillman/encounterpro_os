REM Usage: build_dbmaint.bat <version> 
REM e.g.    >build_dbmaint.bat 1.0.0.3

set build_folder=C:\Users\tofft\EncounterPro\Builds\EncounterPRO-OS\EncounterPRO.OS.Utilities\%1

pbc170.exe /f /d "C:\Users\tofft\EncounterPro\encounter_pro_os\dbmaint.pbt" /o "%build_folder%\EncounterPRO.DbMaint.exe" /r "C:\Users\tofft\EncounterPro\encounter_pro_os\encounterpro.os.pbr" /w y /m n /x 32 /p "EncounterPRO DB Maintenance" /cp "EncounterPRO Foundation, Inc" /de "Electronic Medical Record System" /cr "(c) 2018 EncounterPRO Foundation Inc." /v "%1" /fv "%1"

echo "Hit any key when build has completed to move pbds to Builds folder"
pause
move /Y "base\attributes.pbd" %build_folder%
move /Y "base\base_objects.pbd" %build_folder%
move /Y "base\basic_functions.pbd" %build_folder%
move /Y "base\basic_structures.pbd" %build_folder%
move /Y "base\common.pbd" %build_folder%
move /Y "base\configure.pbd" %build_folder%
move /Y "base\context.pbd" %build_folder%
move /Y "base\data_functions.pbd" %build_folder%
move /Y "base\pick.pbd" %build_folder%
move /Y "base\popup.pbd" %build_folder%
move /Y "base\pretty.pbd" %build_folder%
move /Y "shell\chart.pbd" %build_folder%
move /Y "shell\clinicaldatacache.pbd" %build_folder%
move /Y "shell\components.pbd" %build_folder%
move /Y "shell\datawindow.pbd" %build_folder%
move /Y "shell\eproepiegateway.pbd" %build_folder%
move /Y "shell\patient.pbd" %build_folder%
move /Y "shell\security.pbd" %build_folder%
move /Y "shell\shell.pbd" %build_folder%
move /Y "shell\xml.pbd" %build_folder%
move /Y service\svc_configuration.pbd %build_folder%
move /Y service\svc_utility.pbd %build_folder%
move /Y dbmaint.pbd %build_folder%

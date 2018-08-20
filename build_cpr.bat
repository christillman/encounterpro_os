REM Usage: build_cpr.bat <version> 
REM e.g.    >build_cpr.bat 7.0.0.1

set build_folder=C:\Users\tofft\EncounterPro\Builds\EncounterPRO-OS\EncounterPRO.OS.Client\%1

echo "Building version ----> %1 <---- in %cd%\Client ?"
echo "Assuming this version and mod level are entered in cpr.sra?"
pause

pbc170.exe /f /d "%cd%\Client\cpr.pbt" /o "%build_folder%\EncounterPRO.OS.Client.exe" /r "%cd%\Client\encounterpro.os.pbr" /w n /m n /x 32 /p "EncounterPRO-OS" /cp "EncounterPRO Foundation, Inc" /de "Electronic Medical Record System" /cr "(c) 2018 EncounterPRO Foundation Inc." /v "%1" /fv "%1"

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
move /Y "Client\shell\treatments.pbd" %build_folder%
move /Y "Client\shell\xml.pbd" %build_folder%
move /Y "Client\chart\chart_attachments.pbd" %build_folder%
move /Y "Client\chart\chart_browser.pbd" %build_folder%
move /Y "Client\chart\chart_drug_history.pbd" %build_folder%
move /Y "Client\chart\chart_famhistory.pbd" %build_folder%
move /Y "Client\chart\chart_graph.pbd" %build_folder%
move /Y "Client\chart\chart_growth.pbd" %build_folder%
move /Y "Client\chart\chart_healthmain.pbd" %build_folder%
move /Y "Client\chart\chart_labs_tests.pbd" %build_folder%
move /Y "Client\chart\chart_proc_history.pbd" %build_folder%
move /Y "Client\chart\chart_soap.pbd" %build_folder%
move /Y "Client\chart\chart_summary.pbd" %build_folder%
move /Y "Client\chart\chart_vaccines.pbd" %build_folder%
move /Y "Client\cpr.pbd" %build_folder%
move /Y "Client\extension\ext_alert.pbd" %build_folder%
move /Y "Client\extension\ext_attachments.pbd" %build_folder%
move /Y "Client\extension\ext_billing.pbd" %build_folder%
move /Y "Client\extension\ext_coding.pbd" %build_folder%
REM Empty PBLs don't build
REM move /Y "Client\extension\ext_drug.pbd" %build_folder%
move /Y "Client\extension\ext_msging.pbd" %build_folder%
move /Y "Client\extension\ext_nomenclature.pbd" %build_folder%
move /Y "Client\extension\ext_observation.pbd" %build_folder%
move /Y "Client\extension\ext_pbreports.pbd" %build_folder%
move /Y "Client\extension\ext_properties.pbd" %build_folder%
move /Y "Client\extension\ext_schedule.pbd" %build_folder%
move /Y "Client\extension\ext_xml.pbd" %build_folder%
move /Y "Client\server\server_services.pbd" %build_folder%
move /Y "Client\service\svc_activity.pbd" %build_folder%
move /Y "Client\service\svc_billing.pbd" %build_folder%
move /Y "Client\service\svc_browser.pbd" %build_folder%
move /Y "Client\service\svc_chart.pbd" %build_folder%
move /Y "Client\service\svc_chart_encounter.pbd" %build_folder%
move /Y "Client\service\svc_configuration.pbd" %build_folder%
move /Y "Client\service\svc_epro_message.pbd" %build_folder%
move /Y "Client\service\svc_epro_todo.pbd" %build_folder%
move /Y "Client\service\svc_epro_workflow.pbd" %build_folder%
move /Y "Client\service\svc_followup.pbd" %build_folder%
REM Empty PBLs don't build
REM move /Y "Client\service\svc_get_immunization.pbd" %build_folder%
move /Y "Client\service\svc_get_medication.pbd" %build_folder%
move /Y "Client\service\svc_get_officemed.pbd" %build_folder%
move /Y "Client\service\svc_get_referral.pbd" %build_folder%
move /Y "Client\service\svc_get_refills.pbd" %build_folder%
move /Y "Client\service\svc_immunization.pbd" %build_folder%
move /Y "Client\service\svc_maintenance.pbd" %build_folder%
move /Y "Client\service\svc_material.pbd" %build_folder%
move /Y "Client\service\svc_medication.pbd" %build_folder%
move /Y "Client\service\svc_observations.pbd" %build_folder%
move /Y "Client\service\svc_patient_message.pbd" %build_folder%
move /Y "Client\service\svc_procedure.pbd" %build_folder%
move /Y "Client\service\svc_report.pbd" %build_folder%
move /Y "Client\service\svc_utility.pbd" %build_folder%

REM move /Y "Client\dbmaint.pbd" %build_folder%
REM move /Y "Client\eprodbmaint.exe" %build_folder%

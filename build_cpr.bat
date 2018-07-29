REM Usage: build_cpr.bat <version> 
REM e.g.    >build_cpr.bat 7.0.0.1

echo "Building version ----> %1 <---- in %cd% ?"
pause

set build_folder=C:\Users\tofft\EncounterPro\Builds\EncounterPRO-OS\EncounterPRO.OS.Client\%1

pbc170.exe /f /d "%cd%\cpr.pbt" /o "%build_folder%\EncounterPRO.OS.Client.exe" /r "%cd%\encounterpro.os.pbr" /w n /m n /x 32 /p "EncounterPRO-OS" /cp "EncounterPRO Foundation, Inc" /de "Electronic Medical Record System" /cr "(c) 2018 EncounterPRO Foundation Inc." /v "%1" /fv "%1"

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
move /Y "shell\treatments.pbd" %build_folder%
move /Y "shell\xml.pbd" %build_folder%
copy /Y Sybase.PowerBuilder.WebService.RuntimeRemoteLoader.dll %build_folder%
copy /Y Sybase.PowerBuilder.WebService.WSDL.dll %build_folder%
copy /Y Sybase.PowerBuilder.WebService.WSDLRemoteLoader.dll %build_folder%
copy /Y Sybase.Powerbuilder.WebService.Runtime.dll %build_folder%
move /Y chart\chart_attachments.pbd %build_folder%
move /Y chart\chart_browser.pbd %build_folder%
move /Y chart\chart_drug_history.pbd %build_folder%
move /Y chart\chart_famhistory.pbd %build_folder%
move /Y chart\chart_graph.pbd %build_folder%
move /Y chart\chart_growth.pbd %build_folder%
move /Y chart\chart_healthmain.pbd %build_folder%
move /Y chart\chart_labs_tests.pbd %build_folder%
move /Y chart\chart_proc_history.pbd %build_folder%
move /Y chart\chart_soap.pbd %build_folder%
move /Y chart\chart_summary.pbd %build_folder%
move /Y chart\chart_vaccines.pbd %build_folder%
move /Y cpr.pbd %build_folder%
move /Y extension\ext_alert.pbd %build_folder%
move /Y extension\ext_attachments.pbd %build_folder%
move /Y extension\ext_billing.pbd %build_folder%
move /Y extension\ext_coding.pbd %build_folder%
move /Y extension\ext_drug.pbd %build_folder%
REM Empty PBLs don't build
REM move /Y extension\ext_msging.pbd %build_folder%
move /Y extension\ext_nomenclature.pbd %build_folder%
move /Y extension\ext_observation.pbd %build_folder%
move /Y extension\ext_pbreports.pbd %build_folder%
move /Y extension\ext_properties.pbd %build_folder%
move /Y extension\ext_schedule.pbd %build_folder%
move /Y extension\ext_xml.pbd %build_folder%
move /Y server\server_services.pbd %build_folder%
move /Y service\svc_activity.pbd %build_folder%
move /Y service\svc_billing.pbd %build_folder%
move /Y service\svc_browser.pbd %build_folder%
move /Y service\svc_chart.pbd %build_folder%
move /Y service\svc_chart_encounter.pbd %build_folder%
move /Y service\svc_configuration.pbd %build_folder%
move /Y service\svc_epro_message.pbd %build_folder%
move /Y service\svc_epro_todo.pbd %build_folder%
move /Y service\svc_epro_workflow.pbd %build_folder%
move /Y service\svc_followup.pbd %build_folder%
REM Empty PBLs don't build
REM move /Y service\svc_get_immunization.pbd %build_folder%
move /Y service\svc_get_medication.pbd %build_folder%
move /Y service\svc_get_officemed.pbd %build_folder%
move /Y service\svc_get_referral.pbd %build_folder%
move /Y service\svc_get_refills.pbd %build_folder%
move /Y service\svc_immunization.pbd %build_folder%
move /Y service\svc_maintenance.pbd %build_folder%
move /Y service\svc_material.pbd %build_folder%
move /Y service\svc_medication.pbd %build_folder%
move /Y service\svc_observations.pbd %build_folder%
move /Y service\svc_patient_message.pbd %build_folder%
move /Y service\svc_procedure.pbd %build_folder%
move /Y service\svc_report.pbd %build_folder%
move /Y service\svc_utility.pbd %build_folder%

REM move /Y dbmaint.pbd %build_folder%
REM move /Y eprodbmaint.exe %build_folder%

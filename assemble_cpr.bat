REM Usage: assemble_cpr.bat <target-version> 
REM e.g. > assemble_cpr.bat 7.0.0.1

set build_folder=C:\Users\tofft\EncounterPro\Builds\EncounterPRO-OS\EncounterPRO.OS.Client\%1

move /Y "Client\base\app_infrastructure.pbd" %build_folder%
move /Y "Client\base\attribute.pbd" %build_folder%
move /Y "Client\base\conversion.pbd" %build_folder%
move /Y "Client\base\database_infrastructure.pbd" %build_folder%
move /Y "Client\base\database_metadata.pbd" %build_folder%
move /Y "Client\base\date_time.pbd" %build_folder%
move /Y "Client\base\display_script.pbd" %build_folder%
move /Y "Client\base\file.pbd" %build_folder%
move /Y "Client\base\gui_basic.pbd" %build_folder%
move /Y "Client\base\gui_specialized.pbd" %build_folder%
move /Y "Client\base\image.pbd" %build_folder%
move /Y "Client\base\menu.pbd" %build_folder%
move /Y "Client\base\parameter.pbd" %build_folder%
move /Y "Client\base\popup.pbd" %build_folder%
move /Y "Client\base\pretty.pbd" %build_folder%
move /Y "Client\base\printer.pbd" %build_folder%
move /Y "Client\base\string.pbd" %build_folder%
move /Y "Client\base\table_accessor.pbd" %build_folder%
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
move /Y "Client\extension\ext_msging.pbd" %build_folder%
move /Y "Client\extension\ext_nomenclature.pbd" %build_folder%
move /Y "Client\extension\ext_observation.pbd" %build_folder%
move /Y "Client\extension\ext_pbreports.pbd" %build_folder%
move /Y "Client\extension\ext_schedule.pbd" %build_folder%
move /Y "Client\extension\ext_xml.pbd" %build_folder%
move /Y "Client\server\server_services.pbd" %build_folder%
move /Y "Client\service\config_object.pbd" %build_folder%
move /Y "Client\service\configuration_tree.pbd" %build_folder%
move /Y "Client\service\configure_actor.pbd" %build_folder%
move /Y "Client\service\configure_assessment.pbd" %build_folder%
move /Y "Client\service\configure_component.pbd" %build_folder%
move /Y "Client\service\configure_drug.pbd" %build_folder%
move /Y "Client\service\configure_observation.pbd" %build_folder%
move /Y "Client\service\configure_treatment_type.pbd" %build_folder%
move /Y "Client\service\configure_user.pbd" %build_folder%
move /Y "Client\service\scheduled.pbd" %build_folder%
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
move /Y "Client\service\svc_get_referral.pbd" %build_folder%
move /Y "Client\service\svc_get_refills.pbd" %build_folder%
move /Y "Client\service\svc_immunization.pbd" %build_folder%
move /Y "Client\service\svc_material.pbd" %build_folder%
move /Y "Client\service\svc_medication.pbd" %build_folder%
move /Y "Client\service\svc_observations.pbd" %build_folder%
move /Y "Client\service\svc_patient_message.pbd" %build_folder%
move /Y "Client\service\svc_procedure.pbd" %build_folder%
move /Y "Client\service\svc_report.pbd" %build_folder%
move /Y "Client\service\svc_utility.pbd" %build_folder%
move /Y "Client\shell\allergen.pbd" %build_folder%
move /Y "Client\shell\attachment.pbd" %build_folder%
move /Y "Client\shell\chart.pbd" %build_folder%
move /Y "Client\shell\clinicaldatacache.pbd" %build_folder%
move /Y "Client\shell\component_utility.pbd" %build_folder%
move /Y "Client\shell\components.pbd" %build_folder%
move /Y "Client\shell\consultant.pbd" %build_folder%
move /Y "Client\shell\context.pbd" %build_folder%
move /Y "Client\shell\contraindication.pbd" %build_folder%
move /Y "Client\shell\document.pbd" %build_folder%
move /Y "Client\shell\drug_administration.pbd" %build_folder%
move /Y "Client\shell\encounter.pbd" %build_folder%
move /Y "Client\shell\eproepiegateway.pbd" %build_folder%
move /Y "Client\shell\evaluation_management.pbd" %build_folder%
move /Y "Client\shell\health_management.pbd" %build_folder%
move /Y "Client\shell\location.pbd" %build_folder%
move /Y "Client\shell\maintenance.pbd" %build_folder%
move /Y "Client\shell\observation_tree.pbd" %build_folder%
move /Y "Client\shell\office.pbd" %build_folder%
move /Y "Client\shell\patient.pbd" %build_folder%
move /Y "Client\shell\patient_assessment.pbd" %build_folder%
move /Y "Client\shell\patient_treatment.pbd" %build_folder%
move /Y "Client\shell\patient_utility.pbd" %build_folder%
move /Y "Client\shell\preference.pbd" %build_folder%
move /Y "Client\shell\progress.pbd" %build_folder%
move /Y "Client\shell\property.pbd" %build_folder%
move /Y "Client\shell\room.pbd" %build_folder%
move /Y "Client\shell\security.pbd" %build_folder%
move /Y "Client\shell\shortlist.pbd" %build_folder%
move /Y "Client\shell\specialty.pbd" %build_folder%
move /Y "Client\shell\treatments.pbd" %build_folder%
move /Y "Client\shell\workplan.pbd" %build_folder%
move /Y "Client\shell\xml.pbd" %build_folder%

REM move /Y "Client\dbmaint.pbd" %build_folder%
REM move /Y "Client\eprodbmaint.exe" %build_folder%

REM -- only for IDE builds
move /Y "Client\encounterpro.os.client.exe" %build_folder%

copy %build_folder%\..\pb.ini %build_folder%
copy %build_folder%\..\EncounterPRO.ini %build_folder%
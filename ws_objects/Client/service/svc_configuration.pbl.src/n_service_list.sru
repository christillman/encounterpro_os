$PBExportHeader$n_service_list.sru
forward
global type n_service_list from nonvisualobject
end type
end forward

global type n_service_list from nonvisualobject
end type
global n_service_list n_service_list

forward prototypes
public subroutine service_window_index ()
end prototypes

public subroutine service_window_index ();
// The purpose here is just to make an object reference
// to windows instantiated from a window_class service
// attribute so that cross reference tools will find a usage
// (the name may only appear within o_service.value)

string ls_dummy 

ls_dummy = w_billing_edit.title
ls_dummy = w_change_password.title
ls_dummy = w_coding_element_observations.title
ls_dummy = w_config_encounter_types.title
ls_dummy = w_config_external_sources.title
ls_dummy = w_config_insurance_carriers.title
ls_dummy = w_config_letter_types.title
ls_dummy = w_config_preferences.title
ls_dummy = w_config_reports.title
ls_dummy = w_config_reports.title
ls_dummy = w_config_shortlists.title
ls_dummy = w_config_specialties_consultants.title
ls_dummy = w_config_treatment_types.title
ls_dummy = w_config_users.title
// ls_dummy = w_config_vaccines_diseases.title
ls_dummy = w_edit_observations.title
ls_dummy = w_encounter_list.title
ls_dummy = w_epro_message.title
ls_dummy = w_epro_review_message.title
ls_dummy = w_epro_todo_item.title
ls_dummy = w_general_reports.title
ls_dummy = w_graphs.title
ls_dummy = w_growth_charts.title
ls_dummy = w_health_maintenance_rules.title
ls_dummy = w_outstanding_tests.title
ls_dummy = w_pick_list_members.title
ls_dummy = w_pick_list_members.title
ls_dummy = w_pick_list_members.title
ls_dummy = w_progress_notes.title
ls_dummy = w_progress_notes.title
ls_dummy = w_progress_notes.title
ls_dummy = w_progress_notes.title
ls_dummy = w_reinstall.title
ls_dummy = w_retry_posting.title
ls_dummy = w_scan_main.title
ls_dummy = w_server_setup.title
ls_dummy = w_server_status.title
ls_dummy = w_svc_allergy_reaction_check.title
ls_dummy = w_svc_allergy_shot_administration.title
ls_dummy = w_svc_allergy_vial_creation.title
ls_dummy = w_svc_allergy_vial_definition.title
ls_dummy = w_svc_allergy_vial_management.title
ls_dummy = w_svc_assessment_associate_treatments.title
ls_dummy = w_svc_assessment_close.title
ls_dummy = w_svc_assessment_history.title
ls_dummy = w_svc_assessment_list.title
ls_dummy = w_svc_assessment_list.title
ls_dummy = w_svc_assessment_move.title
ls_dummy = w_svc_assessment_review.title
ls_dummy = w_svc_assessment_timeline.title
ls_dummy = w_svc_audit.title
ls_dummy = w_svc_billing_code_pick.title
ls_dummy = w_svc_change_office.title
ls_dummy = w_svc_change_scribe_context.title
ls_dummy = w_svc_chart_export.title
ls_dummy = w_svc_code_mappings.title
ls_dummy = w_svc_compose_message.title
ls_dummy = w_svc_compose_message.title
ls_dummy = w_svc_config_assessments.title
ls_dummy = w_svc_config_chart_layouts.title
ls_dummy = w_svc_config_drugs.title
ls_dummy = w_svc_config_menus.title
ls_dummy = w_svc_config_patient_materials.title
ls_dummy = w_svc_config_practice.title
ls_dummy = w_svc_config_procedures.title
ls_dummy = w_svc_config_service.title
ls_dummy = w_svc_config_vaccine_schedule.title
ls_dummy = w_svc_config_workplans.title
ls_dummy = w_svc_current_meds.title
ls_dummy = w_svc_documents.title
ls_dummy = w_svc_edit_encounter.title
ls_dummy = w_svc_edit_supervisor.title
ls_dummy = w_svc_encounter_coding.title
ls_dummy = w_svc_encounter_review.title
ls_dummy = w_svc_hm_browser.title
ls_dummy = w_svc_imm_record.title
ls_dummy = w_svc_maintenance_rule_status.title
ls_dummy = w_svc_merge_patient.title
ls_dummy = w_svc_monitor_result.title
ls_dummy = w_svc_multi_chart_export.title
ls_dummy = w_svc_patient_service_list.title
ls_dummy = w_svc_preferred_provider.title
ls_dummy = w_svc_problem_list.title
ls_dummy = w_svc_problem_list.title
ls_dummy = w_svc_refer_treatment.title
ls_dummy = w_svc_referrals_by_day.title
ls_dummy = w_svc_referrals_by_day.title
ls_dummy = w_svc_results_by_treatment_display.title
ls_dummy = w_svc_rtf.title
ls_dummy = w_svc_show_actor.title
ls_dummy = w_svc_treatment_associate_assessments.title
ls_dummy = w_svc_treatment_billing.title
ls_dummy = w_svc_treatment_highlight_results.title
ls_dummy = w_svc_uncancel_encounter.title
ls_dummy = w_treatment_billing_edit.title
ls_dummy = w_treatment_timed_progress.title
ls_dummy = w_user_manual.title

// These are referenced in OpenWithParm(service_window, ...)

ls_dummy = w_approve_encounter.title
ls_dummy = w_billing_edit.title
ls_dummy = w_checkin_followup_pick.title
ls_dummy = w_composite_observation_definition.title
ls_dummy = w_cpr_main.title
ls_dummy = w_do_immunization.title
ls_dummy = w_do_medication.title
ls_dummy = w_do_procedure.title
ls_dummy = w_do_treatment.title
ls_dummy = w_do_vitals.title
ls_dummy = w_drug_treatment.title
ls_dummy = w_edit_activity.title
ls_dummy = w_edit_observations.title
ls_dummy = w_find_assessment.title
ls_dummy = w_followup.title
ls_dummy = w_followup_reorder.title
ls_dummy = w_freeform_history.title
ls_dummy = w_history_questionnaire.title
ls_dummy = w_observation_comment_with_list.title
ls_dummy = w_observation_definition.title
ls_dummy = w_observation_grid.title
ls_dummy = w_observation_tree_display.title
ls_dummy = w_office_drug_treatment.title
ls_dummy = w_patient_data.title
ls_dummy = w_patient_messages.title
ls_dummy = w_physical_exam.title
ls_dummy = w_pick_assessments.title
ls_dummy = w_pick_display_script.title
ls_dummy = w_progress_note_edit.title
ls_dummy = w_referral.title
ls_dummy = w_svc_assessment_close.title
ls_dummy = w_svc_drug_treatment_edit.title
ls_dummy = w_svc_history_display.title
ls_dummy = w_svc_history_yesno.title
ls_dummy = w_svc_new_refill_request.title
ls_dummy = w_svc_patient_checkin.title
ls_dummy = w_svc_patient_object_workplan.title
ls_dummy = w_svc_patient_workplan.title
ls_dummy = w_svc_rx_refill.title
ls_dummy = w_svc_rx_refill_document.title
ls_dummy = w_svc_rx_refill_request.title
ls_dummy = w_svc_wait.title
ls_dummy = w_svc_web.title
ls_dummy = w_vaccine_signature.title


end subroutine

on n_service_list.create
call super::create
TriggerEvent( this, "constructor" )
end on

on n_service_list.destroy
TriggerEvent( this, "destructor" )
call super::destroy
end on


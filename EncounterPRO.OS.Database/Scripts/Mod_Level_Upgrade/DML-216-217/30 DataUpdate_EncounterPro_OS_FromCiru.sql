/*
This script was created by Visual Studio on 15/07/2023 at 10:16 am.
Run this script on DESKTOP-1EOB2VV\EncounterPro.EncounterPro_OS (DESKTOP-1EOB2VV\tofft) to make it the same as DESKTOP-1EOB2VV\ENCOUNTERPRO.EncounterPro_Ciru20230715 (DESKTOP-1EOB2VV\tofft).
This script performs its actions in the following order:
1. Disable foreign-key constraints.
2. Perform DELETE commands. 
3. Perform UPDATE commands.
4. Perform INSERT commands.
5. Re-enable foreign-key constraints.
Please back up your target database before running this script.
*/

  alter table c_Config_Log alter column computer_id int null
  alter table c_Config_Log alter column performed_by varchar(24) null

SET NUMERIC_ROUNDABORT OFF
GO
SET XACT_ABORT, ANSI_PADDING, ANSI_WARNINGS, CONCAT_NULL_YIELDS_NULL, ARITHABORT, QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
/*Pointer used for text / image updates. This might not be needed, but is declared here just in case*/
DECLARE @pv binary(16)
BEGIN TRANSACTION
UPDATE [dbo].[c_Maintenance_Assessment] SET [assessment_current_flag]=N'Y' WHERE [maintenance_rule_id]=15 AND [assessment_id]=N'DEMO186'
UPDATE [dbo].[c_Chart_Section_Page] SET [bitmap]=N'icon021.bmp' WHERE [chart_id]=7 AND [section_id]=43 AND [page_id]=75
UPDATE [dbo].[c_Chart_Section_Page] SET [page_class]=N'u_soap_page_encounter_notes' WHERE [chart_id]=7 AND [section_id]=1000001 AND [page_id]=407
UPDATE [dbo].[c_Chart_Section_Page] SET [description]=N'Appointment Summary', [page_class]=N'u_soap_page_assessments' WHERE [chart_id]=13 AND [section_id]=146 AND [page_id]=239
UPDATE [dbo].[c_Chart_Section_Page] SET [description]=N'Lab Results', [page_class]=N'u_soap_page_results', [bitmap]=N'icon002.bmp' WHERE [chart_id]=13 AND [section_id]=146 AND [page_id]=586
UPDATE [dbo].[c_Chart_Section_Page] SET [description]=N'Drug HX', [page_class]=N'u_cpr_drug_history', [bitmap]=N'icon010.bmp' WHERE [chart_id]=13 AND [section_id]=146 AND [page_id]=618
UPDATE [dbo].[c_Chart_Section_Page] SET [sort_sequence]=2, [description]=N'Procedures', [page_class]=N'u_cpr_proc_history', [bitmap]=N'icon012.bmp' WHERE [chart_id]=13 AND [section_id]=148 AND [page_id]=243
UPDATE [dbo].[c_Chart_Section_Page] SET [description]=N'History & Physical', [page_class]=N'u_soap_page_observations', [bitmap]=N'EditDataFreeform!' WHERE [chart_id]=13 AND [section_id]=149 AND [page_id]=244
UPDATE [dbo].[c_Chart_Section_Page] SET [description]=N'Diagnosis & Treatment', [page_class]=N'u_soap_page_observations' WHERE [chart_id]=13 AND [section_id]=149 AND [page_id]=465
UPDATE [dbo].[c_Chart_Section_Page] SET [page_class]=N'u_immunization' WHERE [chart_id]=13 AND [section_id]=151 AND [page_id]=248
UPDATE [dbo].[c_Chart_Section_Page] SET [description]=N'Appointment Summary', [page_class]=N'u_soap_page_assessments' WHERE [chart_id]=44 AND [section_id]=233 AND [page_id]=379
UPDATE [dbo].[c_Chart_Section_Page] SET [description]=N'Lab Results', [page_class]=N'u_soap_page_results', [bitmap]=N'icon021.bmp' WHERE [chart_id]=44 AND [section_id]=233 AND [page_id]=605
UPDATE [dbo].[c_Chart_Section_Page] SET [description]=N'Drug HX', [page_class]=N'u_cpr_drug_history' WHERE [chart_id]=44 AND [section_id]=233 AND [page_id]=634
UPDATE [dbo].[c_Chart_Section_Page] SET [sort_sequence]=2, [description]=N'Procedures', [page_class]=N'u_cpr_proc_history', [bitmap]=N'icon012.bmp' WHERE [chart_id]=44 AND [section_id]=235 AND [page_id]=383
UPDATE [dbo].[c_Chart_Section_Page] SET [description]=N'History & Physical', [page_class]=N'u_soap_page_observations', [bitmap]=N'EditDataFreeform!' WHERE [chart_id]=44 AND [section_id]=236 AND [page_id]=384
UPDATE [dbo].[c_Chart_Section_Page] SET [description]=N'Diagnosis & Treatment', [page_class]=N'u_soap_page_observations' WHERE [chart_id]=44 AND [section_id]=236 AND [page_id]=484
UPDATE [dbo].[c_Chart_Section_Page] SET [page_class]=N'u_immunization' WHERE [chart_id]=44 AND [section_id]=238 AND [page_id]=388
UPDATE [dbo].[c_Chart_Section_Page_Attribute] SET [value]=N'1000059' WHERE [chart_id]=7 AND [section_id]=43 AND [page_id]=75 AND [attribute_sequence]=103
UPDATE [dbo].[c_Chart_Section_Page_Attribute] SET [value]=N'820' WHERE [chart_id]=7 AND [section_id]=1000001 AND [page_id]=407 AND [attribute_sequence]=1040
UPDATE [dbo].[c_Chart_Section_Page_Attribute] SET [value]=N'PT' WHERE [chart_id]=7 AND [section_id]=1000002 AND [page_id]=522 AND [attribute_sequence]=1691
UPDATE [dbo].[c_Chart_Section_Page_Attribute] SET [value]=N'581' WHERE [chart_id]=7 AND [section_id]=1000002 AND [page_id]=522 AND [attribute_sequence]=1000004
UPDATE [dbo].[c_Chart_Section_Page_Attribute] SET [value]=N'588' WHERE [chart_id]=13 AND [section_id]=146 AND [page_id]=239 AND [attribute_sequence]=1280
UPDATE [dbo].[c_Chart_Section_Page_Attribute] SET [value]=N'1000059' WHERE [chart_id]=13 AND [section_id]=146 AND [page_id]=586 AND [attribute_sequence]=1902
UPDATE [dbo].[c_Chart_Section_Page_Attribute] SET [attribute]=N'display_script_id_1', [value]=N'1001791' WHERE [chart_id]=13 AND [section_id]=149 AND [page_id]=465 AND [attribute_sequence]=1602
UPDATE [dbo].[c_Chart_Section_Page_Attribute] SET [value]=N'1001614' WHERE [chart_id]=13 AND [section_id]=149 AND [page_id]=497 AND [attribute_sequence]=1633
UPDATE [dbo].[o_Server_Component] SET [status]=N'NA' WHERE [service_id]=41
UPDATE [dbo].[o_Treatment_Type_Default_Mode] SET [treatment_mode]=N'Drilldown' WHERE [treatment_type]=N'HPI_HISTORY' AND [treatment_key]=N'DEMO5777' AND [office_id]=N'0001'
UPDATE [dbo].[o_Treatment_Type_Default_Mode] SET [treatment_mode]=N'Enc Col Perf Rev Cons' WHERE [treatment_type]=N'LAB' AND [treatment_key]=N'!Default' AND [office_id]=N'0001'
UPDATE [dbo].[c_Folder] SET [sort_sequence]=15 WHERE [folder]=N'Allergy Treatments'
UPDATE [dbo].[c_Folder] SET [sort_sequence]=10 WHERE [folder]=N'Cardio Test Reports'
UPDATE [dbo].[c_Folder] SET [sort_sequence]=13 WHERE [folder]=N'Diagnostic Tests'
UPDATE [dbo].[c_Folder] SET [sort_sequence]=7 WHERE [folder]=N'Encounter Records'
UPDATE [dbo].[c_Folder] SET [description]=N'TTT' WHERE [folder]=N'Items To Be Posted'
UPDATE [dbo].[c_Folder] SET [context_object_type]=N'LAB', [sort_sequence]=9, [workplan_required_flag]=N'Y' WHERE [folder]=N'Lab Reports'
UPDATE [dbo].[c_Folder] SET [sort_sequence]=4 WHERE [folder]=N'Medical Records'
UPDATE [dbo].[c_Folder] SET [sort_sequence]=5 WHERE [folder]=N'Off-Site Care Records'
UPDATE [dbo].[c_Folder] SET [sort_sequence]=17 WHERE [folder]=N'Other Treatments'
UPDATE [dbo].[c_Folder] SET [sort_sequence]=8 WHERE [folder]=N'Patient Histories'
UPDATE [dbo].[c_Folder] SET [sort_sequence]=14 WHERE [folder]=N'Prescription Drug Records'
UPDATE [dbo].[c_Folder] SET [sort_sequence]=12 WHERE [folder]=N'Radiology Reports'
UPDATE [dbo].[c_Folder] SET [sort_sequence]=6 WHERE [folder]=N'Referral Records'
UPDATE [dbo].[c_Folder] SET [sort_sequence]=11 WHERE [folder]=N'Referral Treatments'
UPDATE [dbo].[c_Folder] SET [sort_sequence]=16 WHERE [folder]=N'Telephone Messages'
UPDATE [dbo].[u_Top_20] SET [item_text]=N'CHIEF COMPLAINT AND HISTORY OF PRESENT ILLNESS' WHERE [user_id]=N'$ALLERGY' AND [top_20_code]=N'TEST_HPI_HISTORY' AND [top_20_sequence]=81981
UPDATE [dbo].[u_Top_20] SET [item_text]=N'Respiratory Symptoms HPI ' WHERE [user_id]=N'$ALLERGY' AND [top_20_code]=N'TEST_HPI_HISTORY' AND [top_20_sequence]=107153
UPDATE [dbo].[u_Top_20] SET [item_text]=N'Respiratory Symptoms HPI ' WHERE [user_id]=N'$CARDIO' AND [top_20_code]=N'TEST_HPI_HISTORY' AND [top_20_sequence]=107148
UPDATE [dbo].[u_Top_20] SET [item_text]=N'ENT Physical Examination' WHERE [user_id]=N'$ENT' AND [top_20_code]=N'TEST_PHYSICAL' AND [top_20_sequence]=12145
UPDATE [dbo].[u_Top_20] SET [item_text]=N'General Review of Systems', [sort_sequence]=2 WHERE [user_id]=N'$ENT' AND [top_20_code]=N'TEST_ROS_HISTORY' AND [top_20_sequence]=12152
UPDATE [dbo].[u_Top_20] SET [sort_sequence]=3 WHERE [user_id]=N'$ENT' AND [top_20_code]=N'TEST_ROS_HISTORY' AND [top_20_sequence]=12153
UPDATE [dbo].[u_Top_20] SET [sort_sequence]=6 WHERE [user_id]=N'$ENT' AND [top_20_code]=N'TEST_VITAL' AND [top_20_sequence]=4947
UPDATE [dbo].[u_Top_20] SET [sort_sequence]=4 WHERE [user_id]=N'$ENT' AND [top_20_code]=N'TEST_VITAL' AND [top_20_sequence]=12185
UPDATE [dbo].[u_Top_20] SET [item_text]=N'CHIEF COMPLAINT AND HISTORY OF PRESENT ILLNESS' WHERE [user_id]=N'$FP' AND [top_20_code]=N'TEST' AND [top_20_sequence]=119733
UPDATE [dbo].[u_Top_20] SET [item_text]=N'CHIEF COMPLAINT AND HISTORY OF PRESENT ILLNESS' WHERE [user_id]=N'$FP' AND [top_20_code]=N'TEST_HPI_HISTORY' AND [top_20_sequence]=120028
UPDATE [dbo].[u_Top_20] SET [item_text]=N'Bilirubin, total' WHERE [user_id]=N'$FP' AND [top_20_code]=N'TEST_LAB' AND [top_20_sequence]=120055
UPDATE [dbo].[u_Top_20] SET [item_text]=N'ENT Physical Examination' WHERE [user_id]=N'$FP' AND [top_20_code]=N'TEST_PHYSICAL' AND [top_20_sequence]=120136
UPDATE [dbo].[u_Top_20] SET [item_text]=N'CHIEF COMPLAINT AND HISTORY OF PRESENT ILLNESS' WHERE [user_id]=N'$FPOB' AND [top_20_code]=N'TEST' AND [top_20_sequence]=101412
UPDATE [dbo].[u_Top_20] SET [item_text]=N'CHIEF COMPLAINT AND HISTORY OF PRESENT ILLNESS' WHERE [user_id]=N'$FPOB' AND [top_20_code]=N'TEST_HPI_HISTORY' AND [top_20_sequence]=96986
UPDATE [dbo].[u_Top_20] SET [item_text]=N'Bilirubin, total' WHERE [user_id]=N'$FPOB' AND [top_20_code]=N'TEST_LAB' AND [top_20_sequence]=73087
UPDATE [dbo].[u_Top_20] SET [item_text]=N'ENT Physical Examination' WHERE [user_id]=N'$FPOB' AND [top_20_code]=N'TEST_PHYSICAL' AND [top_20_sequence]=73469
UPDATE [dbo].[u_Top_20] SET [item_text]=N'Respiratory Symptoms HPI ' WHERE [user_id]=N'$GASTRO' AND [top_20_code]=N'TEST_HPI_HISTORY' AND [top_20_sequence]=109098
UPDATE [dbo].[u_Top_20] SET [item_text]=N'CHIEF COMPLAINT AND HISTORY OF PRESENT ILLNESS' WHERE [user_id]=N'$IM' AND [top_20_code]=N'TEST' AND [top_20_sequence]=80438
UPDATE [dbo].[u_Top_20] SET [item_text]=N'CHIEF COMPLAINT AND HISTORY OF PRESENT ILLNESS' WHERE [user_id]=N'$IM' AND [top_20_code]=N'TEST_HPI_HISTORY' AND [top_20_sequence]=91479
UPDATE [dbo].[u_Top_20] SET [item_text]=N'ENT Physical Examination' WHERE [user_id]=N'$IM' AND [top_20_code]=N'TEST_PHYSICAL' AND [top_20_sequence]=11067
UPDATE [dbo].[u_Top_20] SET [item_text]=N'CHIEF COMPLAINT AND HISTORY OF PRESENT ILLNESS' WHERE [user_id]=N'$NEUROLOGY' AND [top_20_code]=N'TEST_HPI_HISTORY' AND [top_20_sequence]=91484
UPDATE [dbo].[u_Top_20] SET [item_text]=N'CHIEF COMPLAINT AND HISTORY OF PRESENT ILLNESS' WHERE [user_id]=N'$OBGYN' AND [top_20_code]=N'TEST_HPI_HISTORY' AND [top_20_sequence]=91493
UPDATE [dbo].[u_Top_20] SET [sort_sequence]=2 WHERE [user_id]=N'$PEDS' AND [top_20_code]=N'TEST_VITAL' AND [top_20_sequence]=4645
UPDATE [dbo].[u_Top_20] SET [sort_sequence]=4 WHERE [user_id]=N'$PEDS' AND [top_20_code]=N'TEST_VITAL' AND [top_20_sequence]=11259
UPDATE [dbo].[u_Top_20] SET [sort_sequence]=1 WHERE [user_id]=N'$PEDS' AND [top_20_code]=N'TEST_VITAL' AND [top_20_sequence]=122358
UPDATE [dbo].[u_Top_20] SET [item_text]=N'CHIEF COMPLAINT AND HISTORY OF PRESENT ILLNESS' WHERE [user_id]=N'$RHEUM' AND [top_20_code]=N'TEST_HPI_HISTORY' AND [top_20_sequence]=80442
UPDATE [dbo].[u_Top_20] SET [item_text]=N'Bilirubin, total' WHERE [user_id]=N'$RHEUM' AND [top_20_code]=N'TEST_LAB' AND [top_20_sequence]=14158
UPDATE [dbo].[u_Top_20] SET [item_text]=N'CHIEF COMPLAINT AND HISTORY OF PRESENT ILLNESS' WHERE [user_id]=N'$UROLOGY' AND [top_20_code]=N'TEST_HPI_HISTORY' AND [top_20_sequence]=82101
UPDATE [dbo].[u_Top_20] SET [item_text]=N'Training', [hits]=35, [last_hit]='20230519 20:22:44.573' WHERE [user_id]=N'981^1' AND [top_20_code]=N'ENCOUNTER_CANCELED' AND [top_20_sequence]=123196
UPDATE [dbo].[c_Maintenance_Patient_Class] SET [status]=N'OK' WHERE [maintenance_rule_id]=1
UPDATE [dbo].[c_Maintenance_Patient_Class] SET [status]=N'OK', [last_reset]='20230316 19:54:37.803' WHERE [maintenance_rule_id]=2
UPDATE [dbo].[c_Maintenance_Patient_Class] SET [status]=N'OK', [last_reset]='20230317 21:25:20.327' WHERE [maintenance_rule_id]=4
UPDATE [dbo].[c_Maintenance_Patient_Class] SET [age_range_id]=103, [last_reset]='20230317 19:31:41.080', [compliance_ok_percent]=0 WHERE [maintenance_rule_id]=12
UPDATE [dbo].[c_Maintenance_Patient_Class] SET [status]=N'OK', [last_reset]='20230317 19:28:58.597' WHERE [maintenance_rule_id]=21
UPDATE [dbo].[c_Maintenance_Patient_Class] SET [status]=N'NA', [last_reset]='20230317 21:52:57.553' WHERE [maintenance_rule_id]=23
UPDATE [dbo].[c_Maintenance_Patient_Class] SET [status]=N'NA' WHERE [maintenance_rule_id]=27
UPDATE [dbo].[c_Maintenance_Patient_Class] SET [status]=N'NA' WHERE [maintenance_rule_id]=28
UPDATE [dbo].[c_Maintenance_Patient_Class] SET [status]=N'NA' WHERE [maintenance_rule_id]=36
UPDATE [dbo].[c_Maintenance_Patient_Class] SET [status]=N'NA', [last_reset]='20230317 21:14:37.043' WHERE [maintenance_rule_id]=38
UPDATE [dbo].[c_Workplan_Step] SET [step_number]=2 WHERE [workplan_id]=2175 AND [workplan_step_id]=9930
UPDATE [dbo].[c_Workplan_Step] SET [step_number]=4 WHERE [workplan_id]=2175 AND [workplan_step_id]=9931
UPDATE [dbo].[c_Workplan_Step] SET [step_number]=5 WHERE [workplan_id]=2175 AND [workplan_step_id]=9932
UPDATE [dbo].[c_Workplan_Step] SET [step_number]=3 WHERE [workplan_id]=2175 AND [workplan_step_id]=9966
UPDATE [dbo].[c_Workplan_Step] SET [room_type]=NULL WHERE [workplan_id]=1000032 AND [workplan_step_id]=1000237
UPDATE [dbo].[c_Workplan_Step] SET [step_number]=4 WHERE [workplan_id]=1000032 AND [workplan_step_id]=1000238
UPDATE [dbo].[c_Workplan_Step] SET [step_number]=3 WHERE [workplan_id]=1000032 AND [workplan_step_id]=1000239
UPDATE [dbo].[c_Workplan_Step] SET [step_number]=6 WHERE [workplan_id]=1000032 AND [workplan_step_id]=1000242
UPDATE [dbo].[c_Workplan_Step] SET [step_number]=7 WHERE [workplan_id]=1000032 AND [workplan_step_id]=1000245
UPDATE [dbo].[c_Workplan_Step] SET [step_number]=5 WHERE [workplan_id]=1000032 AND [workplan_step_id]=1000247
UPDATE [dbo].[c_Disease_Group_Item] SET [owner_id]=2209 WHERE [disease_group]=N'DTaP' AND [disease_id]=2
UPDATE [dbo].[c_Disease_Group_Item] SET [owner_id]=2209 WHERE [disease_group]=N'DTaP' AND [disease_id]=3
UPDATE [dbo].[c_Disease_Group_Item] SET [owner_id]=2209 WHERE [disease_group]=N'DTaP' AND [disease_id]=4
UPDATE [dbo].[c_Disease_Group_Item] SET [owner_id]=2209 WHERE [disease_group]=N'HepA' AND [disease_id]=7
UPDATE [dbo].[c_Disease_Group_Item] SET [owner_id]=2209 WHERE [disease_group]=N'HepB' AND [disease_id]=8
UPDATE [dbo].[c_Disease_Group_Item] SET [owner_id]=2209 WHERE [disease_group]=N'HIB' AND [disease_id]=5
UPDATE [dbo].[c_Disease_Group_Item] SET [owner_id]=2209 WHERE [disease_group]=N'HPV' AND [disease_id]=454
UPDATE [dbo].[c_Disease_Group_Item] SET [owner_id]=2209 WHERE [disease_group]=N'Influenza' AND [disease_id]=453
UPDATE [dbo].[c_Disease_Group_Item] SET [owner_id]=2209 WHERE [disease_group]=N'Mening' AND [disease_id]=352
UPDATE [dbo].[c_Disease_Group_Item] SET [owner_id]=2209 WHERE [disease_group]=N'MMR' AND [disease_id]=10
UPDATE [dbo].[c_Disease_Group_Item] SET [owner_id]=2209 WHERE [disease_group]=N'MMR' AND [disease_id]=11
UPDATE [dbo].[c_Disease_Group_Item] SET [owner_id]=2209 WHERE [disease_group]=N'MMR' AND [disease_id]=12
UPDATE [dbo].[c_Disease_Group_Item] SET [owner_id]=2209 WHERE [disease_group]=N'Pneumococcal' AND [disease_id]=450
UPDATE [dbo].[c_Disease_Group_Item] SET [owner_id]=2209 WHERE [disease_group]=N'Polio' AND [disease_id]=6
UPDATE [dbo].[c_Disease_Group_Item] SET [owner_id]=2209 WHERE [disease_group]=N'Rotavirus' AND [disease_id]=455
UPDATE [dbo].[c_Disease_Group_Item] SET [owner_id]=2209 WHERE [disease_group]=N'TdaP' AND [disease_id]=456
UPDATE [dbo].[c_Disease_Group_Item] SET [owner_id]=2209 WHERE [disease_group]=N'TdaP' AND [disease_id]=457
UPDATE [dbo].[c_Disease_Group_Item] SET [owner_id]=2209 WHERE [disease_group]=N'TdaP' AND [disease_id]=458
UPDATE [dbo].[c_Disease_Group_Item] SET [owner_id]=2209 WHERE [disease_group]=N'Varicella' AND [disease_id]=9
UPDATE [dbo].[u_Chart_Selection] SET [chart_id]=24 WHERE [chart_selection_id]=9
UPDATE [dbo].[u_Chart_Selection] SET [chart_id]=44 WHERE [chart_selection_id]=29
UPDATE [dbo].[c_Observation_Result_Range] SET [high_severity]=1500, [very_high_severity]=2000 WHERE [observation_id]=N'DEMO2427' AND [result_sequence]=14 AND [result_range_sequence]=25
UPDATE [dbo].[c_Component_Interface] SET [description]=N'Linked Lab Results' WHERE [interfaceServiceId]=100
UPDATE [dbo].[c_Component_Interface] SET [status]=N'NA' WHERE [interfaceServiceId]=122
UPDATE [dbo].[c_Component_Interface] SET [status]=N'NA' WHERE [interfaceServiceId]=150
UPDATE [dbo].[c_Component_Interface] SET [description]=N'Linked RX' WHERE [interfaceServiceId]=211
UPDATE [dbo].[c_Component_Interface] SET [status]=N'NA' WHERE [interfaceServiceId]=214
UPDATE [dbo].[c_Component_Interface] SET [status]=N'NA' WHERE [interfaceServiceId]=360
UPDATE [dbo].[c_Component_Param] SET [param_class]=N'u_param_string' WHERE [id]=N'0f6b1dfc-1f12-4eac-8540-37a12b90a33f' AND [param_sequence]=1000420
UPDATE [dbo].[c_Component_Param] SET [sort_sequence]=2, [param_title]=N'Standard Note Type' WHERE [id]=N'38276d5f-f7b9-45da-b0d3-3a522ac53641' AND [param_sequence]=1000435
UPDATE [dbo].[c_Component_Param] SET [sort_sequence]=3, [param_title]=N'Special Note Type' WHERE [id]=N'38276d5f-f7b9-45da-b0d3-3a522ac53641' AND [param_sequence]=1000436
UPDATE [dbo].[c_Component_Param] SET [param_class]=N'u_param_popup_single', [sort_sequence]=1 WHERE [id]=N'38276d5f-f7b9-45da-b0d3-3a522ac53641' AND [param_sequence]=1000437
UPDATE [dbo].[c_Component_Param] SET [sort_sequence]=10 WHERE [id]=N'b7f89d7c-0beb-4700-965d-5f62bd74a1d7' AND [param_sequence]=1000637
UPDATE [dbo].[c_Component_Param] SET [sort_sequence]=7 WHERE [id]=N'b7f89d7c-0beb-4700-965d-5f62bd74a1d7' AND [param_sequence]=1000644
UPDATE [dbo].[c_Component_Param] SET [sort_sequence]=9 WHERE [id]=N'b7f89d7c-0beb-4700-965d-5f62bd74a1d7' AND [param_sequence]=1000646
UPDATE [dbo].[c_Component_Param] SET [sort_sequence]=16 WHERE [id]=N'b7f89d7c-0beb-4700-965d-5f62bd74a1d7' AND [param_sequence]=1000649
UPDATE [dbo].[c_Component_Param] SET [sort_sequence]=15 WHERE [id]=N'b7f89d7c-0beb-4700-965d-5f62bd74a1d7' AND [param_sequence]=1001679
UPDATE [dbo].[c_Component_Param] SET [param_class]=N'Patient Material' WHERE [id]=N'd4630ef7-c063-4138-a39d-cb45d28a250a' AND [param_sequence]=1001219
UPDATE [dbo].[c_Chart_Page_Attribute] SET [value]=N'True' WHERE [page_class]=N'u_soap_page_problem_list' AND [attribute_sequence]=1000003
UPDATE [dbo].[c_Preference] SET [help]=N'Where you want EP to store files temporarily, normally "c:\temp"' WHERE [preference_id]=N'temp_path'
UPDATE [dbo].[c_Drug_Generic] SET [valid_in]=N'us;ke;ug;' WHERE [uq_name_checksum]=789159993
UPDATE [dbo].[c_Drug_Brand] SET [brand_name_rxcui]=N'UGBI3456', [drug_id]=N'UGBI3456' WHERE [brand_name]=N'Pregavalex'
UPDATE [dbo].[c_Workplan_Item] SET [description]=N'Edit Other HX Drilldown' WHERE [workplan_id]=1270 AND [item_number]=1071
UPDATE [dbo].[c_Workplan_Item] SET [ordered_for]=N'!Everyone' WHERE [workplan_id]=1531 AND [item_number]=2669
UPDATE [dbo].[c_Workplan_Item] SET [description]=N'Edit CC/HPI Vitals Format' WHERE [workplan_id]=1975 AND [item_number]=6420
UPDATE [dbo].[c_Workplan_Item] SET [observation_tag]=N'KIGALI' WHERE [workplan_id]=2052 AND [item_number]=7790
UPDATE [dbo].[c_Workplan_Item] SET [step_number]=2, [ordered_for]=N'!CliniSupp' WHERE [workplan_id]=2175 AND [item_number]=8035
UPDATE [dbo].[c_Workplan_Item] SET [step_number]=4, [cancel_workplan_flag]=N'N', [consolidate_flag]=N'N' WHERE [workplan_id]=2175 AND [item_number]=8036
UPDATE [dbo].[c_Workplan_Item] SET [step_number]=5, [ordered_for]=N'!CliniSupp' WHERE [workplan_id]=2175 AND [item_number]=8037
UPDATE [dbo].[c_Workplan_Item] SET [step_number]=3, [ordered_for]=N'!CliniSupp' WHERE [workplan_id]=2175 AND [item_number]=8072
UPDATE [dbo].[c_Workplan_Item] SET [description]=N'New Note' WHERE [workplan_id]=1000030 AND [item_number]=1000230
UPDATE [dbo].[c_Workplan_Item] SET [step_number]=4 WHERE [workplan_id]=1000032 AND [item_number]=1000242
UPDATE [dbo].[c_Workplan_Item] SET [step_number]=3, [priority]=4, [cancel_workplan_flag]=N'Y' WHERE [workplan_id]=1000032 AND [item_number]=1000243
UPDATE [dbo].[c_Workplan_Item] SET [description]=N'Examination' WHERE [workplan_id]=1000032 AND [item_number]=1000244
UPDATE [dbo].[c_Workplan_Item] SET [sort_sequence]=4, [owner_flag]=N'Y' WHERE [workplan_id]=1000032 AND [item_number]=1000246
UPDATE [dbo].[c_Workplan_Item] SET [description]=N'New Note' WHERE [workplan_id]=1000032 AND [item_number]=1000247
UPDATE [dbo].[c_Workplan_Item] SET [step_number]=7 WHERE [workplan_id]=1000032 AND [item_number]=1000248
UPDATE [dbo].[c_Workplan_Item] SET [step_number]=5, [ordered_for]=N'!PHYSICIAN' WHERE [workplan_id]=1000032 AND [item_number]=1000250
UPDATE [dbo].[c_Workplan_Item] SET [step_number]=6 WHERE [workplan_id]=1000032 AND [item_number]=1000369
UPDATE [dbo].[c_Workplan_Item] SET [description]=N'Treatment Dashboard' WHERE [workplan_id]=1000051 AND [item_number]=1000361
UPDATE [dbo].[c_Workplan_Item] SET [expiration_time]=5, [expiration_unit_id]=N'MINUTE' WHERE [workplan_id]=1000060 AND [item_number]=1000388
UPDATE [dbo].[c_Workplan_Item] SET [ordered_for]=N'!LabTech' WHERE [workplan_id]=1000061 AND [item_number]=1000390
UPDATE [dbo].[c_Workplan_Item] SET [ordered_for]=N'!LabTech' WHERE [workplan_id]=1000061 AND [item_number]=1000391
UPDATE [dbo].[c_Workplan_Item] SET [step_flag]=N'N' WHERE [workplan_id]=1000066 AND [item_number]=1000402
UPDATE [dbo].[c_Chart_Section] SET [tab_location]=N'T' WHERE [chart_id]=7 AND [section_id]=43
UPDATE [dbo].[c_Chart_Section] SET [sort_sequence]=3, [description]=N'Procedures', [bitmap]=N'icon012.bmp', [tab_location]=N'T' WHERE [chart_id]=13 AND [section_id]=148
UPDATE [dbo].[c_Chart_Section] SET [sort_sequence]=2, [description]=N'Clinic Notes' WHERE [chart_id]=13 AND [section_id]=149
UPDATE [dbo].[c_Chart_Section] SET [sort_sequence]=4 WHERE [chart_id]=13 AND [section_id]=150
UPDATE [dbo].[c_Chart_Section] SET [sort_sequence]=5, [description]=N'Vaccines', [bitmap]=N'button_virus.bmp' WHERE [chart_id]=13 AND [section_id]=151
UPDATE [dbo].[c_Chart_Section] SET [sort_sequence]=6 WHERE [chart_id]=13 AND [section_id]=152
UPDATE [dbo].[c_Chart_Section] SET [sort_sequence]=3, [description]=N'Procedures', [bitmap]=N'icon012.bmp' WHERE [chart_id]=44 AND [section_id]=235
UPDATE [dbo].[c_Chart_Section] SET [sort_sequence]=2, [description]=N'Clinic Notes' WHERE [chart_id]=44 AND [section_id]=236
UPDATE [dbo].[c_Chart_Section] SET [sort_sequence]=4 WHERE [chart_id]=44 AND [section_id]=237
UPDATE [dbo].[c_Chart_Section] SET [sort_sequence]=5, [description]=N'Vaccines', [bitmap]=N'button_virus.bmp' WHERE [chart_id]=44 AND [section_id]=238
UPDATE [dbo].[c_Chart_Section] SET [sort_sequence]=6 WHERE [chart_id]=44 AND [section_id]=239
UPDATE [dbo].[c_Workplan] SET [status]=N'NA' WHERE [workplan_id]=1269
UPDATE [dbo].[c_Workplan] SET [status]=N'NA' WHERE [workplan_id]=1547
UPDATE [dbo].[c_Workplan] SET [status]=N'NA' WHERE [workplan_id]=1597
UPDATE [dbo].[c_Workplan] SET [status]=N'NA' WHERE [workplan_id]=1663
UPDATE [dbo].[c_Workplan] SET [status]=N'NA' WHERE [workplan_id]=1943
UPDATE [dbo].[c_Workplan] SET [status]=N'NA' WHERE [workplan_id]=1983
UPDATE [dbo].[c_Workplan] SET [status]=N'NA' WHERE [workplan_id]=1994
UPDATE [dbo].[c_Workplan] SET [specialty_id]=N'$ALLERGY' WHERE [workplan_id]=2175
UPDATE [dbo].[u_assessment_treat_def_attrib] SET [attribute]=N'treatment_mode', [value]=N'Enc Col Perf Rev Cons' WHERE [definition_id]=81165 AND [attribute_sequence]=134100
UPDATE [dbo].[c_Location] SET [status]=N'NA' WHERE [location]=N'DEMO12795'
UPDATE [dbo].[c_Location] SET [status]=N'NA' WHERE [location]=N'DEMO12796'
UPDATE [dbo].[c_Location] SET [status]=N'NA' WHERE [location]=N'DEMO12797'
UPDATE [dbo].[c_Location] SET [sort_sequence]=2 WHERE [location]=N'DEMO12798'
UPDATE [dbo].[c_Location] SET [status]=N'NA' WHERE [location]=N'DEMO12799'
UPDATE [dbo].[c_Location] SET [status]=N'NA' WHERE [location]=N'DEMO12800'
UPDATE [dbo].[c_Location] SET [status]=N'NA' WHERE [location]=N'DEMO12801'
UPDATE [dbo].[c_Location] SET [status]=N'NA' WHERE [location]=N'DEMO15527'
UPDATE [dbo].[c_Location] SET [status]=N'NA' WHERE [location]=N'DEMO15528'
UPDATE [dbo].[c_Location] SET [status]=N'NA' WHERE [location]=N'DEMO15529'
UPDATE [dbo].[c_Location] SET [status]=N'NA' WHERE [location]=N'DEMO15530'
UPDATE [dbo].[c_Location] SET [status]=N'NA' WHERE [location]=N'DEMO15531'
UPDATE [dbo].[c_Location] SET [status]=N'NA' WHERE [location]=N'DEMO15532'
UPDATE [dbo].[c_Location] SET [status]=N'NA' WHERE [location]=N'DEMO15533'
UPDATE [dbo].[c_Location] SET [status]=N'NA' WHERE [location]=N'DEMO15534'
UPDATE [dbo].[c_Location] SET [status]=N'NA' WHERE [location]=N'DEMO15535'
UPDATE [dbo].[c_Location] SET [status]=N'NA' WHERE [location]=N'DEMO15600'
UPDATE [dbo].[c_Location] SET [sort_sequence]=10 WHERE [location]=N'DEMO15601'
UPDATE [dbo].[c_Location] SET [sort_sequence]=11 WHERE [location]=N'DEMO15602'
UPDATE [dbo].[c_Location] SET [status]=N'NA' WHERE [location]=N'DEMO3675'
UPDATE [dbo].[c_Location] SET [sort_sequence]=15 WHERE [location]=N'DEMO5589'
UPDATE [dbo].[c_Location] SET [sort_sequence]=16 WHERE [location]=N'DEMO5590'
UPDATE [dbo].[c_Location] SET [sort_sequence]=1, [diffuse_flag]=N'Y' WHERE [location]=N'DEMO828'
UPDATE [dbo].[c_Location] SET [sort_sequence]=2 WHERE [location]=N'DEMO829'
UPDATE [dbo].[c_Location] SET [sort_sequence]=3 WHERE [location]=N'DEMO842'
UPDATE [dbo].[c_Location] SET [sort_sequence]=4 WHERE [location]=N'DEMO843'
UPDATE [dbo].[c_Location] SET [sort_sequence]=5 WHERE [location]=N'DEMO844'
UPDATE [dbo].[c_Location] SET [sort_sequence]=6 WHERE [location]=N'DEMO845'
UPDATE [dbo].[c_Location] SET [sort_sequence]=7 WHERE [location]=N'DEMO846'
UPDATE [dbo].[c_Location] SET [sort_sequence]=8 WHERE [location]=N'DEMO847'
UPDATE [dbo].[c_Location] SET [sort_sequence]=9 WHERE [location]=N'DEMO848'
UPDATE [dbo].[c_Location] SET [sort_sequence]=10 WHERE [location]=N'DEMO849'
UPDATE [dbo].[c_Location] SET [sort_sequence]=11 WHERE [location]=N'DEMO850'
UPDATE [dbo].[c_Location] SET [sort_sequence]=12 WHERE [location]=N'DEMO851'
UPDATE [dbo].[c_Location] SET [sort_sequence]=13 WHERE [location]=N'DEMO852'
UPDATE [dbo].[c_Location] SET [sort_sequence]=14 WHERE [location]=N'DEMO853'
UPDATE [dbo].[c_Office] SET [description]=N'Living Stone Medical Specialists', [address1]=N'Plot 112 Muteesa II Rd', [address2]=N'Ntinda', [city]=N'Kampala', [state]=N'UG', [zip]=NULL, [phone]=N'+256778532521', [billing_component_id]=N'FOXMEADOWS_BILL', [country]=N'UG' WHERE [office_id]=N'0001'
UPDATE [dbo].[c_User_Role] SET [role_order]=2 WHERE [user_id]=N'981^2' AND [role_id]=N'!Everyone'
UPDATE [dbo].[c_User_Role] SET [role_order]=1 WHERE [user_id]=N'981^2' AND [role_id]=N'!PHYSICIAN'
UPDATE [dbo].[c_XML_Code_Domain_Item] SET [code]=N'The County is required', [code_description]=N'The County is required', [created]='20190430 15:37:26.120', [last_updated]='20190430 15:37:26.120', [id]=N'7bb3c593-3d62-4413-ac5d-303de16b84b3' WHERE [owner_id]=0 AND [code_domain]=N'EproHelpContext' AND [code_domain_item_id]=56230
UPDATE [dbo].[c_XML_Code_Domain_Item] SET [code]=N'The id document number is required', [code_description]=N'The id document number is required', [created]='20190430 15:37:56.770', [last_updated]='20190430 15:37:56.770', [id]=N'042def1e-c662-446f-bb6f-bb78b0fe3834' WHERE [owner_id]=0 AND [code_domain]=N'EproHelpContext' AND [code_domain_item_id]=56231
UPDATE [dbo].[c_XML_Code_Domain_Item] SET [code]=N'The patient''s gender is required', [code_description]=N'The patient''s gender is required', [created]='20190430 15:38:55.810', [last_updated]='20190430 15:38:55.810', [id]=N'6893d9dd-c890-4b0c-ba15-1dd3bda4cc0f' WHERE [owner_id]=0 AND [code_domain]=N'EproHelpContext' AND [code_domain_item_id]=56232
UPDATE [dbo].[c_XML_Code_Domain_Item] SET [code]=N'The patient''s last name is required', [code_description]=N'The patient''s last name is required', [created]='20190430 16:16:05.190', [last_updated]='20190430 16:16:05.190', [id]=N'25000cd5-4764-42b5-a376-8ebda37674c2' WHERE [owner_id]=0 AND [code_domain]=N'EproHelpContext' AND [code_domain_item_id]=56233
UPDATE [dbo].[c_XML_Code_Domain_Item] SET [code]=N'The Locality 3 is required', [code_description]=N'The Locality 3 is required', [created]='20190430 17:24:16.523', [last_updated]='20190430 17:24:16.523', [id]=N'c2c35099-3807-44c8-aa01-9af8f842b388' WHERE [owner_id]=0 AND [code_domain]=N'EproHelpContext' AND [code_domain_item_id]=56234
UPDATE [dbo].[c_XML_Code_Domain_Item] SET [code]=N'The id document type is required', [code_description]=N'The id document type is required', [created]='20190503 17:03:18.940', [last_updated]='20190503 17:03:18.940', [id]=N'e615a146-221f-48dd-b879-3db398dc37f4' WHERE [owner_id]=0 AND [code_domain]=N'EproHelpContext' AND [code_domain_item_id]=56235
UPDATE [dbo].[c_XML_Code_Domain_Item] SET [code]=N'The Province is required', [code_description]=N'The Province is required', [created]='20190503 17:03:21.153', [last_updated]='20190503 17:03:21.153', [id]=N'038dd391-ba92-45ca-9d8d-b21efe4b4d93' WHERE [owner_id]=0 AND [code_domain]=N'EproHelpContext' AND [code_domain_item_id]=56236
UPDATE [dbo].[c_XML_Code_Domain_Item] SET [code]=N'You are not authorized to perform the Authorize Services service.', [code_description]=N'You are not authorized to perform the Authorize Services service.', [created]='20190510 17:37:01.180', [last_updated]='20190510 17:37:01.180', [id]=N'6e9fd796-59a8-47f1-be20-2265781e8462' WHERE [owner_id]=0 AND [code_domain]=N'EproHelpContext' AND [code_domain_item_id]=56237
UPDATE [dbo].[c_XML_Code_Domain_Item] SET [code]=N'The username was successfully changed to PrivTest.', [code_description]=N'The username was successfully changed to PrivTest.', [created]='20190510 17:41:44.190', [last_updated]='20190510 17:41:44.190', [id]=N'd144837f-11de-4aa8-960b-29db0f5d7a59' WHERE [owner_id]=0 AND [code_domain]=N'EproHelpContext' AND [code_domain_item_id]=56238
UPDATE [dbo].[c_XML_Code_Domain_Item] SET [code]=N'You are not authorized to perform the View Chart service.', [code_description]=N'You are not authorized to perform the View Chart service.', [created]='20190510 17:45:45.200', [last_updated]='20190510 17:45:45.200', [id]=N'473be21e-59c8-4978-b57b-a257a395304f' WHERE [owner_id]=0 AND [code_domain]=N'EproHelpContext' AND [code_domain_item_id]=56239
UPDATE [dbo].[c_XML_Code_Domain_Item] SET [code]=N'The Locality 4 is required', [code_description]=N'The Locality 4 is required', [created]='20190510 18:40:21.830', [last_updated]='20190510 18:40:21.830', [id]=N'7fc8d4f9-cb79-4a98-ba7d-bd40e7d8b0de' WHERE [owner_id]=0 AND [code_domain]=N'EproHelpContext' AND [code_domain_item_id]=56240
UPDATE [dbo].[c_XML_Code_Domain_Item] SET [code]=N'The umudugudu is required', [code_description]=N'The umudugudu is required', [created]='20190511 16:10:54.763', [last_updated]='20190511 16:10:54.763', [id]=N'1a000e82-9626-488c-9ef6-d308c14cfea1' WHERE [owner_id]=0 AND [code_domain]=N'EproHelpContext' AND [code_domain_item_id]=56241
UPDATE [dbo].[c_XML_Code_Domain_Item] SET [code]=N'You are not authorized to perform the Configure Diagnosis service.', [code_description]=N'You are not authorized to perform the Configure Diagnosis service.', [created]='20190511 16:46:51.733', [last_updated]='20190511 16:46:51.733', [id]=N'6f993fa9-57e4-489f-9b63-392ed3dcff90' WHERE [owner_id]=0 AND [code_domain]=N'EproHelpContext' AND [code_domain_item_id]=56242
UPDATE [dbo].[c_XML_Code_Domain_Item] SET [code]=N'You are not authorized to perform the Configure Drugs service.', [code_description]=N'You are not authorized to perform the Configure Drugs service.', [created]='20190511 16:46:54.253', [last_updated]='20190511 16:46:54.253', [id]=N'5cd16f4b-62ca-4c93-99e7-2544259ecf7e' WHERE [owner_id]=0 AND [code_domain]=N'EproHelpContext' AND [code_domain_item_id]=56243
UPDATE [dbo].[c_XML_Code_Domain_Item] SET [code]=N'You are not authorized to perform the Configure Observation service.', [code_description]=N'You are not authorized to perform the Configure Observation service.', [created]='20190511 16:58:43.270', [last_updated]='20190511 16:58:43.270', [id]=N'898a0b76-418b-46c6-80f5-180679d29ab9' WHERE [owner_id]=0 AND [code_domain]=N'EproHelpContext' AND [code_domain_item_id]=56244
UPDATE [dbo].[c_XML_Code_Domain_Item] SET [code]=N'You are not authorized to perform the Configure Preferences service.', [code_description]=N'You are not authorized to perform the Configure Preferences service.', [created]='20190511 16:58:51.760', [last_updated]='20190511 16:58:51.760', [id]=N'1fb522aa-21fc-4796-91b1-ec7d00222bce' WHERE [owner_id]=0 AND [code_domain]=N'EproHelpContext' AND [code_domain_item_id]=56245
UPDATE [dbo].[c_XML_Code_Domain_Item] SET [code]=N'Successfully Ordered Document "NewRX for Advil (Ibuprofen), Tabs 200 mg: 4 Tabs ', [code_description]=N'Successfully Ordered Document "NewRX for Advil (Ibuprofen), Tabs 200 mg: 4 Tabs ', [created]='20190511 17:15:07.467', [last_updated]='20190511 17:15:07.467', [id]=N'7de3fee7-8b70-45de-84ab-1a8d610f18de' WHERE [owner_id]=0 AND [code_domain]=N'EproHelpContext' AND [code_domain_item_id]=56246
UPDATE [dbo].[c_XML_Code_Domain_Item] SET [code]=N'Successfully Ordered Document "NewRX for Abilify Tab 15 mg  QD"', [code_description]=N'Successfully Ordered Document "NewRX for Abilify Tab 15 mg  QD"', [created]='20190511 17:15:51.720', [last_updated]='20190511 17:15:51.720', [id]=N'bcb27564-bb3d-4b7d-a32d-a29268be767e' WHERE [owner_id]=0 AND [code_domain]=N'EproHelpContext' AND [code_domain_item_id]=56247
UPDATE [dbo].[c_XML_Code_Domain_Item] SET [code]=N'Successfully Ordered Document "NewRX for Allegra (fexofenadine), Tabs 60 mg: 1 T', [code_description]=N'Successfully Ordered Document "NewRX for Allegra (fexofenadine), Tabs 60 mg: 1 T', [created]='20190511 17:17:59.257', [last_updated]='20190511 17:17:59.257', [id]=N'df5b0082-1b3e-4a3f-8d38-bd8eb669f0f4' WHERE [owner_id]=0 AND [code_domain]=N'EproHelpContext' AND [code_domain_item_id]=56248
UPDATE [dbo].[c_XML_Code_Domain_Item] SET [code]=N'Successfully Ordered Document "NewRX for Vigamox Eye Drops 1 Drop  TID"', [code_description]=N'Successfully Ordered Document "NewRX for Vigamox Eye Drops 1 Drop  TID"', [created]='20190511 17:20:20.747', [last_updated]='20190511 17:20:20.747', [id]=N'65793c27-85d6-4d24-8866-8b2bf295a59a' WHERE [owner_id]=0 AND [code_domain]=N'EproHelpContext' AND [code_domain_item_id]=56249
UPDATE [dbo].[c_XML_Code_Domain_Item] SET [code]=N'Successfully Ordered Document "NewRX for Fluconazole Tab 100 mg  Q24H"', [code_description]=N'Successfully Ordered Document "NewRX for Fluconazole Tab 100 mg  Q24H"', [created]='20190511 17:33:56.163', [last_updated]='20190511 17:33:56.163', [id]=N'a9a5c3af-2955-4cc3-85de-8916d3260dbf' WHERE [owner_id]=0 AND [code_domain]=N'EproHelpContext' AND [code_domain_item_id]=56250
UPDATE [dbo].[c_XML_Code_Domain_Item] SET [code]=N'This service has no "Config" parameters', [code_description]=N'This service has no "Config" parameters', [created]='20190511 20:12:09.013', [last_updated]='20190511 20:12:09.013', [id]=N'f1f8d75d-128d-473f-9f94-2fe077d5dbe2' WHERE [owner_id]=0 AND [code_domain]=N'EproHelpContext' AND [code_domain_item_id]=56251
UPDATE [dbo].[c_XML_Code_Domain_Item] SET [code]=N'You are not authorized to perform the Child CC and Vitals service.', [code_description]=N'You are not authorized to perform the Child CC and Vitals service.', [created]='20190511 20:27:20.207', [last_updated]='20190511 20:27:20.207', [id]=N'18946e94-f1b9-4c1b-850a-ac34dd009117' WHERE [owner_id]=0 AND [code_domain]=N'EproHelpContext' AND [code_domain_item_id]=56252
UPDATE [dbo].[c_XML_Code] SET [code]=N'The County is required', [created]='20190430 15:37:26.113', [created_by]=N'CLINSUPT', [last_updated]='20190430 15:37:26.113', [id]=N'6f902911-692f-4abb-8d5d-be6e60f61493', [code_description]=N'The County is required' WHERE [code_id]=1065840
UPDATE [dbo].[c_XML_Code] SET [code]=N'The id document number is required', [created]='20190430 15:37:56.767', [created_by]=N'CLINSUPT', [last_updated]='20190430 15:37:56.767', [id]=N'1cf34bc9-2a53-43f0-b66d-4b27d82342a6', [code_description]=N'The id document number is required' WHERE [code_id]=1065841
UPDATE [dbo].[c_XML_Code] SET [code]=N'The patient''s gender is required', [created]='20190430 15:38:55.807', [created_by]=N'CLINSUPT', [last_updated]='20190430 15:38:55.807', [id]=N'5a4e6740-a4c3-441d-a9af-419ceb5ed548', [code_description]=N'The patient''s gender is required' WHERE [code_id]=1065842
UPDATE [dbo].[c_XML_Code] SET [code]=N'The patient''s last name is required', [created]='20190430 16:16:05.190', [created_by]=N'CLINSUPT', [last_updated]='20190430 16:16:05.190', [id]=N'8072582b-8412-4699-b2c9-90e4958d34b1', [code_description]=N'The patient''s last name is required' WHERE [code_id]=1065843
UPDATE [dbo].[c_XML_Code] SET [code]=N'The Locality 3 is required', [created]='20190430 17:24:16.523', [created_by]=N'CLINSUPT', [last_updated]='20190430 17:24:16.523', [id]=N'f58f241c-2bcf-4bf5-be19-d54d2ddd11cc', [code_description]=N'The Locality 3 is required' WHERE [code_id]=1065844
UPDATE [dbo].[c_XML_Code] SET [code]=N'The id document type is required', [created]='20190503 17:03:18.923', [created_by]=N'CLINSUPT', [last_updated]='20190503 17:03:18.923', [id]=N'1eab5555-16c0-4006-8509-7f7d817fed57', [code_description]=N'The id document type is required' WHERE [code_id]=1065845
UPDATE [dbo].[c_XML_Code] SET [code]=N'The Province is required', [created]='20190503 17:03:21.153', [created_by]=N'CLINSUPT', [last_updated]='20190503 17:03:21.153', [id]=N'73730250-5d95-4579-8ce9-1bae48c1a43e', [code_description]=N'The Province is required' WHERE [code_id]=1065846
UPDATE [dbo].[c_XML_Code] SET [code]=N'You are not authorized to perform the Authorize Services service.', [created]='20190510 17:37:01.160', [last_updated]='20190510 17:37:01.160', [id]=N'84803ab6-440a-47ee-b280-b41efa603507', [code_description]=N'You are not authorized to perform the Authorize Services service.' WHERE [code_id]=1065847
UPDATE [dbo].[c_XML_Code] SET [code]=N'The username was successfully changed to PrivTest.', [created]='20190510 17:41:44.190', [created_by]=N'CLINSUPT', [last_updated]='20190510 17:41:44.190', [id]=N'f54ef441-05b3-4940-802e-0e5e0183b53a', [code_description]=N'The username was successfully changed to PrivTest.' WHERE [code_id]=1065848
UPDATE [dbo].[c_XML_Code] SET [code]=N'You are not authorized to perform the View Chart service.', [created]='20190510 17:45:45.200', [created_by]=N'981^3', [last_updated]='20190510 17:45:45.200', [id]=N'998603ba-e007-48d7-8f70-b39b381c0ea1', [code_description]=N'You are not authorized to perform the View Chart service.' WHERE [code_id]=1065849
UPDATE [dbo].[c_XML_Code] SET [code]=N'The Locality 4 is required', [created]='20190510 18:40:21.830', [created_by]=N'981^3', [last_updated]='20190510 18:40:21.830', [id]=N'7158b779-328c-4282-8dcc-db834d2baedb', [code_description]=N'The Locality 4 is required' WHERE [code_id]=1065850
UPDATE [dbo].[c_XML_Code] SET [code]=N'You are not authorized to perform the Configure Diagnosis service.', [created]='20190511 16:46:51.733', [created_by]=N'981^3', [last_updated]='20190511 16:46:51.733', [id]=N'c489c388-7924-490e-8d4e-851d3ecdec78', [code_description]=N'You are not authorized to perform the Configure Diagnosis service.' WHERE [code_id]=1065852
UPDATE [dbo].[c_XML_Code] SET [code]=N'You are not authorized to perform the Configure Drugs service.', [created]='20190511 16:46:54.250', [created_by]=N'981^3', [last_updated]='20190511 16:46:54.250', [id]=N'd89305f0-6354-42fb-b850-f4970e6adceb', [code_description]=N'You are not authorized to perform the Configure Drugs service.' WHERE [code_id]=1065853
UPDATE [dbo].[c_XML_Code] SET [code]=N'You are not authorized to perform the Configure Observation service.', [created]='20190511 16:58:43.270', [created_by]=N'981^3', [last_updated]='20190511 16:58:43.270', [id]=N'd471ecaf-024b-41ab-b7c7-7229fdaccca3', [code_description]=N'You are not authorized to perform the Configure Observation service.' WHERE [code_id]=1065854
UPDATE [dbo].[c_XML_Code] SET [code]=N'You are not authorized to perform the Configure Preferences service.', [created]='20190511 16:58:51.760', [created_by]=N'981^3', [last_updated]='20190511 16:58:51.760', [id]=N'fb8d5d99-cc89-4fcf-b048-bd943fcd790e', [code_description]=N'You are not authorized to perform the Configure Preferences service.' WHERE [code_id]=1065855
UPDATE [dbo].[c_XML_Code] SET [code]=N'Successfully Ordered Document "NewRX for Advil (Ibuprofen), Tabs 200 mg: 4 Tabs ', [created]='20190511 17:15:07.467', [created_by]=N'981^3', [last_updated]='20190511 17:15:07.467', [id]=N'cee687f4-e761-43c9-915a-6b66141202e4', [code_description]=N'Successfully Ordered Document "NewRX for Advil (Ibuprofen), Tabs 200 mg: 4 Tabs ' WHERE [code_id]=1065856
UPDATE [dbo].[c_XML_Code] SET [code]=N'Successfully Ordered Document "NewRX for Abilify Tab 15 mg  QD"', [created]='20190511 17:15:51.720', [created_by]=N'981^3', [last_updated]='20190511 17:15:51.720', [id]=N'8a331af8-f5cc-4e1d-a0bd-d0372a6d4681', [code_description]=N'Successfully Ordered Document "NewRX for Abilify Tab 15 mg  QD"' WHERE [code_id]=1065857
UPDATE [dbo].[c_XML_Code] SET [code]=N'Successfully Ordered Document "NewRX for Allegra (fexofenadine), Tabs 60 mg: 1 T', [created]='20190511 17:17:59.257', [created_by]=N'CLINSUPT', [last_updated]='20190511 17:17:59.257', [id]=N'478f5b8a-a000-480b-b98f-81b27725d1e9', [code_description]=N'Successfully Ordered Document "NewRX for Allegra (fexofenadine), Tabs 60 mg: 1 T' WHERE [code_id]=1065858
UPDATE [dbo].[c_XML_Code] SET [code]=N'Successfully Ordered Document "NewRX for Vigamox Eye Drops 1 Drop  TID"', [created]='20190511 17:20:20.747', [created_by]=N'981^3', [last_updated]='20190511 17:20:20.747', [id]=N'f59f957f-28c3-45d8-9fec-7875158a95ae', [code_description]=N'Successfully Ordered Document "NewRX for Vigamox Eye Drops 1 Drop  TID"' WHERE [code_id]=1065859
UPDATE [dbo].[c_XML_Code] SET [code]=N'Successfully Ordered Document "NewRX for Fluconazole Tab 100 mg  Q24H"', [created]='20190511 17:33:56.137', [created_by]=N'981^3', [last_updated]='20190511 17:33:56.137', [id]=N'48670432-230c-4314-bba2-6177e1041658', [code_description]=N'Successfully Ordered Document "NewRX for Fluconazole Tab 100 mg  Q24H"' WHERE [code_id]=1065860
UPDATE [dbo].[c_XML_Code] SET [code]=N'This service has no "Config" parameters', [created]='20190511 20:12:09.000', [created_by]=N'CLINSUPT', [last_updated]='20190511 20:12:09.000', [id]=N'b49bb4b8-1c29-4021-913e-aa113923d7e1', [code_description]=N'This service has no "Config" parameters' WHERE [code_id]=1065861
UPDATE [dbo].[c_XML_Code] SET [code]=N'You are not authorized to perform the Child CC and Vitals service.', [created]='20190511 20:27:20.207', [created_by]=N'981^3', [last_updated]='20190511 20:27:20.207', [id]=N'38270a40-8be6-4f50-8747-47270ca3b5c8', [code_description]=N'You are not authorized to perform the Child CC and Vitals service.' WHERE [code_id]=1065862
UPDATE [dbo].[c_XML_Code] SET [code]=N'Successfully Ordered Document "NewRX for Advil (Ibuprofen), Tabs 200 mg: 3 Tabs ', [epro_domain]=N'HelpArticleName', [created]='20190512 12:04:38.587', [created_by]=N'981^3', [last_updated]='20190512 12:04:38.587', [id]=N'09ead95e-c0f5-4718-8f71-5a1eec4f4ba0', [code_description]=N'Successfully Ordered Document "NewRX for Advil (Ibuprofen), Tabs 200 mg: 3 Tabs ' WHERE [code_id]=1065863
UPDATE [dbo].[o_User_Privilege] SET [access_flag]=N'R', [created]='20190517 10:58:17.213', [created_by]=N'CLINSUPT' WHERE [office_id]=N'0001' AND [user_id]=N'981^1' AND [privilege_id]=N'Configuration Mode'
UPDATE [dbo].[o_User_Privilege] SET [access_flag]=N'G', [created]='20210202 13:02:47.877', [created_by]=N'CLINSUPT' WHERE [office_id]=N'0001' AND [user_id]=N'981^2' AND [privilege_id]=N'Audit'
UPDATE [dbo].[o_User_Privilege] SET [access_flag]=N'G', [created]='20210202 13:02:50.507', [created_by]=N'CLINSUPT' WHERE [office_id]=N'0001' AND [user_id]=N'981^2' AND [privilege_id]=N'Scribe'
UPDATE [dbo].[o_Rooms] SET [room_sequence]=16 WHERE [room_id]=N'BILLING'
UPDATE [dbo].[o_Rooms] SET [room_sequence]=21, [room_status]=N'OK' WHERE [room_id]=N'CALL'
UPDATE [dbo].[o_Rooms] SET [room_sequence]=15, [room_status]=N'OK' WHERE [room_id]=N'ENTRY'
UPDATE [dbo].[o_Rooms] SET [room_name]=N'Consult 1', [room_sequence]=3, [room_status]=N'OK', [dirty_flag]=N'N' WHERE [room_id]=N'EXAM_ES1'
UPDATE [dbo].[o_Rooms] SET [room_name]=N'Consult 2', [room_sequence]=4, [room_status]=N'OK', [dirty_flag]=N'N' WHERE [room_id]=N'EXAM_ES2'
UPDATE [dbo].[o_Rooms] SET [room_name]=N'Consult 4', [room_sequence]=6, [room_status]=N'OK', [default_encounter_type]=N'OfficeVisitEstabli', [dirty_flag]=N'N' WHERE [room_id]=N'EXAM_ES3'
UPDATE [dbo].[o_Rooms] SET [room_name]=N'Physician Room', [room_sequence]=2, [room_status]=N'OK', [dirty_flag]=N'N' WHERE [room_id]=N'EXAM_ES4'
UPDATE [dbo].[o_Rooms] SET [room_name]=N'Consult 9', [room_sequence]=26, [dirty_flag]=N'N' WHERE [room_id]=N'EXAM_ES5'
UPDATE [dbo].[o_Rooms] SET [room_name]=N'Lab 1', [room_sequence]=38, [room_type]=N'$LAB', [dirty_flag]=N'N' WHERE [room_id]=N'EXAM_ES6'
UPDATE [dbo].[o_Rooms] SET [room_name]=N'Telephone 2', [room_sequence]=12, [room_type]=N'$TELEPHONE', [default_encounter_type]=N'PHONE', [dirty_flag]=N'N' WHERE [room_id]=N'EXAM_ES7'
UPDATE [dbo].[o_Rooms] SET [room_name]=N'Lab 2', [room_sequence]=39, [room_type]=N'$LAB', [dirty_flag]=N'N' WHERE [room_id]=N'EXAM_ES8'
UPDATE [dbo].[o_Rooms] SET [room_name]=N'Consult 8', [room_sequence]=10, [room_status]=N'OK', [dirty_flag]=N'N' WHERE [room_id]=N'EXAM_SS1'
UPDATE [dbo].[o_Rooms] SET [room_name]=N'Consult 3', [room_sequence]=5, [room_status]=N'OK', [default_encounter_type]=N'SalesEstPat', [dirty_flag]=N'N' WHERE [room_id]=N'EXAM_SS2'
UPDATE [dbo].[o_Rooms] SET [room_name]=N'Consult 11', [room_sequence]=31, [room_status]=N'OK', [default_encounter_type]=N'OfficeVisitEstabli', [dirty_flag]=N'N' WHERE [room_id]=N'EXAM_SS3'
UPDATE [dbo].[o_Rooms] SET [room_name]=N'Consult 5', [room_sequence]=7, [room_status]=N'OK', [dirty_flag]=N'N' WHERE [room_id]=N'EXAM_SS4'
UPDATE [dbo].[o_Rooms] SET [room_name]=N'Consult 10', [room_sequence]=30, [dirty_flag]=N'N' WHERE [room_id]=N'EXAM_SS5'
UPDATE [dbo].[o_Rooms] SET [room_name]=N'Consult 12', [room_sequence]=32, [dirty_flag]=N'N' WHERE [room_id]=N'EXAM_SS6'
UPDATE [dbo].[o_Rooms] SET [room_name]=N'Slot B4', [room_sequence]=9, [room_type]=N'$WAITING', [room_status]=N'OK', [status]=N'NA' WHERE [room_id]=N'EXAM_SS7'
UPDATE [dbo].[o_Rooms] SET [room_name]=N'Treatment Bed 1', [room_sequence]=40, [dirty_flag]=N'N' WHERE [room_id]=N'EXAM_SS8'
UPDATE [dbo].[o_Rooms] SET [room_name]=N'Consult 13', [room_sequence]=33, [room_status]=N'OK', [dirty_flag]=N'N' WHERE [room_id]=N'EXAM1'
UPDATE [dbo].[o_Rooms] SET [room_name]=N'Consult 6', [room_sequence]=8, [room_status]=N'OK', [dirty_flag]=N'N' WHERE [room_id]=N'EXAM2'
UPDATE [dbo].[o_Rooms] SET [room_name]=N'Consult 7', [room_sequence]=9, [room_status]=N'OK', [dirty_flag]=N'N' WHERE [room_id]=N'EXAM3'
UPDATE [dbo].[o_Rooms] SET [room_name]=N'Consult 17', [room_sequence]=37, [room_status]=N'OK', [dirty_flag]=N'N' WHERE [room_id]=N'EXAM4'
UPDATE [dbo].[o_Rooms] SET [room_name]=N'Consult 14', [room_sequence]=34, [room_status]=N'OK', [dirty_flag]=N'N' WHERE [room_id]=N'EXAM5'
UPDATE [dbo].[o_Rooms] SET [room_name]=N'Phone 3', [room_sequence]=29, [room_type]=N'$TELEPHONE', [room_status]=N'OK', [default_encounter_type]=N'TelephonEncountnonbill', [dirty_flag]=N'N' WHERE [room_id]=N'EXAM6'
UPDATE [dbo].[o_Rooms] SET [room_name]=N'Telephone 1', [room_sequence]=11, [room_type]=N'$TELEPHONE', [room_status]=N'OK', [default_encounter_type]=N'PHONE', [dirty_flag]=N'N' WHERE [room_id]=N'EXAM7'
UPDATE [dbo].[o_Rooms] SET [room_name]=N'Treatment Bed 2', [room_sequence]=41, [room_status]=N'OK', [dirty_flag]=N'N' WHERE [room_id]=N'EXAM8'
UPDATE [dbo].[o_Rooms] SET [room_name]=N'Chart Documentation 2', [room_sequence]=14, [room_status]=N'OK', [dirty_flag]=N'N' WHERE [room_id]=N'HOLDING'
UPDATE [dbo].[o_Rooms] SET [room_name]=N'Physician Initiated Call', [room_sequence]=20, [room_status]=N'OK', [default_encounter_type]=N'PHONE1' WHERE [room_id]=N'PHONE'
UPDATE [dbo].[o_Rooms] SET [room_sequence]=13, [room_status]=N'OK', [status]=N'NA' WHERE [room_id]=N'SICKWAIT'
UPDATE [dbo].[o_Rooms] SET [room_name]=N'Physician Room', [room_sequence]=1, [room_type]=N'$EXAMINATION', [room_status]=N'OK' WHERE [room_id]=N'TRIAGE'
UPDATE [dbo].[o_Rooms] SET [room_sequence]=18, [room_status]=N'OK' WHERE [room_id]=N'TRIAGE_ES'
UPDATE [dbo].[o_Rooms] SET [room_sequence]=17 WHERE [room_id]=N'TRIAGE_SS'
UPDATE [dbo].[o_Rooms] SET [room_sequence]=12, [room_status]=N'OK', [status]=N'NA' WHERE [room_id]=N'WELLWAIT'
UPDATE [dbo].[c_Vaccine] SET [status]=N'OK' WHERE [vaccine_id]=N'BCGTB'
UPDATE [dbo].[c_Vaccine] SET [status]=N'OK' WHERE [vaccine_id]=N'DTPHIB'
UPDATE [dbo].[c_Vaccine] SET [status]=N'OK' WHERE [vaccine_id]=N'HibHibTITER)'
UPDATE [dbo].[c_Vaccine] SET [status]=N'OK' WHERE [vaccine_id]=N'HibProHIBit)'
UPDATE [dbo].[c_Vaccine] SET [status]=N'OK' WHERE [vaccine_id]=N'KEGI13677'
UPDATE [dbo].[c_Vaccine] SET [status]=N'OK' WHERE [vaccine_id]=N'KEGI6553'
UPDATE [dbo].[c_Vaccine] SET [status]=N'OK' WHERE [vaccine_id]=N'MEASLES'
UPDATE [dbo].[c_Vaccine] SET [status]=N'OK' WHERE [vaccine_id]=N'MUMPS'
UPDATE [dbo].[c_Vaccine] SET [status]=N'OK' WHERE [vaccine_id]=N'NOHIBTOOOLD'
UPDATE [dbo].[c_Vaccine] SET [status]=N'OK' WHERE [vaccine_id]=N'NOPREVNAOLD'
UPDATE [dbo].[c_Vaccine] SET [status]=N'OK' WHERE [vaccine_id]=N'NOVARHADDIS'
UPDATE [dbo].[c_Vaccine] SET [status]=N'OK' WHERE [vaccine_id]=N'Pnemococcus,Prevnar'
UPDATE [dbo].[c_Vaccine] SET [status]=N'OK' WHERE [vaccine_id]=N'RUBELLA'
UPDATE [dbo].[c_Vaccine] SET [status]=N'OK' WHERE [vaccine_id]=N'TETANUS'
UPDATE [dbo].[c_Assessment_Definition] SET [auto_close_interval_amount]=30 WHERE [assessment_id]=N'ALLERGY_PEN'
UPDATE [dbo].[c_Assessment_Definition] SET [assessment_category_id]=N'DA', [auto_close_interval_amount]=30, [last_updated]='20190405 11:24:35.903' WHERE [assessment_id]=N'ALLERGY_SHELLFISH'
UPDATE [dbo].[c_Assessment_Definition] SET [description]=N'Sulphur', [auto_close_interval_amount]=30 WHERE [assessment_id]=N'ALLERGY_SULFAS'
UPDATE [dbo].[c_Assessment_Definition] SET [auto_close_interval_amount]=30 WHERE [assessment_id]=N'DEMO10037'
UPDATE [dbo].[c_Assessment_Definition] SET [auto_close_interval_amount]=30 WHERE [assessment_id]=N'DEMO10045'
UPDATE [dbo].[c_Assessment_Definition] SET [auto_close_interval_amount]=30, [auto_close_interval_unit]=N'DAY' WHERE [assessment_id]=N'DEMO6763'
UPDATE [dbo].[c_Assessment_Definition] SET [auto_close]=N'N', [auto_close_interval_amount]=30, [auto_close_interval_unit]=N'DAY' WHERE [assessment_id]=N'ICD-H6533'
UPDATE [dbo].[c_Assessment_Definition] SET [auto_close]=N'N', [auto_close_interval_amount]=30, [auto_close_interval_unit]=N'DAY' WHERE [assessment_id]=N'ICD-J09X2'
UPDATE [dbo].[c_Menu_Item] SET [menu_item_type]=N'SERVICE', [menu_item]=N'CHART', [button_title]=N'View Chart', [button_help]=N'View Patient Chart', [button]=N'button17.bmp', [sort_sequence]=1, [id]=N'108bc82b-d727-4f88-82d7-40a372451450' WHERE [menu_id]=1000141 AND [menu_item_id]=1000774
UPDATE [dbo].[c_Menu_Item] SET [menu_item]=N'EXIT', [button_title]=N'Exit', [button_help]=N'Close Patient Encounter', [button]=N'button16.bmp', [sort_sequence]=10, [id]=N'3810604a-6beb-4b99-bdc4-1d8fa9bb4fbc' WHERE [menu_id]=1000141 AND [menu_item_id]=1000775
UPDATE [dbo].[c_Menu_Item] SET [menu_item_type]=N'MENU', [menu_item]=N'330', [button_title]=N'Pick H_and_P', [button_help]=N'SOAP Assessments Pick H and P Menu Peds', [button]=N'button_all_hxs.bmp', [sort_sequence]=8, [id]=N'ecebfd62-2289-45d7-84e8-fc221379ce38' WHERE [menu_id]=1000141 AND [menu_item_id]=1000776
UPDATE [dbo].[c_Menu_Item] SET [menu_item_type]=N'TREATMENT_LIST', [menu_item]=N'PICKLABS', [button_title]=N'Any Trtmt', [button_help]=NULL, [button]=N'button06.bmp', [sort_sequence]=7, [id]=N'c30320b8-3603-403d-91b5-d2b692d5b4be' WHERE [menu_id]=1000141 AND [menu_item_id]=1000777
UPDATE [dbo].[c_Menu_Item] SET [menu_item]=N'CHANGE_ROOM', [button_title]=N'Change Room', [button_help]=N'Move Patient to Another Room', [button]=N'buttonxf.bmp', [sort_sequence]=11, [id]=N'23b662b7-f385-4381-9032-b92ba766aced' WHERE [menu_id]=1000141 AND [menu_item_id]=1000778
UPDATE [dbo].[c_Menu_Item] SET [menu_item]=N'PATIENT_WORKPLAN', [button_title]=N'Encounter Workplans', [button_help]=N'Review Patient Workplans', [button]=N'button_workflow.bmp', [sort_sequence]=12, [id]=N'e6362e05-fc2b-45ee-80ae-afae4cb711b8' WHERE [menu_id]=1000141 AND [menu_item_id]=1000779
UPDATE [dbo].[c_Menu_Item] SET [menu_item]=N'PORTRAIT', [button_title]=N'Portrait', [button_help]=N'Import patient portrait', [button]=N'B_NEW20.bmp', [sort_sequence]=14, [id]=N'a80a6ddc-86f1-49ae-9290-4a3cfb1afdfe' WHERE [menu_id]=1000141 AND [menu_item_id]=1000780
UPDATE [dbo].[c_Menu_Item] SET [menu_item_type]=N'SERVICE', [menu_item]=N'SENDTODO', [button_title]=N'InOffice TASK', [button_help]=N'To Do Item', [button]=N'button_todo3.bmp', [sort_sequence]=21, [id]=N'c14f5d5d-ca80-41c2-a70d-14ebe562eb30' WHERE [menu_id]=1000141 AND [menu_item_id]=1000781
UPDATE [dbo].[c_Menu_Item] SET [menu_item_type]=N'SERVICE', [menu_item]=N'NULL_SERVICE', [button_title]=N'Take Over Encounter', [button_help]=NULL, [button]=N'button_approval.bmp', [sort_sequence]=27, [id]=N'8ad3f309-ad94-42dc-9370-de99cc5baa86' WHERE [menu_id]=1000141 AND [menu_item_id]=1000782
UPDATE [dbo].[c_Menu_Item] SET [sort_sequence]=20, [id]=N'a6f5495d-ac43-4143-8aff-73a9b5dccd47' WHERE [menu_id]=1000141 AND [menu_item_id]=1000783
UPDATE [dbo].[c_Menu_Item] SET [menu_item]=N'1000050', [button_title]=N'View Reports', [button_help]=N'View Reports Menu Peds', [button]=N'button_patient_report2.bmp', [sort_sequence]=15, [id]=N'050ba89e-ea73-4d0a-a048-2e086be49787' WHERE [menu_id]=1000141 AND [menu_item_id]=1000784
UPDATE [dbo].[c_Menu_Item] SET [menu_item_type]=N'MENU', [menu_item]=N'13', [button_title]=N'Review Menu', [button_help]=N'Review Menu Peds', [button]=N'button_prior_hx2.bmp', [sort_sequence]=9, [id]=N'af138f18-0907-4ca6-baec-12d543eea593' WHERE [menu_id]=1000141 AND [menu_item_id]=1000785
UPDATE [dbo].[c_Menu_Item] SET [menu_item_type]=N'MENU', [menu_item]=N'1000051', [button_title]=N'Print Reports', [button_help]=N'Print Reports Menu Peds', [button]=N'button_patient_report2.bmp', [sort_sequence]=16, [id]=N'81b3ddeb-d587-455a-8fd4-3c3ffb3c52c2' WHERE [menu_id]=1000141 AND [menu_item_id]=1000786
UPDATE [dbo].[c_Menu_Item] SET [menu_item]=N'SENDMESSAGE', [button_title]=N'InBox Message', [button_help]=N'Send Message', [button]=N'button_message.bmp', [sort_sequence]=19, [id]=N'a78a9f91-e15a-4e14-bb22-2baa9f874bbb' WHERE [menu_id]=1000141 AND [menu_item_id]=1000787
UPDATE [dbo].[c_Menu_Item] SET [menu_item]=N'BILLING', [button_title]=N'Billing', [button_help]=N'Billing', [button]=N'button_billing.bmp', [sort_sequence]=22, [id]=N'47ac0dbc-e70d-420e-87f1-8875eddbad84' WHERE [menu_id]=1000141 AND [menu_item_id]=1000788
UPDATE [dbo].[c_Menu_Item] SET [menu_item_type]=N'TREATMENT_TYPE', [menu_item]=N'LAB', [button_title]=N'Lab', [button_help]=N'Lab', [button]=N'button02.bmp', [sort_sequence]=6, [id]=N'bca68912-83f7-4ba3-8618-1d57f20e2b8f' WHERE [menu_id]=1000141 AND [menu_item_id]=1000789
UPDATE [dbo].[c_Menu_Item] SET [menu_item]=N'QUICKVIEWLABTEST', [button_title]=N'Quick Vw Lb/Tst/Pr', [button_help]=N'Quick Vw Labs/Tests', [button]=N'BUTTON23.bmp', [sort_sequence]=3, [id]=N'9f57ab8d-b1a5-4b0b-b244-ba7dae79063c' WHERE [menu_id]=1000141 AND [menu_item_id]=1000790
UPDATE [dbo].[c_Menu_Item] SET [menu_item_type]=N'SERVICE', [menu_item]=N'QUICKVIEWASSESS', [button_title]=N'Quick Vw DX/TX', [button_help]=N'Quick Vw DX/TX', [button]=N'BUTTON23.bmp', [sort_sequence]=4, [id]=N'26a1c505-21f8-4519-a4d4-525a23634eb0' WHERE [menu_id]=1000141 AND [menu_item_id]=1000791
UPDATE [dbo].[c_Menu_Item] SET [menu_item_type]=N'SERVICE', [menu_item]=N'QUICKVIEWRX', [button_title]=N'Manage Meds', [button_help]=N'Manage Meds', [button]=N'BUTTON23.bmp', [sort_sequence]=2, [id]=N'c4a3caf2-7003-4490-8173-8f3db49b776e' WHERE [menu_id]=1000141 AND [menu_item_id]=1000792
UPDATE [dbo].[c_Menu_Item] SET [menu_item]=N'EDIT_ENCOUNTER', [button_title]=N'Edit Encounter', [button_help]=N'Edit Encounter Information', [button]=N'button_edit2.bmp', [sort_sequence]=24, [id]=N'7391ba8e-4887-489d-b29e-8ae77844a523' WHERE [menu_id]=1000141 AND [menu_item_id]=1000793
UPDATE [dbo].[c_Menu_Item] SET [menu_item_type]=N'SERVICE', [menu_item]=N'PATIENT_WORKPLAN', [button_title]=N'F/U Workplans', [button_help]=N'Patient Workplans', [button]=N'button_workflow.bmp', [sort_sequence]=13, [id]=N'57d881b2-7811-4963-8c62-b935a52f915c' WHERE [menu_id]=1000141 AND [menu_item_id]=1000794
UPDATE [dbo].[c_Menu_Item] SET [menu_item]=N'ALERT', [button_title]=N'Alerts', [button_help]=N'Alerts', [button]=N'button_alert.bmp', [sort_sequence]=17, [id]=N'4a91dbcf-a3c0-45cd-b4da-e5944766c913' WHERE [menu_id]=1000141 AND [menu_item_id]=1000795
UPDATE [dbo].[c_Menu_Item] SET [menu_item_type]=N'SERVICE', [menu_item]=N'PATIENT_DATA', [button_title]=N'Edit Patient Data', [button_help]=N'Edit Patient Data', [button]=N'button_patient_information2.bmp', [sort_sequence]=18, [context_object]=N'Patient', [id]=N'8f16d169-83fc-4529-83bf-13ae43d72ef0' WHERE [menu_id]=1000141 AND [menu_item_id]=1000796
UPDATE [dbo].[c_Menu_Item] SET [menu_item]=N'REPORT', [button_title]=N'Lab PT Info', [button_help]=N'EPRO Report', [button]=N'button_patient_report2.bmp', [sort_sequence]=23, [context_object]=NULL, [id]=N'a3a7e703-e01d-4fbe-a4b5-b97c7fa1910d' WHERE [menu_id]=1000141 AND [menu_item_id]=1000797
UPDATE [dbo].[c_Menu_Item] SET [menu_item]=N'Cancel Encounter', [button_title]=N'Cancel Encounter', [button_help]=N'Cancel Encounter', [button]=N'button13.bmp', [context_object]=NULL, [id]=N'be932b73-4a94-4fcd-9a97-2389470098ec' WHERE [menu_id]=1000141 AND [menu_item_id]=1000798
UPDATE [dbo].[c_Procedure] SET [service]=NULL WHERE [procedure_id]=N'000120'
UPDATE [dbo].[c_Procedure] SET [charge]=6000.0000 WHERE [procedure_id]=N'90710'
UPDATE [dbo].[c_Procedure] SET [charge]=5000.0000 WHERE [procedure_id]=N'99211'
UPDATE [dbo].[c_Procedure] SET [status]=N'NA' WHERE [procedure_id]=N'99313'
UPDATE [dbo].[c_Procedure] SET [charge]=5544.0000, [well_encounter_flag]=N'A' WHERE [procedure_id]=N'DEMO1376'
UPDATE [dbo].[c_Procedure] SET [well_encounter_flag]=N'A' WHERE [procedure_id]=N'DEMO3860'
UPDATE [dbo].[c_Procedure] SET [well_encounter_flag]=N'A' WHERE [procedure_id]=N'DEMO5001'
UPDATE [dbo].[c_Procedure] SET [charge]=1000.0000, [well_encounter_flag]=N'A' WHERE [procedure_id]=N'DEMO676'
UPDATE [dbo].[c_Procedure] SET [vaccine_id]=NULL WHERE [procedure_id]=N'DEMO7065'
UPDATE [dbo].[c_Procedure] SET [service]=NULL WHERE [procedure_id]=N'DEMO8068'
UPDATE [dbo].[c_Procedure] SET [service]=NULL WHERE [procedure_id]=N'DEMO8069'
UPDATE [dbo].[c_Procedure] SET [service]=NULL WHERE [procedure_id]=N'DEMO8070'
UPDATE [dbo].[c_Procedure] SET [service]=NULL WHERE [procedure_id]=N'DEMO8071'
UPDATE [dbo].[c_Procedure] SET [service]=NULL WHERE [procedure_id]=N'DEMO8072'
UPDATE [dbo].[c_Procedure] SET [service]=NULL WHERE [procedure_id]=N'DEMO8073'
UPDATE [dbo].[c_Procedure] SET [service]=NULL WHERE [procedure_id]=N'DEMO8074'
UPDATE [dbo].[c_Procedure] SET [service]=NULL WHERE [procedure_id]=N'DEMO8075'
UPDATE [dbo].[c_Procedure] SET [service]=NULL WHERE [procedure_id]=N'DEMO8134'
UPDATE [dbo].[c_Procedure] SET [service]=NULL WHERE [procedure_id]=N'DEMO8135'
UPDATE [dbo].[c_Procedure] SET [service]=NULL WHERE [procedure_id]=N'DEMO8168'
UPDATE [dbo].[c_Procedure] SET [service]=NULL, [id]=N'310ac3d0-e616-498d-b692-dff365d514ae', [last_updated]='20211130 17:19:11.533' WHERE [procedure_id]=N'RABIESIMMUNEQUINE'
UPDATE [dbo].[c_Observation_Tree] SET [sort_sequence]=7, [last_updated]='20230505 15:03:08.803' WHERE [branch_id]=260
UPDATE [dbo].[c_Observation_Tree] SET [sort_sequence]=2, [last_updated]='20230505 15:03:08.800' WHERE [branch_id]=2996
UPDATE [dbo].[c_Observation_Tree] SET [sort_sequence]=6, [last_updated]='20230505 15:03:08.800' WHERE [branch_id]=2997
UPDATE [dbo].[c_Observation_Tree] SET [sort_sequence]=4, [last_updated]='20230505 15:03:08.800' WHERE [branch_id]=3003
UPDATE [dbo].[c_Observation_Tree] SET [edit_service]=N'HPI', [last_updated]='20210302 15:15:31.713' WHERE [branch_id]=3422
UPDATE [dbo].[c_Observation_Tree] SET [sort_sequence]=5, [last_updated]='20230714 18:31:35.817' WHERE [branch_id]=12820
UPDATE [dbo].[c_Observation_Tree] SET [sort_sequence]=1, [last_updated]='20230505 15:03:08.800' WHERE [branch_id]=14299
UPDATE [dbo].[c_Observation_Tree] SET [sort_sequence]=3, [last_updated]='20230504 19:39:46.337' WHERE [branch_id]=15916
UPDATE [dbo].[c_Observation_Tree] SET [sort_sequence]=5, [last_updated]='20230504 19:39:46.337' WHERE [branch_id]=15917
UPDATE [dbo].[c_Observation_Tree] SET [edit_service]=N'FREEHISTORY', [sort_sequence]=4, [last_updated]='20230505 14:07:11.243' WHERE [branch_id]=15960
UPDATE [dbo].[c_Observation_Tree] SET [sort_sequence]=6, [last_updated]='20230504 19:39:46.340' WHERE [branch_id]=16251
UPDATE [dbo].[c_Observation_Tree] SET [sort_sequence]=1, [last_updated]='20230504 19:39:46.337' WHERE [branch_id]=16252
UPDATE [dbo].[c_Observation_Tree] SET [sort_sequence]=8, [last_updated]='20230505 15:03:08.803' WHERE [branch_id]=16370
UPDATE [dbo].[c_Observation_Tree] SET [edit_service]=N'HPI', [last_updated]='20210302 15:18:42.157' WHERE [branch_id]=16505
UPDATE [dbo].[c_Observation_Tree] SET [edit_service]=N'HPI', [sort_sequence]=1, [last_updated]='20230505 15:09:03.280' WHERE [branch_id]=17633
UPDATE [dbo].[c_Observation_Tree] SET [edit_service]=N'HPI', [sort_sequence]=2, [last_updated]='20230505 15:09:03.280' WHERE [branch_id]=17635
UPDATE [dbo].[c_Observation_Tree] SET [sort_sequence]=3, [last_updated]='20230505 15:09:03.280' WHERE [branch_id]=17636
UPDATE [dbo].[c_Observation_Tree] SET [edit_service]=N'HPI', [sort_sequence]=4, [last_updated]='20230505 15:09:03.280' WHERE [branch_id]=17637
UPDATE [dbo].[c_Observation_Tree] SET [edit_service]=N'HPI', [sort_sequence]=5, [last_updated]='20230505 15:09:03.280' WHERE [branch_id]=17638
UPDATE [dbo].[c_Observation_Tree] SET [sort_sequence]=7, [last_updated]='20230505 15:09:03.283' WHERE [branch_id]=17640
UPDATE [dbo].[c_Observation_Tree] SET [sort_sequence]=6, [last_updated]='20230505 15:09:03.280' WHERE [branch_id]=17642
UPDATE [dbo].[c_Observation_Tree] SET [edit_service]=N'HPI', [last_updated]='20230505 14:59:54.813' WHERE [branch_id]=17645
UPDATE [dbo].[c_Observation_Tree] SET [edit_service]=N'HPI', [last_updated]='20230505 14:59:54.813' WHERE [branch_id]=17646
UPDATE [dbo].[c_Observation_Tree] SET [edit_service]=N'HPI', [sort_sequence]=1, [last_updated]='20230505 14:59:54.813' WHERE [branch_id]=17649
UPDATE [dbo].[c_Observation_Tree] SET [edit_service]=N'HPI', [followon_severity]=3, [followon_observation_id]=N'DEMO5794', [sort_sequence]=5, [last_updated]='20230505 14:59:54.817' WHERE [branch_id]=17650
UPDATE [dbo].[c_Observation_Tree] SET [edit_service]=N'HPI', [on_results_entered]=N'Next', [sort_sequence]=6, [last_updated]='20230505 14:59:54.817' WHERE [branch_id]=17652
UPDATE [dbo].[c_Observation_Tree] SET [on_results_entered]=N'Up', [sort_sequence]=7, [last_updated]='20230505 15:07:50.853' WHERE [branch_id]=17654
UPDATE [dbo].[c_Observation_Tree] SET [sort_sequence]=5, [last_updated]='20230505 15:03:08.800' WHERE [branch_id]=17657
UPDATE [dbo].[c_Observation_Tree] SET [sort_sequence]=2, [last_updated]='20230504 18:04:04.003' WHERE [branch_id]=18021
UPDATE [dbo].[c_Observation_Tree] SET [sort_sequence]=1, [last_updated]='20230504 18:04:04.000' WHERE [branch_id]=18023
UPDATE [dbo].[c_Observation_Tree] SET [sort_sequence]=9, [last_updated]='20230504 18:04:04.003' WHERE [branch_id]=18024
UPDATE [dbo].[c_Observation_Tree] SET [sort_sequence]=3, [last_updated]='20230714 18:31:35.813' WHERE [branch_id]=21079
UPDATE [dbo].[c_Observation_Tree] SET [sort_sequence]=7, [last_updated]='20230714 18:31:35.817' WHERE [branch_id]=21081
UPDATE [dbo].[c_Observation_Tree] SET [sort_sequence]=2, [last_updated]='20230714 18:31:35.813' WHERE [branch_id]=21082
UPDATE [dbo].[c_Observation_Tree] SET [sort_sequence]=6, [last_updated]='20230714 18:31:35.817' WHERE [branch_id]=21083
UPDATE [dbo].[c_Observation_Tree] SET [sort_sequence]=4, [last_updated]='20230714 18:31:35.817' WHERE [branch_id]=21103
UPDATE [dbo].[c_Observation_Tree] SET [sort_sequence]=7, [last_updated]='20230707 20:25:23.567' WHERE [branch_id]=23627
UPDATE [dbo].[c_Observation_Tree] SET [sort_sequence]=8, [last_updated]='20230707 20:25:23.567' WHERE [branch_id]=23628
UPDATE [dbo].[c_Observation_Tree] SET [sort_sequence]=10, [last_updated]='20230707 20:25:23.567' WHERE [branch_id]=23629
UPDATE [dbo].[c_Observation_Tree] SET [sort_sequence]=11, [last_updated]='20230707 20:25:23.567' WHERE [branch_id]=23630
UPDATE [dbo].[c_Observation_Tree] SET [sort_sequence]=14, [last_updated]='20230707 20:25:23.570' WHERE [branch_id]=23632
UPDATE [dbo].[c_Observation_Tree] SET [sort_sequence]=15, [last_updated]='20230707 20:25:23.570' WHERE [branch_id]=23633
UPDATE [dbo].[c_Observation_Tree] SET [sort_sequence]=16, [last_updated]='20230707 20:25:23.570' WHERE [branch_id]=23634
UPDATE [dbo].[c_Observation_Tree] SET [sort_sequence]=17, [last_updated]='20230707 20:25:23.570' WHERE [branch_id]=23635
UPDATE [dbo].[c_Observation_Tree] SET [sort_sequence]=18, [last_updated]='20230707 20:25:23.570' WHERE [branch_id]=23636
UPDATE [dbo].[c_Observation_Tree] SET [sort_sequence]=19, [last_updated]='20230707 20:25:23.570' WHERE [branch_id]=23637
UPDATE [dbo].[c_Observation_Tree] SET [sort_sequence]=13, [last_updated]='20230707 20:25:23.567' WHERE [branch_id]=23645
UPDATE [dbo].[c_Observation_Tree] SET [sort_sequence]=2, [last_updated]='20230623 09:51:17.607' WHERE [branch_id]=23951
UPDATE [dbo].[c_Observation_Tree] SET [sort_sequence]=3, [last_updated]='20230623 09:51:17.610' WHERE [branch_id]=23953
UPDATE [dbo].[c_Observation_Tree] SET [sort_sequence]=4, [last_updated]='20230623 09:51:17.613' WHERE [branch_id]=23955
UPDATE [dbo].[c_Observation_Tree] SET [sort_sequence]=6, [last_updated]='20230623 09:51:17.617' WHERE [branch_id]=23958
UPDATE [dbo].[c_Observation_Tree] SET [sort_sequence]=7, [last_updated]='20230623 09:51:17.620' WHERE [branch_id]=23959
UPDATE [dbo].[c_Observation_Tree] SET [sort_sequence]=8, [last_updated]='20230623 09:51:17.623' WHERE [branch_id]=23960
UPDATE [dbo].[c_Observation_Tree] SET [sort_sequence]=9, [last_updated]='20230623 09:51:17.627' WHERE [branch_id]=23961
UPDATE [dbo].[c_Observation_Tree] SET [sort_sequence]=10, [last_updated]='20230623 09:51:17.630' WHERE [branch_id]=23962
UPDATE [dbo].[c_Observation_Tree] SET [sort_sequence]=11, [last_updated]='20230623 09:51:17.630' WHERE [branch_id]=23963
UPDATE [dbo].[c_Observation_Tree] SET [sort_sequence]=12, [last_updated]='20230623 09:51:17.633' WHERE [branch_id]=23964
UPDATE [dbo].[c_Observation_Tree] SET [sort_sequence]=13, [last_updated]='20230623 09:51:17.633' WHERE [branch_id]=23965
UPDATE [dbo].[c_Observation_Tree] SET [sort_sequence]=1, [last_updated]='20230623 09:51:17.600' WHERE [branch_id]=23967
UPDATE [dbo].[c_Observation_Tree] SET [sort_sequence]=16, [last_updated]='20230623 09:51:17.640' WHERE [branch_id]=23968
UPDATE [dbo].[c_Observation_Tree] SET [sort_sequence]=18, [last_updated]='20230623 09:51:17.643' WHERE [branch_id]=23971
UPDATE [dbo].[c_Observation_Tree] SET [sort_sequence]=15, [last_updated]='20230623 09:51:17.640' WHERE [branch_id]=23974
UPDATE [dbo].[c_Observation_Tree] SET [sort_sequence]=19, [last_updated]='20230623 09:51:17.647' WHERE [branch_id]=23976
UPDATE [dbo].[c_Observation_Tree] SET [sort_sequence]=20, [last_updated]='20230623 09:51:17.647' WHERE [branch_id]=23978
UPDATE [dbo].[c_Observation_Tree] SET [sort_sequence]=22, [last_updated]='20230623 09:51:17.653' WHERE [branch_id]=23980
UPDATE [dbo].[c_Observation_Tree] SET [sort_sequence]=23, [last_updated]='20230623 09:51:17.653' WHERE [branch_id]=23981
UPDATE [dbo].[c_Observation_Tree] SET [sort_sequence]=24, [last_updated]='20230623 09:51:17.657' WHERE [branch_id]=23983
UPDATE [dbo].[c_Observation_Tree] SET [sort_sequence]=25, [last_updated]='20230623 09:51:17.660' WHERE [branch_id]=23984
UPDATE [dbo].[c_Observation_Tree] SET [sort_sequence]=14, [last_updated]='20230623 09:51:17.637' WHERE [branch_id]=23987
UPDATE [dbo].[c_Observation_Tree] SET [sort_sequence]=21, [last_updated]='20230623 09:51:17.650' WHERE [branch_id]=23989
UPDATE [dbo].[c_Observation_Tree] SET [sort_sequence]=26, [last_updated]='20230623 09:51:17.663' WHERE [branch_id]=23990
UPDATE [dbo].[c_Observation_Tree] SET [sort_sequence]=27, [last_updated]='20230623 09:51:17.667' WHERE [branch_id]=23991
UPDATE [dbo].[c_Observation_Tree] SET [sort_sequence]=32, [last_updated]='20230623 09:51:17.680' WHERE [branch_id]=23992
UPDATE [dbo].[c_Observation_Tree] SET [sort_sequence]=28, [last_updated]='20230623 09:51:17.670' WHERE [branch_id]=23993
UPDATE [dbo].[c_Observation_Tree] SET [sort_sequence]=29, [last_updated]='20230623 09:51:17.670' WHERE [branch_id]=23994
UPDATE [dbo].[c_Observation_Tree] SET [sort_sequence]=31, [last_updated]='20230623 09:51:17.677' WHERE [branch_id]=23995
UPDATE [dbo].[c_Observation_Tree] SET [sort_sequence]=5, [last_updated]='20230623 09:51:17.617' WHERE [branch_id]=23997
UPDATE [dbo].[c_Observation_Tree] SET [sort_sequence]=30, [last_updated]='20230623 09:51:17.673' WHERE [branch_id]=23999
UPDATE [dbo].[c_Observation_Tree] SET [sort_sequence]=33, [last_updated]='20230623 09:51:17.680' WHERE [branch_id]=24001
UPDATE [dbo].[c_Observation_Tree] SET [sort_sequence]=17, [last_updated]='20230623 09:51:17.640' WHERE [branch_id]=24008
UPDATE [dbo].[c_Observation_Tree] SET [edit_service]=NULL, [last_updated]='20230503 15:35:26.610' WHERE [branch_id]=38021
UPDATE [dbo].[c_Observation_Tree] SET [edit_service]=NULL, [last_updated]='20230503 15:35:26.610' WHERE [branch_id]=38022
UPDATE [dbo].[c_Observation_Tree] SET [edit_service]=N'HPI', [last_updated]='20230505 13:57:07.197' WHERE [branch_id]=38111
UPDATE [dbo].[c_Observation_Tree] SET [edit_service]=N'HPI', [on_results_entered]=N'None', [last_updated]='20230504 14:44:51.253' WHERE [branch_id]=38112
UPDATE [dbo].[c_Observation_Tree] SET [edit_service]=N'FREEHISTORY', [on_results_entered]=N'None', [last_updated]='20230504 13:38:49.807' WHERE [branch_id]=38116
UPDATE [dbo].[c_Observation_Tree] SET [observation_tag]=N'Arthur', [last_updated]='20210204 11:13:20.433' WHERE [branch_id]=38779
UPDATE [dbo].[c_Observation_Tree] SET [sort_sequence]=6, [last_updated]='20230714 21:29:44.937' WHERE [branch_id]=39126
UPDATE [dbo].[c_Observation_Tree] SET [sort_sequence]=7, [last_updated]='20230714 21:29:44.937' WHERE [branch_id]=39127
UPDATE [dbo].[c_Observation_Tree] SET [sort_sequence]=7, [last_updated]='20230504 16:42:37.740' WHERE [branch_id]=40691
UPDATE [dbo].[c_Observation_Tree] SET [sort_sequence]=8, [last_updated]='20230504 16:42:37.740' WHERE [branch_id]=40692
UPDATE [dbo].[c_Observation_Tree] SET [sort_sequence]=9, [last_updated]='20230504 16:42:37.740' WHERE [branch_id]=40693
UPDATE [dbo].[c_Observation_Tree] SET [sort_sequence]=11, [last_updated]='20230504 16:42:37.740' WHERE [branch_id]=40694
UPDATE [dbo].[c_Observation_Tree] SET [sort_sequence]=10, [last_updated]='20230504 16:42:37.740' WHERE [branch_id]=40695
UPDATE [dbo].[c_Observation_Tree] SET [sort_sequence]=13, [last_updated]='20230504 16:42:37.740' WHERE [branch_id]=40696
UPDATE [dbo].[c_Observation_Tree] SET [sort_sequence]=15, [last_updated]='20230504 16:42:37.740' WHERE [branch_id]=40697
UPDATE [dbo].[c_Observation_Tree] SET [sort_sequence]=6, [last_updated]='20230504 16:42:37.737' WHERE [branch_id]=40709
UPDATE [dbo].[c_Observation_Tree] SET [sort_sequence]=12, [last_updated]='20230504 16:42:37.740' WHERE [branch_id]=40710
UPDATE [dbo].[c_Observation_Tree] SET [sort_sequence]=14, [last_updated]='20230504 16:42:37.740' WHERE [branch_id]=40711
UPDATE [dbo].[c_Observation_Tree] SET [sort_sequence]=5, [last_updated]='20230504 16:42:37.737' WHERE [branch_id]=41593
UPDATE [dbo].[c_Observation_Tree] SET [sort_sequence]=4, [last_updated]='20040728 17:00:47.770' WHERE [branch_id]=44451
UPDATE [dbo].[c_Observation_Tree] SET [sort_sequence]=2, [last_updated]='20230707 23:52:36.620' WHERE [branch_id]=44489
UPDATE [dbo].[c_Observation_Tree] SET [sort_sequence]=9, [last_updated]='20230707 23:52:36.643' WHERE [branch_id]=44496
UPDATE [dbo].[c_Observation_Tree] SET [sort_sequence]=11, [last_updated]='20230707 23:52:36.643' WHERE [branch_id]=44498
UPDATE [dbo].[c_Observation_Tree] SET [sort_sequence]=1, [last_updated]='20230714 19:29:19.023' WHERE [branch_id]=44561
UPDATE [dbo].[c_Observation_Tree] SET [sort_sequence]=3, [last_updated]='20230707 23:52:36.633' WHERE [branch_id]=44969
UPDATE [dbo].[c_Observation_Tree] SET [sort_sequence]=3, [last_updated]='20230504 16:42:37.737' WHERE [branch_id]=45028
UPDATE [dbo].[c_Observation_Tree] SET [sort_sequence]=4, [last_updated]='20230504 16:42:37.737' WHERE [branch_id]=45029
UPDATE [dbo].[c_Observation_Tree] SET [edit_service]=NULL, [last_updated]='20230503 18:32:02.600' WHERE [branch_id]=47756
UPDATE [dbo].[c_Observation_Tree] SET [edit_service]=NULL, [last_updated]='20230503 18:32:02.600' WHERE [branch_id]=47757
UPDATE [dbo].[c_Observation_Tree] SET [observation_tag]=N'Nutribullet', [last_updated]='20210304 17:01:00.373' WHERE [branch_id]=49568
UPDATE [dbo].[c_Observation_Tree] SET [description]=N'Chief complaint:', [last_updated]='20230621 19:22:39.783' WHERE [branch_id]=49887
UPDATE [dbo].[c_Observation_Tree] SET [sort_sequence]=2, [last_updated]='20210726 20:13:14.170' WHERE [branch_id]=51165
UPDATE [dbo].[c_Observation_Tree] SET [sort_sequence]=3, [last_updated]='20210726 20:13:14.170' WHERE [branch_id]=51166
UPDATE [dbo].[c_Observation_Tree] SET [sort_sequence]=9, [last_updated]='20210726 20:13:14.173' WHERE [branch_id]=51168
UPDATE [dbo].[c_Observation_Tree] SET [sort_sequence]=10, [last_updated]='20210726 20:13:14.173' WHERE [branch_id]=51169
UPDATE [dbo].[c_Observation_Tree] SET [sort_sequence]=5, [last_updated]='20210726 20:13:14.170' WHERE [branch_id]=51170
UPDATE [dbo].[c_Observation_Tree] SET [sort_sequence]=6, [last_updated]='20210726 20:13:14.170' WHERE [branch_id]=51171
UPDATE [dbo].[c_Observation_Tree] SET [sort_sequence]=7, [last_updated]='20210726 20:13:14.173' WHERE [branch_id]=51172
UPDATE [dbo].[c_Observation_Tree] SET [sort_sequence]=11, [last_updated]='20210726 20:13:14.173' WHERE [branch_id]=51173
UPDATE [dbo].[c_Observation_Tree] SET [sort_sequence]=4, [last_updated]='20210726 20:13:14.170' WHERE [branch_id]=51175
UPDATE [dbo].[c_Observation_Tree] SET [sort_sequence]=8, [last_updated]='20210726 20:13:14.173' WHERE [branch_id]=51176
UPDATE [dbo].[c_Observation_Tree] SET [sort_sequence]=12, [last_updated]='20210726 20:13:14.173' WHERE [branch_id]=51318
UPDATE [dbo].[c_Observation_Tree] SET [sort_sequence]=15, [last_updated]='20230707 20:15:58.600' WHERE [branch_id]=51378
UPDATE [dbo].[o_Service] SET [default_expiration_time]=5, [default_expiration_unit_id]=N'Year' WHERE [service]=N'Cancel Encounter'
UPDATE [dbo].[o_Service] SET [secure_flag]=N'Y', [default_expiration_unit_id]=N'Year' WHERE [service]=N'CONFIG_ASSESSMENTS'
UPDATE [dbo].[o_Service] SET [secure_flag]=N'Y', [id]=N'118247c9-a83e-4d32-8583-9f7d104cc1a6', [last_updated]='20190405 11:21:07.473' WHERE [service]=N'Config_Country'
UPDATE [dbo].[o_Service] SET [secure_flag]=N'Y' WHERE [service]=N'CONFIG_DISPLAY_SCRIPT'
UPDATE [dbo].[o_Service] SET [secure_flag]=N'Y' WHERE [service]=N'CONFIG_DRUGS'
UPDATE [dbo].[o_Service] SET [secure_flag]=N'Y' WHERE [service]=N'CONFIG_MENUS'
UPDATE [dbo].[o_Service] SET [secure_flag]=N'Y' WHERE [service]=N'CONFIG_OBSERVATIONS'
UPDATE [dbo].[o_Service] SET [secure_flag]=N'Y' WHERE [service]=N'CONFIG_PRACTICEMGT'
UPDATE [dbo].[o_Service] SET [secure_flag]=N'Y' WHERE [service]=N'CONFIG_TREATMENT_TYPES'
UPDATE [dbo].[o_Service] SET [secure_flag]=N'Y' WHERE [service]=N'CONFIG_VACCINE_SCHEDULE'
UPDATE [dbo].[o_Service] SET [secure_flag]=N'Y' WHERE [service]=N'CONFIG_VACCINES_DISEASES'
UPDATE [dbo].[o_Service] SET [secure_flag]=N'Y' WHERE [service]=N'CONFIG_WORKPLANS'
UPDATE [dbo].[c_Encounter_Type] SET [status]=N'NA' WHERE [encounter_type]=N'!TODO'
UPDATE [dbo].[c_Encounter_Type] SET [status]=N'NA' WHERE [encounter_type]=N'`AllergyShots'
UPDATE [dbo].[c_Encounter_Type] SET [status]=N'NA' WHERE [encounter_type]=N'`CONSULT'
UPDATE [dbo].[c_Encounter_Type] SET [status]=N'NA' WHERE [encounter_type]=N'`CORRESP'
UPDATE [dbo].[c_Encounter_Type] SET [status]=N'NA' WHERE [encounter_type]=N'`HOSPGENR'
UPDATE [dbo].[c_Encounter_Type] SET [status]=N'NA' WHERE [encounter_type]=N'`LAB'
UPDATE [dbo].[c_Encounter_Type] SET [status]=N'NA' WHERE [encounter_type]=N'`LABG'
UPDATE [dbo].[c_Encounter_Type] SET [status]=N'NA' WHERE [encounter_type]=N'`MEDCONF'
UPDATE [dbo].[c_Encounter_Type] SET [status]=N'NA' WHERE [encounter_type]=N'`NEWBORN'
UPDATE [dbo].[c_Encounter_Type] SET [status]=N'NA' WHERE [encounter_type]=N'`NURSE'
UPDATE [dbo].[c_Encounter_Type] SET [status]=N'NA' WHERE [encounter_type]=N'`NURSEG'
UPDATE [dbo].[c_Encounter_Type] SET [status]=N'NA' WHERE [encounter_type]=N'`OFFSITE'
UPDATE [dbo].[c_Encounter_Type] SET [status]=N'NA' WHERE [encounter_type]=N'`PREOP'
UPDATE [dbo].[c_Encounter_Type] SET [status]=N'NA' WHERE [encounter_type]=N'`PROCEDURE'
UPDATE [dbo].[c_Encounter_Type] SET [status]=N'NA' WHERE [encounter_type]=N'`PROCEDUREG'
UPDATE [dbo].[c_Encounter_Type] SET [status]=N'NA' WHERE [encounter_type]=N'`REFERRALGEN'
UPDATE [dbo].[c_Encounter_Type] SET [status]=N'NA' WHERE [encounter_type]=N'`REVIEW'
UPDATE [dbo].[c_Encounter_Type] SET [status]=N'NA' WHERE [encounter_type]=N'`SICK'
UPDATE [dbo].[c_Encounter_Type] SET [status]=N'NA' WHERE [encounter_type]=N'`SICKLAB'
UPDATE [dbo].[c_Encounter_Type] SET [status]=N'NA' WHERE [encounter_type]=N'`SICKLABNEW'
UPDATE [dbo].[c_Encounter_Type] SET [status]=N'NA' WHERE [encounter_type]=N'`SICKLABR'
UPDATE [dbo].[c_Encounter_Type] SET [status]=N'NA' WHERE [encounter_type]=N'`SICKLABRNEW'
UPDATE [dbo].[c_Encounter_Type] SET [status]=N'NA' WHERE [encounter_type]=N'`SICKNEW'
UPDATE [dbo].[c_Encounter_Type] SET [status]=N'NA' WHERE [encounter_type]=N'`WELL'
UPDATE [dbo].[c_Encounter_Type] SET [status]=N'NA' WHERE [encounter_type]=N'`WELLNEW'
UPDATE [dbo].[c_Encounter_Type] SET [description]=N'ENT Consult Visit' WHERE [encounter_type]=N'ENTConsultVisit'
UPDATE [dbo].[c_Encounter_Type] SET [description]=N'ENT Initial Office Visit' WHERE [encounter_type]=N'ENTInitialOffice'
UPDATE [dbo].[c_Encounter_Type] SET [description]=N'ENT Office Visit' WHERE [encounter_type]=N'ENTOfficeVisit'
UPDATE [dbo].[c_Encounter_Type] SET [description]=N'ENT Procedure Return Patient', [status]=N'OK' WHERE [encounter_type]=N'ENTProcedure'
UPDATE [dbo].[c_Encounter_Type] SET [description]=N'ENT Procedure New Patient', [status]=N'OK' WHERE [encounter_type]=N'ENTProceduVisit'
UPDATE [dbo].[c_Encounter_Type] SET [description]=N'ENT Second Opinion Consultation', [status]=N'OK' WHERE [encounter_type]=N'ENTSecondOpinion'
UPDATE [dbo].[c_Encounter_Type] SET [status]=N'NA' WHERE [encounter_type]=N'ESTDEPOSITTION'
UPDATE [dbo].[c_Encounter_Type] SET [status]=N'NA' WHERE [encounter_type]=N'Initial Data Load'
UPDATE [dbo].[c_Encounter_Type] SET [status]=N'NA' WHERE [encounter_type]=N'NewEstPatientExpande'
UPDATE [dbo].[c_Encounter_Type] SET [status]=N'NA' WHERE [encounter_type]=N'NewESTPatientStepbyS'
UPDATE [dbo].[c_Encounter_Type] SET [status]=N'NA' WHERE [encounter_type]=N'NewESTPatientStepbyS1'
UPDATE [dbo].[c_Encounter_Type] SET [status]=N'NA' WHERE [encounter_type]=N'NOSHOW'
UPDATE [dbo].[c_Encounter_Type] SET [status]=N'NA' WHERE [encounter_type]=N'NOSHOWNB'
UPDATE [dbo].[c_Encounter_Type] SET [status]=N'NA' WHERE [encounter_type]=N'OfficeVisitEstabli'
UPDATE [dbo].[c_Encounter_Type] SET [status]=N'NA' WHERE [encounter_type]=N'OfficeVisitNew'
UPDATE [dbo].[c_Encounter_Type] SET [status]=N'NA' WHERE [encounter_type]=N'PHONE'
UPDATE [dbo].[c_Encounter_Type] SET [status]=N'NA' WHERE [encounter_type]=N'PHONE1'
UPDATE [dbo].[c_Encounter_Type] SET [status]=N'NA' WHERE [encounter_type]=N'PHONERXRefill'
UPDATE [dbo].[c_Encounter_Type] SET [status]=N'NA' WHERE [encounter_type]=N'PrintAllRecords'
UPDATE [dbo].[c_Encounter_Type] SET [status]=N'NA' WHERE [encounter_type]=N'ProviderInitiPhoneCall'
UPDATE [dbo].[c_Encounter_Type] SET [status]=N'NA' WHERE [encounter_type]=N'SalesEstPat'
UPDATE [dbo].[c_Encounter_Type] SET [status]=N'NA' WHERE [encounter_type]=N'SalesOfcVisit'
UPDATE [dbo].[c_Encounter_Type] SET [status]=N'NA' WHERE [encounter_type]=N'SICK'
UPDATE [dbo].[c_Encounter_Type] SET [status]=N'NA' WHERE [encounter_type]=N'Sportphysic'
UPDATE [dbo].[c_Encounter_Type] SET [status]=N'NA' WHERE [encounter_type]=N'VACCINE'
UPDATE [dbo].[c_Encounter_Type] SET [status]=N'NA' WHERE [encounter_type]=N'WellVisitEstabli'
UPDATE [dbo].[c_Encounter_Type] SET [status]=N'NA' WHERE [encounter_type]=N'WellVisitNew'
UPDATE [dbo].[c_Role] SET [color]=16091979 WHERE [role_id]=N'!AdminBill'
UPDATE [dbo].[c_Role] SET [color]=3014655 WHERE [role_id]=N'!CliniSupp'
UPDATE [dbo].[c_Role] SET [color]=16749202 WHERE [role_id]=N'!DRUGCONFIG'
UPDATE [dbo].[c_Role] SET [color]=7705297 WHERE [role_id]=N'!FRONTDESK'
UPDATE [dbo].[c_Role] SET [color]=16091979 WHERE [role_id]=N'!Manager'
UPDATE [dbo].[c_Role] SET [color]=3014655 WHERE [role_id]=N'!NURSE'
UPDATE [dbo].[c_Role] SET [color]=16749202 WHERE [role_id]=N'!PHARMACIST'
UPDATE [dbo].[c_Disease_Group] SET [sort_sequence]=1, [owner_id]=2209 WHERE [disease_group]=N'DTaP'
UPDATE [dbo].[c_Disease_Group] SET [owner_id]=2209 WHERE [disease_group]=N'HepA'
UPDATE [dbo].[c_Disease_Group] SET [sort_sequence]=2, [owner_id]=2209 WHERE [disease_group]=N'HepB'
UPDATE [dbo].[c_Disease_Group] SET [owner_id]=2209 WHERE [disease_group]=N'HIB'
UPDATE [dbo].[c_Disease_Group] SET [owner_id]=2209 WHERE [disease_group]=N'HPV'
UPDATE [dbo].[c_Disease_Group] SET [owner_id]=2209 WHERE [disease_group]=N'Influenza'
UPDATE [dbo].[c_Disease_Group] SET [owner_id]=2209 WHERE [disease_group]=N'Mening'
UPDATE [dbo].[c_Disease_Group] SET [owner_id]=2209 WHERE [disease_group]=N'MMR'
UPDATE [dbo].[c_Disease_Group] SET [owner_id]=2209 WHERE [disease_group]=N'Pneumococcal'
UPDATE [dbo].[c_Disease_Group] SET [owner_id]=2209 WHERE [disease_group]=N'Polio'
UPDATE [dbo].[c_Disease_Group] SET [sort_sequence]=3, [owner_id]=2209 WHERE [disease_group]=N'Rotavirus'
UPDATE [dbo].[c_Disease_Group] SET [owner_id]=2209 WHERE [disease_group]=N'TdaP'
UPDATE [dbo].[c_Disease_Group] SET [owner_id]=2209 WHERE [disease_group]=N'Varicella'
UPDATE [dbo].[c_Chart] SET [description]=N'Psychiatry Chart' WHERE [chart_id]=44
UPDATE [dbo].[c_Observation_Result] SET [status]=N'NA', [last_updated]='20210305 23:30:43.060' WHERE [observation_id]=N'0^21844' AND [result_sequence]=5
UPDATE [dbo].[c_Observation_Result] SET [print_result_flag]=N'N', [property_id]=0, [service]=N'', [unit_preference]=N'', [last_updated]='20210303 12:52:36.520' WHERE [observation_id]=N'0^22488' AND [result_sequence]=1
UPDATE [dbo].[c_Observation_Result] SET [status]=N'NA', [last_updated]='20230707 20:53:02.290' WHERE [observation_id]=N'0001276x' AND [result_sequence]=5
UPDATE [dbo].[c_Observation_Result] SET [status]=N'NA', [last_updated]='20230707 20:53:23.277' WHERE [observation_id]=N'0001277x' AND [result_sequence]=5
UPDATE [dbo].[c_Observation_Result] SET [status]=N'NA', [last_updated]='20230622 14:55:27.633' WHERE [observation_id]=N'0001284x' AND [result_sequence]=5
UPDATE [dbo].[c_Observation_Result] SET [sort_sequence]=7, [status]=N'NA', [last_updated]='20230705 15:26:37.603' WHERE [observation_id]=N'DEMO10269' AND [result_sequence]=2
UPDATE [dbo].[c_Observation_Result] SET [status]=N'NA', [last_updated]='20230704 20:14:27.720' WHERE [observation_id]=N'DEMO10269' AND [result_sequence]=3
UPDATE [dbo].[c_Observation_Result] SET [sort_sequence]=2, [last_updated]='20230705 15:29:55.413' WHERE [observation_id]=N'DEMO10269' AND [result_sequence]=4
UPDATE [dbo].[c_Observation_Result] SET [status]=N'NA', [last_updated]='20230704 20:14:20.280' WHERE [observation_id]=N'DEMO10269' AND [result_sequence]=5
UPDATE [dbo].[c_Observation_Result] SET [severity]=3, [sort_sequence]=10, [last_updated]='20230705 15:29:55.837' WHERE [observation_id]=N'DEMO10269' AND [result_sequence]=7
UPDATE [dbo].[c_Observation_Result] SET [result_unit]=NULL, [result_amount_flag]=N'N', [last_updated]='20230708 00:48:42.010' WHERE [observation_id]=N'DEMO10381' AND [result_sequence]=4
UPDATE [dbo].[c_Observation_Result] SET [result_unit]=NULL, [result_amount_flag]=N'N', [last_updated]='20230708 00:48:20.800' WHERE [observation_id]=N'DEMO10381' AND [result_sequence]=5
UPDATE [dbo].[c_Observation_Result] SET [result_unit]=NULL, [result_amount_flag]=N'N', [last_updated]='20230708 00:47:57.500' WHERE [observation_id]=N'DEMO10381' AND [result_sequence]=6
UPDATE [dbo].[c_Observation_Result] SET [result_unit]=NULL, [result_amount_flag]=N'N', [last_updated]='20230708 00:48:29.050' WHERE [observation_id]=N'DEMO10381' AND [result_sequence]=7
UPDATE [dbo].[c_Observation_Result] SET [result_unit]=NULL, [result_amount_flag]=N'N', [last_updated]='20230708 00:48:01.803' WHERE [observation_id]=N'DEMO10381' AND [result_sequence]=8
UPDATE [dbo].[c_Observation_Result] SET [result_unit]=NULL, [result_amount_flag]=N'N', [last_updated]='20230708 00:48:32.250' WHERE [observation_id]=N'DEMO10381' AND [result_sequence]=9
UPDATE [dbo].[c_Observation_Result] SET [result_unit]=NULL, [result_amount_flag]=N'N', [last_updated]='20230708 00:48:06.007' WHERE [observation_id]=N'DEMO10381' AND [result_sequence]=10
UPDATE [dbo].[c_Observation_Result] SET [result_unit]=NULL, [result_amount_flag]=N'N', [last_updated]='20230708 00:48:35.670' WHERE [observation_id]=N'DEMO10381' AND [result_sequence]=11
UPDATE [dbo].[c_Observation_Result] SET [result_unit]=NULL, [result_amount_flag]=N'N', [last_updated]='20230708 00:48:09.867' WHERE [observation_id]=N'DEMO10381' AND [result_sequence]=12
UPDATE [dbo].[c_Observation_Result] SET [result_unit]=NULL, [result_amount_flag]=N'N', [last_updated]='20230708 00:48:39.077' WHERE [observation_id]=N'DEMO10381' AND [result_sequence]=13
UPDATE [dbo].[c_Observation_Result] SET [sort_sequence]=13, [last_updated]='20230708 00:51:25.450' WHERE [observation_id]=N'DEMO10382' AND [result_sequence]=2
UPDATE [dbo].[c_Observation_Result] SET [result_unit]=NULL, [result_amount_flag]=N'N', [sort_sequence]=4, [last_updated]='20230708 00:51:40.770' WHERE [observation_id]=N'DEMO10382' AND [result_sequence]=4
UPDATE [dbo].[c_Observation_Result] SET [result_unit]=NULL, [result_amount_flag]=N'N', [sort_sequence]=6, [last_updated]='20230708 00:51:50.313' WHERE [observation_id]=N'DEMO10382' AND [result_sequence]=5
UPDATE [dbo].[c_Observation_Result] SET [result_unit]=NULL, [result_amount_flag]=N'N', [sort_sequence]=8, [last_updated]='20230708 00:51:57.473' WHERE [observation_id]=N'DEMO10382' AND [result_sequence]=6
UPDATE [dbo].[c_Observation_Result] SET [result_unit]=NULL, [result_amount_flag]=N'N', [sort_sequence]=7, [last_updated]='20230708 00:51:54.017' WHERE [observation_id]=N'DEMO10382' AND [result_sequence]=7
UPDATE [dbo].[c_Observation_Result] SET [result_unit]=NULL, [result_amount_flag]=N'N', [sort_sequence]=12, [last_updated]='20230708 00:51:28.460' WHERE [observation_id]=N'DEMO10382' AND [result_sequence]=8
UPDATE [dbo].[c_Observation_Result] SET [result_unit]=NULL, [result_amount_flag]=N'N', [sort_sequence]=11, [last_updated]='20230708 00:52:15.230' WHERE [observation_id]=N'DEMO10382' AND [result_sequence]=9
UPDATE [dbo].[c_Observation_Result] SET [result_unit]=NULL, [result_amount_flag]=N'N', [sort_sequence]=2, [last_updated]='20230708 00:51:32.853' WHERE [observation_id]=N'DEMO10382' AND [result_sequence]=10
UPDATE [dbo].[c_Observation_Result] SET [result_unit]=NULL, [result_amount_flag]=N'N', [sort_sequence]=9, [last_updated]='20230708 00:52:04.110' WHERE [observation_id]=N'DEMO10382' AND [result_sequence]=11
UPDATE [dbo].[c_Observation_Result] SET [result_unit]=NULL, [result_amount_flag]=N'N', [sort_sequence]=3, [last_updated]='20230708 00:51:36.847' WHERE [observation_id]=N'DEMO10382' AND [result_sequence]=12
UPDATE [dbo].[c_Observation_Result] SET [result_unit]=NULL, [result_amount_flag]=N'N', [sort_sequence]=10, [last_updated]='20230708 00:52:08.347' WHERE [observation_id]=N'DEMO10382' AND [result_sequence]=13
UPDATE [dbo].[c_Observation_Result] SET [result_unit]=NULL, [result_amount_flag]=N'N', [sort_sequence]=5, [last_updated]='20230708 00:51:45.017' WHERE [observation_id]=N'DEMO10382' AND [result_sequence]=14
UPDATE [dbo].[c_Observation_Result] SET [sort_sequence]=1, [last_updated]='20230708 00:51:25.133' WHERE [observation_id]=N'DEMO10382' AND [result_sequence]=15
UPDATE [dbo].[c_Observation_Result] SET [result_unit]=NULL, [result_amount_flag]=N'N', [last_updated]='20230708 00:49:33.920' WHERE [observation_id]=N'DEMO10383' AND [result_sequence]=5
UPDATE [dbo].[c_Observation_Result] SET [result_unit]=NULL, [result_amount_flag]=N'N', [last_updated]='20230708 00:49:08.180' WHERE [observation_id]=N'DEMO10383' AND [result_sequence]=7
UPDATE [dbo].[c_Observation_Result] SET [result_unit]=NULL, [result_amount_flag]=N'N', [last_updated]='20230708 00:49:37.440' WHERE [observation_id]=N'DEMO10383' AND [result_sequence]=8
UPDATE [dbo].[c_Observation_Result] SET [result_unit]=NULL, [result_amount_flag]=N'N', [last_updated]='20230708 00:49:44.437' WHERE [observation_id]=N'DEMO10383' AND [result_sequence]=9
UPDATE [dbo].[c_Observation_Result] SET [result_unit]=NULL, [result_amount_flag]=N'N', [last_updated]='20230708 00:49:40.950' WHERE [observation_id]=N'DEMO10383' AND [result_sequence]=10
UPDATE [dbo].[c_Observation_Result] SET [result_unit]=NULL, [result_amount_flag]=N'N', [last_updated]='20230708 00:49:26.800' WHERE [observation_id]=N'DEMO10383' AND [result_sequence]=11
UPDATE [dbo].[c_Observation_Result] SET [result_unit]=NULL, [result_amount_flag]=N'N', [last_updated]='20230708 00:49:12.960' WHERE [observation_id]=N'DEMO10383' AND [result_sequence]=12
UPDATE [dbo].[c_Observation_Result] SET [result_unit]=NULL, [result_amount_flag]=N'N', [last_updated]='20230708 00:49:23.253' WHERE [observation_id]=N'DEMO10383' AND [result_sequence]=13
UPDATE [dbo].[c_Observation_Result] SET [result_unit]=NULL, [result_amount_flag]=N'N', [last_updated]='20230708 00:49:16.617' WHERE [observation_id]=N'DEMO10383' AND [result_sequence]=14
UPDATE [dbo].[c_Observation_Result] SET [result_unit]=NULL, [result_amount_flag]=N'N', [last_updated]='20230708 00:49:20.020' WHERE [observation_id]=N'DEMO10383' AND [result_sequence]=15
UPDATE [dbo].[c_Observation_Result] SET [result_unit]=NULL, [result_amount_flag]=N'N', [last_updated]='20230708 00:49:29.923' WHERE [observation_id]=N'DEMO10383' AND [result_sequence]=16
UPDATE [dbo].[c_Observation_Result] SET [sort_sequence]=15, [last_updated]='20230708 00:53:39.143' WHERE [observation_id]=N'DEMO10403' AND [result_sequence]=2
UPDATE [dbo].[c_Observation_Result] SET [result_unit]=NULL, [result_amount_flag]=N'N', [last_updated]='20230708 00:54:26.057' WHERE [observation_id]=N'DEMO10403' AND [result_sequence]=4
UPDATE [dbo].[c_Observation_Result] SET [result_unit]=NULL, [result_amount_flag]=N'N', [sort_sequence]=4, [last_updated]='20230708 00:53:57.993' WHERE [observation_id]=N'DEMO10403' AND [result_sequence]=5
UPDATE [dbo].[c_Observation_Result] SET [result_unit]=NULL, [result_amount_flag]=N'N', [sort_sequence]=2, [last_updated]='20230708 00:53:49.240' WHERE [observation_id]=N'DEMO10403' AND [result_sequence]=6
UPDATE [dbo].[c_Observation_Result] SET [result_unit]=NULL, [result_amount_flag]=N'N', [sort_sequence]=6, [last_updated]='20230708 00:54:04.330' WHERE [observation_id]=N'DEMO10403' AND [result_sequence]=7
UPDATE [dbo].[c_Observation_Result] SET [result_unit]=NULL, [result_amount_flag]=N'N', [sort_sequence]=8, [last_updated]='20230708 00:54:11.653' WHERE [observation_id]=N'DEMO10403' AND [result_sequence]=8
UPDATE [dbo].[c_Observation_Result] SET [result_unit]=NULL, [result_amount_flag]=N'N', [last_updated]='20230708 00:54:30.230' WHERE [observation_id]=N'DEMO10403' AND [result_sequence]=9
UPDATE [dbo].[c_Observation_Result] SET [result_unit]=NULL, [result_amount_flag]=N'N', [sort_sequence]=9, [last_updated]='20230708 00:54:15.153' WHERE [observation_id]=N'DEMO10403' AND [result_sequence]=10
UPDATE [dbo].[c_Observation_Result] SET [result_unit]=NULL, [result_amount_flag]=N'N', [last_updated]='20230708 00:54:22.100' WHERE [observation_id]=N'DEMO10403' AND [result_sequence]=11
UPDATE [dbo].[c_Observation_Result] SET [result_unit]=NULL, [result_amount_flag]=N'N', [sort_sequence]=10, [last_updated]='20230708 00:54:18.857' WHERE [observation_id]=N'DEMO10403' AND [result_sequence]=12
UPDATE [dbo].[c_Observation_Result] SET [result_unit]=NULL, [result_amount_flag]=N'N', [sort_sequence]=3, [last_updated]='20230708 00:53:52.660' WHERE [observation_id]=N'DEMO10403' AND [result_sequence]=13
UPDATE [dbo].[c_Observation_Result] SET [result_unit]=NULL, [result_amount_flag]=N'N', [sort_sequence]=7, [last_updated]='20230708 00:54:07.873' WHERE [observation_id]=N'DEMO10403' AND [result_sequence]=15
UPDATE [dbo].[c_Observation_Result] SET [result_unit]=NULL, [result_amount_flag]=N'N', [sort_sequence]=5, [last_updated]='20230708 00:54:01.090' WHERE [observation_id]=N'DEMO10403' AND [result_sequence]=16
UPDATE [dbo].[c_Observation_Result] SET [result_unit]=NULL, [result_amount_flag]=N'N', [sort_sequence]=14, [last_updated]='20230708 00:54:34.320' WHERE [observation_id]=N'DEMO10403' AND [result_sequence]=17
UPDATE [dbo].[c_Observation_Result] SET [status]=N'NA', [last_updated]='20230714 19:34:18.907' WHERE [observation_id]=N'DEMO11650' AND [result_sequence]=4
UPDATE [dbo].[c_Observation_Result] SET [status]=N'NA', [last_updated]='20230714 15:47:42.463' WHERE [observation_id]=N'DEMO11654' AND [result_sequence]=6
UPDATE [dbo].[c_Observation_Result] SET [status]=N'NA', [last_updated]='20230714 15:47:16.080' WHERE [observation_id]=N'DEMO11655' AND [result_sequence]=7
UPDATE [dbo].[c_Observation_Result] SET [status]=N'NA', [last_updated]='20230707 20:37:14.870' WHERE [observation_id]=N'DEMO11837' AND [result_sequence]=5
UPDATE [dbo].[c_Observation_Result] SET [status]=N'NA', [last_updated]='20230621 20:04:26.443' WHERE [observation_id]=N'DEMO11905' AND [result_sequence]=5
UPDATE [dbo].[c_Observation_Result] SET [status]=N'NA', [last_updated]='20230621 20:04:52.537' WHERE [observation_id]=N'DEMO11906' AND [result_sequence]=5
UPDATE [dbo].[c_Observation_Result] SET [status]=N'NA', [last_updated]='20230621 20:05:21.530' WHERE [observation_id]=N'DEMO11907' AND [result_sequence]=5
UPDATE [dbo].[c_Observation_Result] SET [status]=N'NA', [last_updated]='20230621 20:05:46.660' WHERE [observation_id]=N'DEMO11908' AND [result_sequence]=5
UPDATE [dbo].[c_Observation_Result] SET [status]=N'NA', [last_updated]='20230621 20:08:05.650' WHERE [observation_id]=N'DEMO11910' AND [result_sequence]=5
UPDATE [dbo].[c_Observation_Result] SET [status]=N'NA', [last_updated]='20230621 20:08:31.283' WHERE [observation_id]=N'DEMO11911' AND [result_sequence]=5
UPDATE [dbo].[c_Observation_Result] SET [status]=N'NA', [last_updated]='20230621 20:09:22.680' WHERE [observation_id]=N'DEMO11912' AND [result_sequence]=5
UPDATE [dbo].[c_Observation_Result] SET [status]=N'NA', [last_updated]='20230621 20:09:56.900' WHERE [observation_id]=N'DEMO11913' AND [result_sequence]=5
UPDATE [dbo].[c_Observation_Result] SET [status]=N'NA', [last_updated]='20230621 20:10:20.470' WHERE [observation_id]=N'DEMO11914' AND [result_sequence]=5
UPDATE [dbo].[c_Observation_Result] SET [status]=N'NA', [last_updated]='20230621 20:10:46.353' WHERE [observation_id]=N'DEMO11915' AND [result_sequence]=5
UPDATE [dbo].[c_Observation_Result] SET [sort_sequence]=3, [last_updated]='20230505 13:36:29.030' WHERE [observation_id]=N'DEMO14504' AND [result_sequence]=2
UPDATE [dbo].[c_Observation_Result] SET [sort_sequence]=2, [status]=N'NA', [last_updated]='20230421 20:26:43.057' WHERE [observation_id]=N'DEMO17288' AND [result_sequence]=3
UPDATE [dbo].[c_Observation_Result] SET [sort_sequence]=3, [last_updated]='20230421 20:26:26.033' WHERE [observation_id]=N'DEMO17288' AND [result_sequence]=4
UPDATE [dbo].[c_Observation_Result] SET [sort_sequence]=2, [status]=N'NA', [last_updated]='20230421 20:22:01.740' WHERE [observation_id]=N'DEMO17339' AND [result_sequence]=3
UPDATE [dbo].[c_Observation_Result] SET [status]=N'NA', [last_updated]='20230714 15:48:16.980' WHERE [observation_id]=N'DEMO18306' AND [result_sequence]=10
UPDATE [dbo].[c_Observation_Result] SET [status]=N'NA', [last_updated]='20230714 15:49:08.497' WHERE [observation_id]=N'DEMO18308' AND [result_sequence]=10
UPDATE [dbo].[c_Observation_Result] SET [severity]=0, [abnormal_flag]=N'N', [property_id]=0, [service]=N'', [unit_preference]=N'', [status]=N'OK', [last_updated]='20230714 19:29:19.077' WHERE [observation_id]=N'DEMO18335' AND [result_sequence]=7
UPDATE [dbo].[c_Observation_Result] SET [property_id]=0, [service]=N'', [unit_preference]=N'', [status]=N'OK', [last_updated]='20230714 19:29:12.250' WHERE [observation_id]=N'DEMO18335' AND [result_sequence]=8
UPDATE [dbo].[c_Observation_Result] SET [status]=N'NA', [last_updated]='20230714 15:51:19.357' WHERE [observation_id]=N'DEMO18379' AND [result_sequence]=7
UPDATE [dbo].[c_Observation_Result] SET [status]=N'NA', [last_updated]='20230714 15:48:42.357' WHERE [observation_id]=N'DEMO18379' AND [result_sequence]=11
UPDATE [dbo].[c_Observation_Result] SET [status]=N'NA', [last_updated]='20230714 19:28:12.100' WHERE [observation_id]=N'DEMO18411' AND [result_sequence]=6
UPDATE [dbo].[c_Observation_Result] SET [status]=N'NA', [last_updated]='20230714 15:49:46.763' WHERE [observation_id]=N'DEMO18438' AND [result_sequence]=6
UPDATE [dbo].[c_Observation_Result] SET [status]=N'NA', [last_updated]='20230714 15:50:10.797' WHERE [observation_id]=N'DEMO18450' AND [result_sequence]=6
UPDATE [dbo].[c_Observation_Result] SET [status]=N'NA', [last_updated]='20230504 16:56:55.080' WHERE [observation_id]=N'DEMO18722' AND [result_sequence]=3
UPDATE [dbo].[c_Observation_Result] SET [status]=N'NA', [last_updated]='20230504 16:56:58.300' WHERE [observation_id]=N'DEMO18722' AND [result_sequence]=4
UPDATE [dbo].[c_Observation_Result] SET [status]=N'NA', [last_updated]='20230504 16:57:01.027' WHERE [observation_id]=N'DEMO18722' AND [result_sequence]=5
UPDATE [dbo].[c_Observation_Result] SET [status]=N'NA', [last_updated]='20230620 11:31:02.027' WHERE [observation_id]=N'DEMO21043' AND [result_sequence]=4
UPDATE [dbo].[c_Observation_Result] SET [sort_sequence]=9, [last_updated]='20230505 13:57:33.323' WHERE [observation_id]=N'DEMO3638' AND [result_sequence]=13
UPDATE [dbo].[c_Observation_Result] SET [sort_sequence]=7, [last_updated]='20230505 13:57:33.263' WHERE [observation_id]=N'DEMO3638' AND [result_sequence]=24
UPDATE [dbo].[c_Observation_Result] SET [sort_sequence]=4, [last_updated]='20230505 13:57:32.807' WHERE [observation_id]=N'DEMO3638' AND [result_sequence]=25
UPDATE [dbo].[c_Observation_Result] SET [sort_sequence]=5, [last_updated]='20230505 13:57:33.203' WHERE [observation_id]=N'DEMO3638' AND [result_sequence]=26
UPDATE [dbo].[c_Observation_Result] SET [sort_sequence]=6, [last_updated]='20230505 13:57:33.233' WHERE [observation_id]=N'DEMO3638' AND [result_sequence]=27
UPDATE [dbo].[c_Observation_Result] SET [sort_sequence]=2, [last_updated]='20230505 13:57:32.747' WHERE [observation_id]=N'DEMO3638' AND [result_sequence]=32
UPDATE [dbo].[c_Observation_Result] SET [sort_sequence]=3, [last_updated]='20230505 13:57:32.777' WHERE [observation_id]=N'DEMO3638' AND [result_sequence]=33
UPDATE [dbo].[c_Observation_Result] SET [sort_sequence]=2, [last_updated]='20230707 20:34:39.353' WHERE [observation_id]=N'DEMO3717' AND [result_sequence]=2
UPDATE [dbo].[c_Observation_Result] SET [sort_sequence]=1, [last_updated]='20230707 20:34:39.317' WHERE [observation_id]=N'DEMO3717' AND [result_sequence]=3
UPDATE [dbo].[c_Observation_Result] SET [sort_sequence]=1, [last_updated]='20210305 22:52:32.387' WHERE [observation_id]=N'DEMO3718' AND [result_sequence]=3
UPDATE [dbo].[c_Observation_Result] SET [service]=N'', [unit_preference]=N'', [sort_sequence]=1, [status]=N'NA', [last_updated]='20230707 20:31:59.313' WHERE [observation_id]=N'DEMO3718' AND [result_sequence]=8
UPDATE [dbo].[c_Observation_Result] SET [sort_sequence]=2, [last_updated]='20210305 22:02:11.443' WHERE [observation_id]=N'DEMO3719' AND [result_sequence]=2
UPDATE [dbo].[c_Observation_Result] SET [sort_sequence]=1, [last_updated]='20210305 22:02:11.410' WHERE [observation_id]=N'DEMO3719' AND [result_sequence]=3
UPDATE [dbo].[c_Observation_Result] SET [sort_sequence]=1, [last_updated]='20230707 20:34:58.937' WHERE [observation_id]=N'DEMO3721' AND [result_sequence]=3
UPDATE [dbo].[c_Observation_Result] SET [status]=N'NA', [last_updated]='20230707 20:33:18.440' WHERE [observation_id]=N'DEMO3721' AND [result_sequence]=8
UPDATE [dbo].[c_Observation_Result] SET [status]=N'NA', [last_updated]='20230621 20:06:11.313' WHERE [observation_id]=N'DEMO3847' AND [result_sequence]=4
UPDATE [dbo].[c_Observation_Result] SET [sort_sequence]=2, [last_updated]='20210305 22:15:42.853' WHERE [observation_id]=N'DEMO3849' AND [result_sequence]=6
UPDATE [dbo].[c_Observation_Result] SET [sort_sequence]=1, [last_updated]='20210305 22:01:42.480' WHERE [observation_id]=N'DEMO3849' AND [result_sequence]=7
UPDATE [dbo].[c_Observation_Result] SET [service]=N'', [unit_preference]=N'', [last_updated]='20210302 14:46:34.873' WHERE [observation_id]=N'DEMO3849' AND [result_sequence]=9
UPDATE [dbo].[c_Observation_Result] SET [result_amount_flag]=N'N', [sort_sequence]=2, [last_updated]='20230708 00:44:44.930' WHERE [observation_id]=N'DEMO3963' AND [result_sequence]=2
UPDATE [dbo].[c_Observation_Result] SET [sort_sequence]=1, [last_updated]='20230708 00:44:26.893' WHERE [observation_id]=N'DEMO3963' AND [result_sequence]=3
UPDATE [dbo].[c_Observation_Result] SET [result_amount_flag]=N'N', [sort_sequence]=2, [last_updated]='20210305 22:16:12.213' WHERE [observation_id]=N'DEMO4017' AND [result_sequence]=8
UPDATE [dbo].[c_Observation_Result] SET [status]=N'NA', [last_updated]='20230704 20:12:49.187' WHERE [observation_id]=N'DEMO7359' AND [result_sequence]=3
UPDATE [dbo].[c_Observation_Result] SET [status]=N'NA', [last_updated]='20230714 19:32:31.543' WHERE [observation_id]=N'DEMO7375' AND [result_sequence]=5
UPDATE [dbo].[c_Observation_Result] SET [sort_sequence]=6, [last_updated]='20230505 14:02:02.067' WHERE [observation_id]=N'DEMO9363' AND [result_sequence]=3
UPDATE [dbo].[c_Observation_Result] SET [sort_sequence]=2, [last_updated]='20230505 14:02:01.940' WHERE [observation_id]=N'DEMO9363' AND [result_sequence]=4
UPDATE [dbo].[c_Observation_Result] SET [sort_sequence]=1, [last_updated]='20230505 14:02:01.900' WHERE [observation_id]=N'DEMO9363' AND [result_sequence]=5
UPDATE [dbo].[c_Observation_Result] SET [sort_sequence]=3, [last_updated]='20230505 14:02:01.973' WHERE [observation_id]=N'DEMO9363' AND [result_sequence]=6
UPDATE [dbo].[c_Observation_Result] SET [sort_sequence]=4, [last_updated]='20230505 14:02:02.007' WHERE [observation_id]=N'DEMO9363' AND [result_sequence]=7
UPDATE [dbo].[c_Observation_Result] SET [sort_sequence]=5, [last_updated]='20230505 14:02:02.033' WHERE [observation_id]=N'DEMO9363' AND [result_sequence]=8
UPDATE [dbo].[c_Observation_Result] SET [sort_sequence]=5, [last_updated]='20230505 13:45:14.003' WHERE [observation_id]=N'DEMO9364' AND [result_sequence]=3
UPDATE [dbo].[c_Observation_Result] SET [severity]=0, [abnormal_flag]=N'N', [sort_sequence]=2, [last_updated]='20230505 14:01:16.923' WHERE [observation_id]=N'DEMO9366' AND [result_sequence]=2
UPDATE [dbo].[c_Observation_Result] SET [severity]=0, [abnormal_flag]=N'N', [sort_sequence]=1, [last_updated]='20230505 14:01:16.890' WHERE [observation_id]=N'DEMO9366' AND [result_sequence]=3
UPDATE [dbo].[c_Observation_Result] SET [severity]=0, [abnormal_flag]=N'N', [last_updated]='20230505 14:01:16.953' WHERE [observation_id]=N'DEMO9366' AND [result_sequence]=4
UPDATE [dbo].[c_Observation_Result] SET [sort_sequence]=4, [last_updated]='20230505 14:11:09.900' WHERE [observation_id]=N'DEMO9368' AND [result_sequence]=3
UPDATE [dbo].[c_Observation_Result] SET [sort_sequence]=5, [last_updated]='20230505 13:49:10.243' WHERE [observation_id]=N'DEMO9370' AND [result_sequence]=5
UPDATE [dbo].[c_Observation_Result] SET [severity]=3, [abnormal_flag]=N'Y', [last_updated]='20230504 20:08:26.350' WHERE [observation_id]=N'DEMO951' AND [result_sequence]=2
UPDATE [dbo].[c_Observation_Result] SET [severity]=3, [abnormal_flag]=N'Y', [sort_sequence]=2, [last_updated]='20230504 20:07:40.820' WHERE [observation_id]=N'DEMO951' AND [result_sequence]=3
UPDATE [dbo].[c_Observation_Result] SET [severity]=3, [abnormal_flag]=N'Y', [sort_sequence]=12, [last_updated]='20230504 20:08:36.090' WHERE [observation_id]=N'DEMO951' AND [result_sequence]=5
UPDATE [dbo].[c_Observation_Result] SET [severity]=3, [abnormal_flag]=N'Y', [sort_sequence]=11, [last_updated]='20230504 20:08:31.560' WHERE [observation_id]=N'DEMO951' AND [result_sequence]=6
UPDATE [dbo].[c_Observation_Result] SET [result_unit]=NULL, [result_amount_flag]=N'N', [severity]=3, [abnormal_flag]=N'Y', [sort_sequence]=8, [last_updated]='20230504 20:08:03.223' WHERE [observation_id]=N'DEMO951' AND [result_sequence]=12
UPDATE [dbo].[c_Observation_Result] SET [sort_sequence]=13, [last_updated]='20230504 20:09:11.313' WHERE [observation_id]=N'DEMO951' AND [result_sequence]=13
UPDATE [dbo].[c_Observation_Result] SET [status]=N'NA', [last_updated]='20210709 20:21:30.903' WHERE [observation_id]=N'DEMO957' AND [result_sequence]=-2
UPDATE [dbo].[c_Observation_Result] SET [status]=N'NA', [last_updated]='20210709 20:21:26.220' WHERE [observation_id]=N'DEMO957' AND [result_sequence]=-1
UPDATE [dbo].[c_Observation_Result] SET [result_unit]=N'G/DL', [print_result_flag]=N'N', [severity]=0, [abnormal_flag]=N'N', [property_id]=0, [service]=N'', [unit_preference]=N'', [last_updated]='20210709 20:32:33.150' WHERE [observation_id]=N'DEMO957' AND [result_sequence]=1
UPDATE [dbo].[c_Observation_Result] SET [status]=N'NA', [last_updated]='20210709 20:21:36.433' WHERE [observation_id]=N'DEMO957' AND [result_sequence]=2
UPDATE [dbo].[c_Observation_Result] SET [status]=N'NA', [last_updated]='20210709 20:23:28.440' WHERE [observation_id]=N'DEMO957' AND [result_sequence]=3
UPDATE [dbo].[c_Observation_Result] SET [status]=N'NA', [last_updated]='20210709 20:23:31.313' WHERE [observation_id]=N'DEMO957' AND [result_sequence]=4
UPDATE [dbo].[c_Observation_Result] SET [sort_sequence]=7, [last_updated]='20230623 10:22:59.910' WHERE [observation_id]=N'DEMO9650' AND [result_sequence]=6
UPDATE [dbo].[c_Observation_Result] SET [status]=N'NA', [last_updated]='20210709 20:22:15.533' WHERE [observation_id]=N'DEMO966' AND [result_sequence]=-2
UPDATE [dbo].[c_Observation_Result] SET [status]=N'NA', [last_updated]='20210709 20:22:11.973' WHERE [observation_id]=N'DEMO966' AND [result_sequence]=-1
UPDATE [dbo].[c_Observation_Result] SET [status]=N'NA', [last_updated]='20210709 20:22:19.440' WHERE [observation_id]=N'DEMO966' AND [result_sequence]=4
UPDATE [dbo].[c_Observation_Result] SET [status]=N'NA', [last_updated]='20210709 20:24:20.560' WHERE [observation_id]=N'DEMO966' AND [result_sequence]=5
UPDATE [dbo].[c_Observation_Result] SET [status]=N'NA', [last_updated]='20210709 20:24:23.503' WHERE [observation_id]=N'DEMO966' AND [result_sequence]=6
UPDATE [dbo].[c_Observation_Result] SET [sort_sequence]=4, [last_updated]='20230714 19:55:33.547' WHERE [observation_id]=N'JMJP124' AND [result_sequence]=2
UPDATE [dbo].[c_Observation_Result] SET [sort_sequence]=9, [last_updated]='20230714 19:55:33.713' WHERE [observation_id]=N'JMJP124' AND [result_sequence]=3
UPDATE [dbo].[c_Observation_Result] SET [sort_sequence]=2, [status]=N'NA', [last_updated]='20230714 19:57:06.717' WHERE [observation_id]=N'JMJP124' AND [result_sequence]=4
UPDATE [dbo].[c_Observation_Result] SET [sort_sequence]=10, [last_updated]='20230714 19:55:33.750' WHERE [observation_id]=N'JMJP124' AND [result_sequence]=5
UPDATE [dbo].[c_Observation_Result] SET [sort_sequence]=5, [last_updated]='20230714 19:55:33.580' WHERE [observation_id]=N'JMJP124' AND [result_sequence]=6
UPDATE [dbo].[c_Observation_Result] SET [sort_sequence]=3, [last_updated]='20230714 19:55:33.513' WHERE [observation_id]=N'JMJP124' AND [result_sequence]=8
UPDATE [dbo].[c_Observation_Result] SET [status]=N'NA', [last_updated]='20230714 19:55:02.860' WHERE [observation_id]=N'JMJP124' AND [result_sequence]=9
UPDATE [dbo].[c_Observation_Result] SET [sort_sequence]=1, [last_updated]='20230714 19:55:33.450' WHERE [observation_id]=N'JMJP124' AND [result_sequence]=10
UPDATE [dbo].[c_Observation_Result] SET [result_unit]=NULL, [last_updated]='20210207 23:20:17.087' WHERE [observation_id]=N'TEMP' AND [result_sequence]=2
UPDATE [dbo].[c_Menu_Item_Attribute] SET [attribute]=N'context_object', [value]=N'Patient' WHERE [menu_id]=1000141 AND [menu_item_id]=1000780 AND [menu_item_attribute_sequence]=1000948
UPDATE [dbo].[c_Property] SET [title]=N'full_name', [script_language]=N'SQL', [script]=N'SELECT CONCAT(first_name, '', '', last_name) AS full_name FROM p_patient' WHERE [property_id]=1
UPDATE [dbo].[c_Property] SET [function_name]=N'sex_Male_Female', [status]=N'OK' WHERE [property_id]=510
UPDATE [dbo].[o_menu_selection] SET [menu_id]=1000044 WHERE [room_menu_selection_id]=1000004
UPDATE [dbo].[c_Menu] SET [status]=N'NA' WHERE [menu_id]=2
UPDATE [dbo].[c_Menu] SET [status]=N'NA' WHERE [menu_id]=3
UPDATE [dbo].[c_Menu] SET [status]=N'NA' WHERE [menu_id]=4
UPDATE [dbo].[c_Menu] SET [status]=N'NA' WHERE [menu_id]=10
UPDATE [dbo].[c_Menu] SET [status]=N'NA' WHERE [menu_id]=41
UPDATE [dbo].[c_Menu] SET [status]=N'OK' WHERE [menu_id]=72
UPDATE [dbo].[c_Menu] SET [status]=N'NA' WHERE [menu_id]=164
UPDATE [dbo].[c_Menu] SET [status]=N'NA' WHERE [menu_id]=325
UPDATE [dbo].[c_Menu] SET [status]=N'NA' WHERE [menu_id]=342
UPDATE [dbo].[c_Menu] SET [status]=N'NA' WHERE [menu_id]=480
UPDATE [dbo].[c_Menu] SET [status]=N'NA' WHERE [menu_id]=486
UPDATE [dbo].[c_Menu] SET [status]=N'NA' WHERE [menu_id]=540
UPDATE [dbo].[c_Menu] SET [status]=N'NA' WHERE [menu_id]=541
UPDATE [dbo].[c_Menu] SET [status]=N'NA' WHERE [menu_id]=542
UPDATE [dbo].[c_Menu] SET [status]=N'NA' WHERE [menu_id]=560
UPDATE [dbo].[c_Menu] SET [status]=N'NA' WHERE [menu_id]=628
UPDATE [dbo].[c_Menu] SET [status]=N'NA' WHERE [menu_id]=827
UPDATE [dbo].[c_Menu] SET [status]=N'NA' WHERE [menu_id]=837
UPDATE [dbo].[c_Menu] SET [status]=N'NA' WHERE [menu_id]=845
UPDATE [dbo].[c_Menu] SET [status]=N'NA' WHERE [menu_id]=868
UPDATE [dbo].[c_Menu] SET [status]=N'NA' WHERE [menu_id]=922
UPDATE [dbo].[c_Menu] SET [status]=N'NA' WHERE [menu_id]=928
UPDATE [dbo].[c_Menu] SET [status]=N'NA' WHERE [menu_id]=938
UPDATE [dbo].[c_Menu] SET [status]=N'NA' WHERE [menu_id]=945
UPDATE [dbo].[c_Menu] SET [status]=N'NA' WHERE [menu_id]=949
UPDATE [dbo].[c_Menu] SET [status]=N'NA' WHERE [menu_id]=1248
UPDATE [dbo].[c_Menu] SET [status]=N'NA' WHERE [menu_id]=1249
UPDATE [dbo].[c_Menu] SET [status]=N'NA' WHERE [menu_id]=1000019
UPDATE [dbo].[c_Menu] SET [status]=N'NA' WHERE [menu_id]=1000031
UPDATE [dbo].[c_Menu] SET [status]=N'NA' WHERE [menu_id]=1000033
UPDATE [dbo].[c_Menu] SET [status]=N'NA' WHERE [menu_id]=1000035
UPDATE [dbo].[c_Menu] SET [status]=N'NA' WHERE [menu_id]=1000037
UPDATE [dbo].[c_Menu] SET [status]=N'NA' WHERE [menu_id]=1000039
UPDATE [dbo].[c_Menu] SET [status]=N'NA' WHERE [menu_id]=1000042
UPDATE [dbo].[c_Menu] SET [status]=N'NA' WHERE [menu_id]=1000045
UPDATE [dbo].[c_Menu] SET [status]=N'NA' WHERE [menu_id]=1000048
UPDATE [dbo].[c_Menu] SET [status]=N'NA' WHERE [menu_id]=1000049
UPDATE [dbo].[c_Menu] SET [status]=N'NA' WHERE [menu_id]=1000050
UPDATE [dbo].[c_Menu] SET [status]=N'NA' WHERE [menu_id]=1000052
UPDATE [dbo].[c_Menu] SET [status]=N'NA' WHERE [menu_id]=1000056
UPDATE [dbo].[c_Menu] SET [status]=N'OK' WHERE [menu_id]=1000059
UPDATE [dbo].[c_Menu] SET [status]=N'NA' WHERE [menu_id]=1000060
UPDATE [dbo].[c_Menu] SET [status]=N'NA' WHERE [menu_id]=1000064
UPDATE [dbo].[c_Menu] SET [status]=N'NA' WHERE [menu_id]=1000076
UPDATE [dbo].[c_Menu] SET [status]=N'NA' WHERE [menu_id]=1000089
UPDATE [dbo].[c_Menu] SET [status]=N'NA' WHERE [menu_id]=1000107
UPDATE [dbo].[c_Menu] SET [status]=N'NA' WHERE [menu_id]=1000112
UPDATE [dbo].[c_Menu] SET [status]=N'NA' WHERE [menu_id]=1000131
UPDATE [dbo].[c_Menu] SET [description]=N'Standard Room Menu ENT', [specialty_id]=N'$ENT', [menu_category]=N'Menu Selection Menu', [status]=N'NA', [last_updated]='20190517 16:22:24.500', [id]=N'30738498-ac4c-44a0-afbe-2aa7d3684022' WHERE [menu_id]=1000141
UPDATE [dbo].[c_Observation] SET [description]=N'Chief Complaint', [last_updated]='20230707 19:51:41.967' WHERE [observation_id]=N'!!!CHIEF_COMPLAINT'
UPDATE [dbo].[c_Observation] SET [display_style]=N'OBO/ %- %#|RRR|CRN', [last_updated]='20210901 20:21:33.963' WHERE [observation_id]=N'!!ENT21'
UPDATE [dbo].[c_Observation] SET [description]=N'ENT Physical Examination', [last_updated]='20230707 20:15:59.270' WHERE [observation_id]=N'!ENTPHYSICAL'
UPDATE [dbo].[c_Observation] SET [description]=N'ROS with HPI Yes/No', [last_updated]='20230622 13:32:54.283' WHERE [observation_id]=N'0^21945'
UPDATE [dbo].[c_Observation] SET [display_style]=N'OBO|RRR|CRN', [last_updated]='20210930 16:40:39.173' WHERE [observation_id]=N'0^21948'
UPDATE [dbo].[c_Observation] SET [narrative_phrase]=N'{\rtf1\sstecf25000\ansi\deflang1033\ftnbj\uc1\deff0 
{\fonttbl{\f0 \fswiss Arial;}{\f1 \fswiss Tahoma;}}
{\colortbl ;\red255\green255\blue255 ;\red0\green0\blue0 ;}
{\stylesheet{\f0\fs24 Normal;}{\cs1 Default Paragraph Font;}}
{\*\revtbl{Unknown;}}
\paperw12240\paperh15840\margl0\margr0\margt0\margb0\headery720\footery720\nogrowautofit\deftab720\formshade\nofeaturethrottle1\dntblnsbdb\fet4\aendnotes\aftnnrlc\pgbrdrhead\pgbrdrfoot 
\sectd\pgwsxn12240\pghsxn15840\guttersxn0\marglsxn0\margrsxn0\margtsxn0\margbsxn0\headery720\footery720\sbkpage\pgncont\pgndec 
\plain\plain\f0\fs24\ql\plain\f1\fs20\lang1033\hich\f1\dbch\f1\loch\f1\cf2\fs20 kigalinewzealand}
', [location_pick_flag]=N'Y', [location_bill_flag]=N'Y', [display_style]=N'ORO|RRR|CRN', [last_updated]='20210303 16:44:42.370' WHERE [observation_id]=N'0^22488'
UPDATE [dbo].[c_Observation] SET [description]=N'Domestic violence', [last_updated]='20230714 15:43:54.630' WHERE [observation_id]=N'0^22527'
UPDATE [dbo].[c_Observation] SET [display_style]=N'OBO|RRR|CRN', [last_updated]='20210930 20:23:47.197' WHERE [observation_id]=N'0001109x'
UPDATE [dbo].[c_Observation] SET [display_style]=N'OBO|RRR|CRN', [last_updated]='20210930 20:23:38.157' WHERE [observation_id]=N'0001111x'
UPDATE [dbo].[c_Observation] SET [display_style]=N'OBO|RRR|CRN', [last_updated]='20210930 20:24:14.293' WHERE [observation_id]=N'0001112x'
UPDATE [dbo].[c_Observation] SET [display_style]=N'ORO|RRR|CRN', [last_updated]='20210930 20:24:23.780' WHERE [observation_id]=N'0001113x'
UPDATE [dbo].[c_Observation] SET [display_style]=N'OBO|RRR|CRN', [last_updated]='20210930 20:24:31.890' WHERE [observation_id]=N'0001114x'
UPDATE [dbo].[c_Observation] SET [display_style]=N'OBO|RRR|CRN', [last_updated]='20210930 20:24:42.180' WHERE [observation_id]=N'0001115x'
UPDATE [dbo].[c_Observation] SET [display_style]=N'OBO|RRR|CRN', [last_updated]='20210930 20:24:54.497' WHERE [observation_id]=N'0001117x'
UPDATE [dbo].[c_Observation] SET [display_style]=N'OBO|RRR|CRN', [last_updated]='20210930 20:25:03.640' WHERE [observation_id]=N'0001119x'
UPDATE [dbo].[c_Observation] SET [display_style]=N'OBO|RRR|CRN', [last_updated]='20210930 20:25:13.057' WHERE [observation_id]=N'0001120x'
UPDATE [dbo].[c_Observation] SET [display_style]=N'OBO|RRR|CRN', [last_updated]='20210930 20:25:22.120' WHERE [observation_id]=N'0001121x'
UPDATE [dbo].[c_Observation] SET [display_style]=N'OBO|RRR|CRN', [last_updated]='20210930 20:23:18.763' WHERE [observation_id]=N'0001189x'
UPDATE [dbo].[c_Observation] SET [display_style]=N'OBO|RRR|CRN', [last_updated]='20210930 20:23:29.577' WHERE [observation_id]=N'0001190x'
UPDATE [dbo].[c_Observation] SET [description]=N'ENT problems', [last_updated]='20230707 20:53:26.433' WHERE [observation_id]=N'0001277x'
UPDATE [dbo].[c_Observation] SET [display_style]=N'OBO|RRL|CRN', [last_updated]='20230714 17:46:10.677' WHERE [observation_id]=N'981^177'
UPDATE [dbo].[c_Observation] SET [display_style]=N'OBO|RRR|CRN', [last_updated]='20230714 17:00:49.230' WHERE [observation_id]=N'981^273'
UPDATE [dbo].[c_Observation] SET [display_style]=N'ORO|RRR / %: % |CRN', [last_updated]='20230705 13:55:47.513' WHERE [observation_id]=N'BPSIT'
UPDATE [dbo].[c_Observation] SET [description]=N'BP Standing', [last_updated]='20230705 14:04:07.440' WHERE [observation_id]=N'BPSTAND'
UPDATE [dbo].[c_Observation] SET [description]=N'ENT Review of Systems', [last_updated]='20230708 00:44:55.733' WHERE [observation_id]=N'DEMO10193'
UPDATE [dbo].[c_Observation] SET [description]=N'Surgery', [last_updated]='20230705 15:30:24.790' WHERE [observation_id]=N'DEMO10269'
UPDATE [dbo].[c_Observation] SET [description]=N'History of skin disease', [last_updated]='20230707 23:58:44.030' WHERE [observation_id]=N'DEMO10380'
UPDATE [dbo].[c_Observation] SET [description]=N'History of endocrine disorders', [last_updated]='20230708 00:49:58.553' WHERE [observation_id]=N'DEMO10383'
UPDATE [dbo].[c_Observation] SET [description]=N'History of GYN disorder', [last_updated]='20230707 23:59:45.690' WHERE [observation_id]=N'DEMO10390'
UPDATE [dbo].[c_Observation] SET [display_style]=N'OBO|RRR|CRN', [last_updated]='20210930 20:25:30.333' WHERE [observation_id]=N'DEMO1111a'
UPDATE [dbo].[c_Observation] SET [display_style]=N'OBO|RRR|CRN', [last_updated]='20210930 20:24:05.233' WHERE [observation_id]=N'DEMO1111x'
UPDATE [dbo].[c_Observation] SET [display_style]=N'OBO|RRR|CRN', [last_updated]='20210911 19:35:18.337' WHERE [observation_id]=N'DEMO11435'
UPDATE [dbo].[c_Observation] SET [display_style]=N'ORO|RRR|CRN', [last_updated]='20210911 19:31:51.667' WHERE [observation_id]=N'DEMO11436'
UPDATE [dbo].[c_Observation] SET [display_style]=N'OBO|RRR|CRN', [last_updated]='20210901 16:46:27.177' WHERE [observation_id]=N'DEMO11467'
UPDATE [dbo].[c_Observation] SET [display_style]=N'OBO|RBR|CRN', [last_updated]='20210930 21:00:35.030' WHERE [observation_id]=N'DEMO1158'
UPDATE [dbo].[c_Observation] SET [description]=N'ENT Disorder HPI', [last_updated]='20230622 14:13:45.433' WHERE [observation_id]=N'DEMO11584'
UPDATE [dbo].[c_Observation] SET [perform_location_domain]=N'ENMTdisoloca', [default_view]=N'L', [last_updated]='20230504 16:43:20.750' WHERE [observation_id]=N'DEMO11586'
UPDATE [dbo].[c_Observation] SET [description]=N'Asthma', [last_updated]='20230714 18:51:21.423' WHERE [observation_id]=N'DEMO11636'
UPDATE [dbo].[c_Observation] SET [description]=N'Cardiovascular disease', [last_updated]='20230714 19:12:11.777' WHERE [observation_id]=N'DEMO11639'
UPDATE [dbo].[c_Observation] SET [description]=N'Hypertension', [last_updated]='20230714 19:05:04.817' WHERE [observation_id]=N'DEMO11642'
UPDATE [dbo].[c_Observation] SET [description]=N'Migraines', [last_updated]='20230714 19:07:41.410' WHERE [observation_id]=N'DEMO11653'
UPDATE [dbo].[c_Observation] SET [description]=N'Arthritis', [last_updated]='20230714 19:11:10.997' WHERE [observation_id]=N'DEMO11660'
UPDATE [dbo].[c_Observation] SET [display_style]=N'OBO|RRR|CRN', [last_updated]='20210930 20:23:06.720' WHERE [observation_id]=N'DEMO11686a'
UPDATE [dbo].[c_Observation] SET [description]=N'Ringing in ears', [last_updated]='20230621 21:16:57.237' WHERE [observation_id]=N'DEMO11907'
UPDATE [dbo].[c_Observation] SET [display_style]=N'OBO|RRR|CRN', [last_updated]='20210930 20:23:54.857' WHERE [observation_id]=N'DEMO1190a'
UPDATE [dbo].[c_Observation] SET [description]=N'Sore throat', [last_updated]='20230621 21:17:15.880' WHERE [observation_id]=N'DEMO11914'
UPDATE [dbo].[c_Observation] SET [description]=N'General Review of Systems', [last_updated]='20230707 20:32:04.740' WHERE [observation_id]=N'DEMO12099'
UPDATE [dbo].[c_Observation] SET [description]=N'History of orthopedic surgery', [last_updated]='20230707 23:46:55.143' WHERE [observation_id]=N'DEMO12194'
UPDATE [dbo].[c_Observation] SET [display_style]=N'OBO|RRR/ %:%,|CBN', [last_updated]='20210901 20:17:30.117' WHERE [observation_id]=N'DEMO13268'
UPDATE [dbo].[c_Observation] SET [display_style]=N'OBO|RRR|CRN', [last_updated]='20230501 22:21:06.060' WHERE [observation_id]=N'DEMO13835'
UPDATE [dbo].[c_Observation] SET [display_style]=N'OBO|RRR, %------ %......|CBN', [last_updated]='20211222 19:30:37.773' WHERE [observation_id]=N'DEMO14372'
UPDATE [dbo].[c_Observation] SET [display_style]=N'OBO|RRR, %------ %......|CBN', [last_updated]='20211222 17:11:08.550' WHERE [observation_id]=N'DEMO14374'
UPDATE [dbo].[c_Observation] SET [status]=N'NA', [last_updated]='20230705 21:32:32.973' WHERE [observation_id]=N'DEMO14425'
UPDATE [dbo].[c_Observation] SET [description]=N'Asthma_HPI', [last_updated]='20230705 16:06:21.640' WHERE [observation_id]=N'DEMO14681'
UPDATE [dbo].[c_Observation] SET [description]=N'General ROS with HPI Drilldown', [last_updated]='20230622 13:33:14.643' WHERE [observation_id]=N'DEMO16443'
UPDATE [dbo].[c_Observation] SET [display_style]=N'OBO|RRL|CRN', [last_updated]='20230503 11:39:45.753' WHERE [observation_id]=N'DEMO16449'
UPDATE [dbo].[c_Observation] SET [display_style]=N'OBO|RRR|CRN', [last_updated]='20210930 21:01:02.667' WHERE [observation_id]=N'DEMO16469'
UPDATE [dbo].[c_Observation] SET [display_style]=N'OBO; %: %, |Ffontsize=10,left,margin=000/000/5000|RRL; %: %, |CBN; %: %,', [last_updated]='20211222 19:38:44.843' WHERE [observation_id]=N'DEMO17463'
UPDATE [dbo].[c_Observation] SET [description]=N'Ears Yes/No', [last_updated]='20230622 13:34:48.200' WHERE [observation_id]=N'DEMO17856'
UPDATE [dbo].[c_Observation] SET [display_style]=N'OBR;%;%;  |RRR|CRN', [last_updated]='20230714 19:28:08.400' WHERE [observation_id]=N'DEMO18258'
UPDATE [dbo].[c_Observation] SET [description]=N'Injury/trauma', [last_updated]='20230714 19:29:19.023' WHERE [observation_id]=N'DEMO18335'
UPDATE [dbo].[c_Observation] SET [description]=N'History of neurologic surgery', [last_updated]='20230707 23:46:40.950' WHERE [observation_id]=N'DEMO18346'
UPDATE [dbo].[c_Observation] SET [description]=N'History of ENT surgery', [last_updated]='20230707 23:45:56.710' WHERE [observation_id]=N'DEMO18351'
UPDATE [dbo].[c_Observation] SET [description]=N'Ear, Nose, Mouth, Throat Disorder', [last_updated]='20230707 23:54:59.900' WHERE [observation_id]=N'DEMO18353'
UPDATE [dbo].[c_Observation] SET [description]=N'Non surgical hospitalization', [last_updated]='20230707 23:47:11.483' WHERE [observation_id]=N'DEMO18383'
UPDATE [dbo].[c_Observation] SET [description]=N'Arthritis', [last_updated]='20230707 21:17:02.760' WHERE [observation_id]=N'DEMO18439'
UPDATE [dbo].[c_Observation] SET [description]=N'History of plastic/skin surgery', [last_updated]='20230707 23:46:19.753' WHERE [observation_id]=N'DEMO18504'
UPDATE [dbo].[c_Observation] SET [description]=N'Asthma HPI ', [last_updated]='20230705 16:06:31.433' WHERE [observation_id]=N'DEMO18672'
UPDATE [dbo].[c_Observation] SET [perform_location_domain]=N'EarCATscan', [description]=N'Ear Pain', [exclusive_flag]=N'N', [display_style]=N'OBO|RRR|CRN', [default_view]=N'L', [last_updated]='20230505 13:52:42.107' WHERE [observation_id]=N'DEMO18722'
UPDATE [dbo].[c_Observation] SET [description]=N'Systemic Lupus', [last_updated]='20230707 21:17:18.240' WHERE [observation_id]=N'DEMO19445'
UPDATE [dbo].[c_Observation] SET [description]=N'Acne', [last_updated]='20230707 21:16:21.650' WHERE [observation_id]=N'DEMO19754'
UPDATE [dbo].[c_Observation] SET [description]=N'Hair Loss', [last_updated]='20230707 21:16:42.700' WHERE [observation_id]=N'DEMO19755'
UPDATE [dbo].[c_Observation] SET [description]=N'Anaemia', [last_updated]='20230707 21:16:31.803' WHERE [observation_id]=N'DEMO19756'
UPDATE [dbo].[c_Observation] SET [description]=N'Hay Fever', [last_updated]='20230707 21:16:52.120' WHERE [observation_id]=N'DEMO19760'
UPDATE [dbo].[c_Observation] SET [description]=N'Melanoma', [last_updated]='20230707 21:17:26.677' WHERE [observation_id]=N'DEMO19762'
UPDATE [dbo].[c_Observation] SET [description]=N'Psoriasis', [last_updated]='20230707 21:17:36.103' WHERE [observation_id]=N'DEMO19763'
UPDATE [dbo].[c_Observation] SET [description]=N'Skin Cancer', [last_updated]='20230707 21:17:46.830' WHERE [observation_id]=N'DEMO19764'
UPDATE [dbo].[c_Observation] SET [description]=N'Tuberculosis', [last_updated]='20230707 21:17:58.177' WHERE [observation_id]=N'DEMO19765'
UPDATE [dbo].[c_Observation] SET [description]=N'Hair loss', [last_updated]='20230714 19:08:20.640' WHERE [observation_id]=N'DEMO19771'
UPDATE [dbo].[c_Observation] SET [description]=N'History of keloids (scarring)', [last_updated]='20230707 23:54:30.273' WHERE [observation_id]=N'DEMO19775'
UPDATE [dbo].[c_Observation] SET [description]=N'Back problems', [last_updated]='20230714 18:53:34.577' WHERE [observation_id]=N'DEMO19791'
UPDATE [dbo].[c_Observation] SET [description]=N'Blood clots', [last_updated]='20230714 18:54:24.377' WHERE [observation_id]=N'DEMO19792'
UPDATE [dbo].[c_Observation] SET [description]=N'Hepatitis', [last_updated]='20230714 19:07:15.467' WHERE [observation_id]=N'DEMO19794'
UPDATE [dbo].[c_Observation] SET [description]=N'Systemic lupus', [last_updated]='20230714 19:01:34.283' WHERE [observation_id]=N'DEMO19795'
UPDATE [dbo].[c_Observation] SET [description]=N'ADD or ADDHD', [last_updated]='20230714 18:52:21.523' WHERE [observation_id]=N'DEMO19904'
UPDATE [dbo].[c_Observation] SET [description]=N'Developmental delays', [last_updated]='20230714 19:07:59.510' WHERE [observation_id]=N'DEMO19912'
UPDATE [dbo].[c_Observation] SET [display_style]=N'OBO|RRL|CRN', [last_updated]='20211221 19:36:35.870' WHERE [observation_id]=N'DEMO19938'
UPDATE [dbo].[c_Observation] SET [description]=N'CHIEF COMPLAINT AND HISTORY OF PRESENT ILLNESS', [display_style]=N'OBO:  %:  %,|RRR"%:%, |CBN"%: %,', [last_updated]='20230714 19:28:08.400' WHERE [observation_id]=N'DEMO20201'
UPDATE [dbo].[c_Observation] SET [description]=N'ADD/ADDHD Questions', [last_updated]='20230713 17:42:16.750' WHERE [observation_id]=N'DEMO20403'
UPDATE [dbo].[c_Observation] SET [description]=N'Headache HPI_Brief', [last_updated]='20230705 16:15:34.700' WHERE [observation_id]=N'DEMO20702'
UPDATE [dbo].[c_Observation] SET [description]=N'Psychologic HPI Yes/No', [last_updated]='20230713 17:44:36.083' WHERE [observation_id]=N'DEMO20853'
UPDATE [dbo].[c_Observation] SET [description]=N'Is headache triggered by bright light?', [last_updated]='20230705 16:15:28.063' WHERE [observation_id]=N'DEMO21042'
UPDATE [dbo].[c_Observation] SET [display_style]=N'OBO|RRR|CRN', [last_updated]='20230707 16:32:17.320' WHERE [observation_id]=N'DEMO21044'
UPDATE [dbo].[c_Observation] SET [exclusive_flag]=N'Y', [last_updated]='20190622 15:40:45.530' WHERE [observation_id]=N'DEMO21455'
UPDATE [dbo].[c_Observation] SET [description]=N'Marital/ Relationship status', [last_updated]='20230714 19:59:15.620' WHERE [observation_id]=N'DEMO3309'
UPDATE [dbo].[c_Observation] SET [perform_location_domain]=N'ZealandK', [last_updated]='20210303 12:32:03.130' WHERE [observation_id]=N'DEMO3364'
UPDATE [dbo].[c_Observation] SET [exclusive_flag]=N'Y', [last_updated]='20210305 22:19:29.077' WHERE [observation_id]=N'DEMO4017'
UPDATE [dbo].[c_Observation] SET [exclusive_flag]=N'Y', [last_updated]='20210305 22:19:23.770' WHERE [observation_id]=N'DEMO4018'
UPDATE [dbo].[c_Observation] SET [description]=N'Respiratory Symptoms HPI ', [last_updated]='20230705 16:07:22.160' WHERE [observation_id]=N'DEMO5802'
UPDATE [dbo].[c_Observation] SET [description]=N'Ear Symptoms HPI ', [last_updated]='20230705 16:11:40.847' WHERE [observation_id]=N'DEMO5807'
UPDATE [dbo].[c_Observation] SET [description]=N'Headache HPI', [last_updated]='20230705 16:15:06.977' WHERE [observation_id]=N'DEMO5811'
UPDATE [dbo].[c_Observation] SET [description]=N'History of neurologic disorder', [last_updated]='20230707 23:42:52.850' WHERE [observation_id]=N'DEMO6476'
UPDATE [dbo].[c_Observation] SET [description]=N'History of cardiovascular disorder', [last_updated]='20230714 18:30:05.160' WHERE [observation_id]=N'DEMO6483'
UPDATE [dbo].[c_Observation] SET [description]=N'Hospitalization', [last_updated]='20230711 10:05:54.250' WHERE [observation_id]=N'DEMO7322'
UPDATE [dbo].[c_Observation] SET [description]=N'Osteoarthritis', [last_updated]='20230714 18:53:03.837' WHERE [observation_id]=N'DEMO7385'
UPDATE [dbo].[c_Observation] SET [display_style]=N'OBO|RRR/ %:%,|CBN', [last_updated]='20210901 20:15:53.650' WHERE [observation_id]=N'DEMO7879'
UPDATE [dbo].[c_Observation] SET [description]=N'Facial Drooping HPI', [last_updated]='20230622 14:10:54.290' WHERE [observation_id]=N'DEMO7928'
UPDATE [dbo].[c_Observation] SET [display_style]=N'OBO|RRR|CRN', [last_updated]='20210928 19:06:24.020' WHERE [observation_id]=N'DEMO8533'
UPDATE [dbo].[c_Observation] SET [description]=N'Psychologic Symptoms HPI Drilldown', [last_updated]='20230713 17:44:49.410' WHERE [observation_id]=N'DEMO9057'
UPDATE [dbo].[c_Observation] SET [description]=N'Cold Symptoms HPI', [last_updated]='20230705 16:04:07.880' WHERE [observation_id]=N'DEMO9207'
UPDATE [dbo].[c_Observation] SET [display_style]=N'OBO|RRR|CRN', [last_updated]='20230505 14:03:28.187' WHERE [observation_id]=N'DEMO9363'
UPDATE [dbo].[c_Observation] SET [display_style]=N'OBO|RRR|CRN', [last_updated]='20230505 13:45:31.353' WHERE [observation_id]=N'DEMO9364'
UPDATE [dbo].[c_Observation] SET [display_style]=N'OBO- %:%,|RRR/ %:%,|CBN', [last_updated]='20210901 20:20:11.980' WHERE [observation_id]=N'DEMO9404'
UPDATE [dbo].[c_Observation] SET [description]=N'Albumin ', [last_updated]='20210716 14:15:37.603' WHERE [observation_id]=N'DEMO957'
UPDATE [dbo].[c_Observation] SET [display_style]=N'OBO|RRR|CBN', [last_updated]='20210901 16:09:00.363' WHERE [observation_id]=N'DEMO9604'
UPDATE [dbo].[c_Observation] SET [display_style]=N'OBO|RRR|CRN', [last_updated]='20210901 16:46:18.227' WHERE [observation_id]=N'DEMO9620'
UPDATE [dbo].[c_Observation] SET [display_style]=N'OBO|RRR|CRN', [last_updated]='20210901 16:46:38.867' WHERE [observation_id]=N'DEMO9621'
UPDATE [dbo].[c_Observation] SET [description]=N'Bilirubin, total', [last_updated]='20210709 20:31:32.050' WHERE [observation_id]=N'DEMO966'
UPDATE [dbo].[c_Observation] SET [display_style]=N'OBO|RRR|CRN', [last_updated]='20210901 16:46:46.040' WHERE [observation_id]=N'DEMO9831'
UPDATE [dbo].[c_Observation] SET [description]=N'Heart Rate', [display_style]=N'ORO|RRR; %: % |CRN', [last_updated]='20230705 14:04:56.753' WHERE [observation_id]=N'HR'
UPDATE [dbo].[c_Observation] SET [display_style]=N'OBO|RRR|CBN', [last_updated]='20210901 15:26:42.943' WHERE [observation_id]=N'L21ENT240TURB'
UPDATE [dbo].[c_Observation] SET [display_style]=N'OBO|RRR|CRN', [last_updated]='20210901 16:09:40.923' WHERE [observation_id]=N'L21NECK120THYROID'
UPDATE [dbo].[c_Observation] SET [display_style]=N'OBO|RRR|CRN', [last_updated]='20210903 17:41:29.670' WHERE [observation_id]=N'L4HEAD125FONT'
UPDATE [dbo].[c_Treatment_Type] SET [default_duplicate_check_days]=0 WHERE [treatment_type]=N'AnticipatoryGuid'
UPDATE [dbo].[c_Treatment_Type] SET [status]=N'OK' WHERE [treatment_type]=N'BARTON'
UPDATE [dbo].[c_Treatment_Type] SET [component_id]=N'TREAT_MATERIAL' WHERE [treatment_type]=N'Counseling'
UPDATE [dbo].[c_Treatment_Type] SET [default_duplicate_check_days]=10000 WHERE [treatment_type]=N'LAB'
UPDATE [dbo].[c_Treatment_Type] SET [default_duplicate_check_days]=1 WHERE [treatment_type]=N'MEDICATION'
UPDATE [dbo].[c_Treatment_Type] SET [status]=N'OK' WHERE [treatment_type]=N'ROS_HISTORY'
UPDATE [dbo].[c_Treatment_Type] SET [description]=N'TEST', [define_title]=NULL, [button]=N'button_todo.bmp', [icon]=N'button_todo.bmp', [sort_sequence]=999, [workplan_id]=NULL, [observation_type]=NULL, [soap_display_rule]=NULL, [referral_specialty_id]=NULL, [display_format]=NULL, [risk_level]=NULL, [id]=N'25fe5239-496b-477c-afae-0e1fcb320d3d', [owner_id]=981, [last_updated]='20230714 17:10:20.347', [epro_object]=NULL WHERE [treatment_type]=N'TEST'
UPDATE [dbo].[c_Specialty] SET [status]=N'NA', [short_list]=N'Y' WHERE [specialty_id]=N'$'
UPDATE [dbo].[c_Specialty] SET [status]=N'NA', [short_list]=N'N' WHERE [specialty_id]=N'$AAANONE'
UPDATE [dbo].[c_Specialty] SET [status]=N'NA' WHERE [specialty_id]=N'$AAAPRIMARY'
UPDATE [dbo].[c_Specialty] SET [status]=N'NA' WHERE [specialty_id]=N'$ALLERGY'
UPDATE [dbo].[c_Specialty] SET [status]=N'NA' WHERE [specialty_id]=N'$CARDIO'
UPDATE [dbo].[c_Specialty] SET [status]=N'NA' WHERE [specialty_id]=N'$CARDIOLOGY_PEDIATRIC'
UPDATE [dbo].[c_Specialty] SET [status]=N'NA' WHERE [specialty_id]=N'$CHILD'
UPDATE [dbo].[c_Specialty] SET [status]=N'NA' WHERE [specialty_id]=N'$CHIRO'
UPDATE [dbo].[c_Specialty] SET [status]=N'NA' WHERE [specialty_id]=N'$DENTIST'
UPDATE [dbo].[c_Specialty] SET [status]=N'NA' WHERE [specialty_id]=N'$DERM'
UPDATE [dbo].[c_Specialty] SET [status]=N'NA' WHERE [specialty_id]=N'$DFACS'
UPDATE [dbo].[c_Specialty] SET [status]=N'NA' WHERE [specialty_id]=N'$DIET'
UPDATE [dbo].[c_Specialty] SET [status]=N'NA' WHERE [specialty_id]=N'$EMERG'
UPDATE [dbo].[c_Specialty] SET [status]=N'NA' WHERE [specialty_id]=N'$ENDO'
UPDATE [dbo].[c_Specialty] SET [status]=N'NA' WHERE [specialty_id]=N'$EYE'
UPDATE [dbo].[c_Specialty] SET [status]=N'NA' WHERE [specialty_id]=N'$FP'
UPDATE [dbo].[c_Specialty] SET [short_list]=N'Y' WHERE [specialty_id]=N'$FPOB'
UPDATE [dbo].[c_Specialty] SET [status]=N'NA' WHERE [specialty_id]=N'$GASTRO'
UPDATE [dbo].[c_Specialty] SET [status]=N'NA' WHERE [specialty_id]=N'$GASTROENTEROLOGY_PEDIA'
UPDATE [dbo].[c_Specialty] SET [status]=N'NA', [short_list]=N'N' WHERE [specialty_id]=N'$GENE/DEV'
UPDATE [dbo].[c_Specialty] SET [status]=N'NA' WHERE [specialty_id]=N'$HEMEONC'
UPDATE [dbo].[c_Specialty] SET [status]=N'NA' WHERE [specialty_id]=N'$HOSP'
UPDATE [dbo].[c_Specialty] SET [status]=N'NA', [short_list]=N'N' WHERE [specialty_id]=N'$HOSP2'
UPDATE [dbo].[c_Specialty] SET [status]=N'NA', [short_list]=N'N' WHERE [specialty_id]=N'$HOSP3'
UPDATE [dbo].[c_Specialty] SET [status]=N'NA' WHERE [specialty_id]=N'$IM'
UPDATE [dbo].[c_Specialty] SET [status]=N'NA' WHERE [specialty_id]=N'$INFECT'
UPDATE [dbo].[c_Specialty] SET [status]=N'NA' WHERE [specialty_id]=N'$LAB'
UPDATE [dbo].[c_Specialty] SET [status]=N'NA' WHERE [specialty_id]=N'$LACTATION'
UPDATE [dbo].[c_Specialty] SET [status]=N'NA' WHERE [specialty_id]=N'$MATERNAL_FETAL_MEDICINE'
UPDATE [dbo].[c_Specialty] SET [status]=N'NA' WHERE [specialty_id]=N'$NEONATE'
UPDATE [dbo].[c_Specialty] SET [status]=N'NA' WHERE [specialty_id]=N'$NEPH'
UPDATE [dbo].[c_Specialty] SET [status]=N'NA' WHERE [specialty_id]=N'$NEUROLOGY'
UPDATE [dbo].[c_Specialty] SET [status]=N'NA' WHERE [specialty_id]=N'$NEUROLOGYP'
UPDATE [dbo].[c_Specialty] SET [status]=N'NA' WHERE [specialty_id]=N'$NEUROSURGERY'
UPDATE [dbo].[c_Specialty] SET [status]=N'NA' WHERE [specialty_id]=N'$NUCLEARDIAG'
UPDATE [dbo].[c_Specialty] SET [status]=N'NA' WHERE [specialty_id]=N'$OBGYN'
UPDATE [dbo].[c_Specialty] SET [status]=N'NA' WHERE [specialty_id]=N'$OCCUPATIONAL_THERAPIST'
UPDATE [dbo].[c_Specialty] SET [status]=N'NA' WHERE [specialty_id]=N'$OPTO'
UPDATE [dbo].[c_Specialty] SET [status]=N'NA' WHERE [specialty_id]=N'$ORAL'
UPDATE [dbo].[c_Specialty] SET [status]=N'NA' WHERE [specialty_id]=N'$ORTHO'
UPDATE [dbo].[c_Specialty] SET [status]=N'NA' WHERE [specialty_id]=N'$ORTHOPEDIC_SURGEON'
UPDATE [dbo].[c_Specialty] SET [status]=N'NA' WHERE [specialty_id]=N'$ORTHOPEDIC_SURGERY_PED'
UPDATE [dbo].[c_Specialty] SET [status]=N'NA' WHERE [specialty_id]=N'$OTOLARYNGOLOGY'
UPDATE [dbo].[c_Specialty] SET [status]=N'NA' WHERE [specialty_id]=N'$PATHOLOGY'
UPDATE [dbo].[c_Specialty] SET [status]=N'NA' WHERE [specialty_id]=N'$PED_OPHTH'
UPDATE [dbo].[c_Specialty] SET [status]=N'NA' WHERE [specialty_id]=N'$PEDENDO'
UPDATE [dbo].[c_Specialty] SET [status]=N'NA' WHERE [specialty_id]=N'$PHARMACY'
UPDATE [dbo].[c_Specialty] SET [status]=N'ok' WHERE [specialty_id]=N'$PHYSIATRY'
UPDATE [dbo].[c_Specialty] SET [status]=N'ok' WHERE [specialty_id]=N'$PHYSICAL_MEDICINE'
UPDATE [dbo].[c_Specialty] SET [status]=N'NA' WHERE [specialty_id]=N'$PLASTIC'
UPDATE [dbo].[c_Specialty] SET [status]=N'NA' WHERE [specialty_id]=N'$PODIATRY'
UPDATE [dbo].[c_Specialty] SET [status]=N'NA' WHERE [specialty_id]=N'$POLICE'
UPDATE [dbo].[c_Specialty] SET [status]=N'NA' WHERE [specialty_id]=N'$PSYCH'
UPDATE [dbo].[c_Specialty] SET [short_list]=N'Y' WHERE [specialty_id]=N'$PSYCHIATRY'
UPDATE [dbo].[c_Specialty] SET [status]=N'NA', [short_list]=N'N' WHERE [specialty_id]=N'$PSYCHIATRY_OR_PSYCHOLOG'
UPDATE [dbo].[c_Specialty] SET [status]=N'NA' WHERE [specialty_id]=N'$PULMONOLOGY'
UPDATE [dbo].[c_Specialty] SET [status]=N'NA', [short_list]=N'Y' WHERE [specialty_id]=N'$RADIATION_UNCOLOGY'
UPDATE [dbo].[c_Specialty] SET [status]=N'NA' WHERE [specialty_id]=N'$RADS'
UPDATE [dbo].[c_Specialty] SET [status]=N'NA' WHERE [specialty_id]=N'$REPRODUCTIVE_INFERTILIT'
UPDATE [dbo].[c_Specialty] SET [status]=N'NA' WHERE [specialty_id]=N'$RHEUM'
UPDATE [dbo].[c_Specialty] SET [status]=N'NA' WHERE [specialty_id]=N'$SLEEP_CENTERS'
UPDATE [dbo].[c_Specialty] SET [status]=N'NA' WHERE [specialty_id]=N'$SMOKING_CESSATION_CLINI'
UPDATE [dbo].[c_Specialty] SET [status]=N'NA' WHERE [specialty_id]=N'$SPECIALIST'
UPDATE [dbo].[c_Specialty] SET [description]=N'Speech and Language Therapy', [status]=N'ok' WHERE [specialty_id]=N'$SPEECH'
UPDATE [dbo].[c_Specialty] SET [status]=N'NA' WHERE [specialty_id]=N'$Support_Epro_All'
UPDATE [dbo].[c_Specialty] SET [status]=N'NA' WHERE [specialty_id]=N'$Support_Epro_Config'
UPDATE [dbo].[c_Specialty] SET [status]=N'NA' WHERE [specialty_id]=N'$Support_Epro_Interop'
UPDATE [dbo].[c_Specialty] SET [status]=N'NA' WHERE [specialty_id]=N'$Support_Epro_Reports'
UPDATE [dbo].[c_Specialty] SET [status]=N'NA' WHERE [specialty_id]=N'$Support_Epro_User'
UPDATE [dbo].[c_Specialty] SET [status]=N'NA' WHERE [specialty_id]=N'$Support_IT'
UPDATE [dbo].[c_Specialty] SET [status]=N'NA' WHERE [specialty_id]=N'$SURG'
UPDATE [dbo].[c_Specialty] SET [status]=N'NA' WHERE [specialty_id]=N'$SURGERY_CENTER'
UPDATE [dbo].[c_Specialty] SET [status]=N'NA' WHERE [specialty_id]=N'$SURGERY_GENERAL'
UPDATE [dbo].[c_Specialty] SET [status]=N'NA' WHERE [specialty_id]=N'$SURGERY_RECTAL'
UPDATE [dbo].[c_Specialty] SET [status]=N'NA' WHERE [specialty_id]=N'$SURGERY_THORACIC'
UPDATE [dbo].[c_Specialty] SET [status]=N'NA' WHERE [specialty_id]=N'$SURGERY_VASCULAR'
UPDATE [dbo].[c_Specialty] SET [status]=N'NA' WHERE [specialty_id]=N'$TEMPOROMANDIBULAR_JOINT'
UPDATE [dbo].[c_Specialty] SET [status]=N'NA' WHERE [specialty_id]=N'$TEST'
UPDATE [dbo].[c_Specialty] SET [status]=N'NA' WHERE [specialty_id]=N'$UROLOGY'
UPDATE [dbo].[c_Specialty] SET [status]=N'NA' WHERE [specialty_id]=N'$UROLOGY_PEDIATRIC'
UPDATE [dbo].[c_Specialty] SET [status]=N'NA' WHERE [specialty_id]=N'$USDIAG'
UPDATE [dbo].[c_Specialty] SET [status]=N'NA' WHERE [specialty_id]=N'$WEIGHT_MANAGEMENT'
UPDATE [dbo].[c_Specialty] SET [status]=N'NA' WHERE [specialty_id]=N'$ZSUPPORT'
UPDATE [dbo].[c_Specialty] SET [status]=N'NA' WHERE [specialty_id]=N'ORTHOTIC_PROSTHETIC_PLAC'
UPDATE [dbo].[c_Specialty] SET [status]=N'NA' WHERE [specialty_id]=N'PHYSICAL_MEDICINE___REHA'
UPDATE [dbo].[c_Domain] SET [domain_item]=N'KIGALI' WHERE [domain_id]=N'OBSERVATION_TAG' AND [domain_sequence]=70
UPDATE [dbo].[u_assessment_treat_definition] SET [treatment_description]=N'Vaccine admin, w/o couns, 1 st' WHERE [definition_id]=72190
UPDATE [dbo].[u_assessment_treat_definition] SET [treatment_description]=N'MMRV' WHERE [definition_id]=72607
UPDATE [dbo].[u_assessment_treat_definition] SET [assessment_id]=N'DEMO10470', [treatment_type]=N'LAB', [treatment_description]=N'Rapid strep, Throat (in-house) (87880)', [sort_sequence]=3, [parent_definition_id]=74467, [created]='20190619 14:40:38.700', [treatment_key]=N'DEMO2549', [treatment_mode]=N'Enc Col Perf Rev Cons' WHERE [definition_id]=81165
UPDATE [dbo].[o_Preferences] SET [preference_value]=N'FIRSTVISIT' WHERE [preference_type]=N'BILLINGSYSTEM' AND [preference_level]=N'Global' AND [preference_key]=N'Global' AND [preference_id]=N'default_encounter_type'
UPDATE [dbo].[o_Preferences] SET [preference_value]=N'1001641' WHERE [preference_type]=N'FAVORITES' AND [preference_level]=N'Global' AND [preference_key]=N'Global' AND [preference_id]=N'Favorite Summary Display Script Id'
UPDATE [dbo].[o_Preferences] SET [preference_value]=N'55' WHERE [preference_type]=N'IMMUNIZATION' AND [preference_level]=N'Office' AND [preference_key]=N'0001' AND [preference_id]=N'LIT_MEDIMMUNE_90744'
UPDATE [dbo].[o_Preferences] SET [preference_value]=N'IMMUN2' WHERE [preference_type]=N'IMMUNIZATION' AND [preference_level]=N'Office' AND [preference_key]=N'0001' AND [preference_id]=N'LOCATION_DTAP'
UPDATE [dbo].[o_Preferences] SET [preference_value]=N'IMMUN4' WHERE [preference_type]=N'IMMUNIZATION' AND [preference_level]=N'Office' AND [preference_key]=N'0001' AND [preference_id]=N'LOCATION_DTaP/Hib/IPV'
UPDATE [dbo].[o_Preferences] SET [preference_value]=N'IMMUN11' WHERE [preference_type]=N'IMMUNIZATION' AND [preference_level]=N'Office' AND [preference_key]=N'0001' AND [preference_id]=N'LOCATION_HEPB'
UPDATE [dbo].[o_Preferences] SET [preference_value]=N'87655' WHERE [preference_type]=N'IMMUNIZATION' AND [preference_level]=N'Office' AND [preference_key]=N'0001' AND [preference_id]=N'LOT_MEDIMMUNE_HEPB'
UPDATE [dbo].[o_Preferences] SET [preference_value]=N'98[07[0' WHERE [preference_type]=N'IMMUNIZATION' AND [preference_level]=N'Office' AND [preference_key]=N'0001' AND [preference_id]=N'LOT_sanofi_DTaP/Hib/IPV'
UPDATE [dbo].[o_Preferences] SET [preference_value]=N'sanofi' WHERE [preference_type]=N'IMMUNIZATION' AND [preference_level]=N'Office' AND [preference_key]=N'0001' AND [preference_id]=N'MAKER_DTAP'
UPDATE [dbo].[o_Preferences] SET [preference_value]=N'bold' WHERE [preference_type]=N'PREFERENCES' AND [preference_level]=N'Global' AND [preference_key]=N'Global' AND [preference_id]=N'abnormal_result_font_settings'
UPDATE [dbo].[o_Preferences] SET [preference_value]=N'FOXMEADOWS' WHERE [preference_type]=N'PREFERENCES' AND [preference_level]=N'Global' AND [preference_key]=N'Global' AND [preference_id]=N'default_billing_system'
UPDATE [dbo].[o_Preferences] SET [preference_value]=N'METRIC' WHERE [preference_type]=N'PREFERENCES' AND [preference_level]=N'Global' AND [preference_key]=N'Global' AND [preference_id]=N'unit'
UPDATE [dbo].[o_Preferences] SET [preference_value]=NULL WHERE [preference_type]=N'PROPERTY' AND [preference_level]=N'Global' AND [preference_key]=N'Global' AND [preference_id]=N'Favorite Adult Other HX'
UPDATE [dbo].[o_Preferences] SET [preference_value]=N'N' WHERE [preference_type]=N'RX' AND [preference_level]=N'Global' AND [preference_key]=N'Global' AND [preference_id]=N'rx_include_generic_name'
UPDATE [dbo].[o_Preferences] SET [preference_value]=N'N' WHERE [preference_type]=N'SECURITY' AND [preference_level]=N'Global' AND [preference_key]=N'Global' AND [preference_id]=N'Allow Multiple Logons'
UPDATE [dbo].[o_Preferences] SET [preference_value]=N'c:\temp' WHERE [preference_type]=N'SYSTEM' AND [preference_level]=N'Global' AND [preference_key]=N'Global' AND [preference_id]=N'temp_path'

ALTER TABLE [dbo].[c_Observation_Result_Set_Item] DROP CONSTRAINT [FK_c_Observation_Res_1]
UPDATE [dbo].[c_Observation_Result_Set_Item] SET [result_unit]=NULL, [result]=N'No', [result_amount_flag]=N'N', [abnormal_flag]=N'N', [sort_sequence]=2, [severity]=0 WHERE [result_set_id]=695 AND [result_sequence]=3
ALTER TABLE [dbo].[c_Observation_Result_Set_Item]
    ADD CONSTRAINT [FK_c_Observation_Res_1] FOREIGN KEY ([result_set_id]) REFERENCES [dbo].[c_Observation_Result_Set] ([result_set_id])

UPDATE c_Config_Log SET computer_id = 0, performed_by = 'NAINT-2023-07015'
WHERE computer_id IS NULL

  alter table c_Config_Log alter column computer_id int not null
  alter table c_Config_Log alter column performed_by varchar(24) not null

--UPDATE [dbo].[c_Attachment_Location] SET [attachment_server]=N'DESKTOP-8J0GBFH' WHERE [attachment_location_id]=3

COMMIT TRANSACTION

/* Potential fixes

update c_User set access_id = '0222', user_status = 'OK' where user_id = '981^2'
update c_User set access_id = '0220', user_status = 'OK' where user_id = '981^1'
update c_User set access_id = '1020', user_status = 'OK' where user_id = 'SUPPORT'

update  EncounterPro_OS.dbo.c_user set status = 'OK' where status != 'OK'

update c_Attachment_Location set attachment_server = 'localhost'
*/
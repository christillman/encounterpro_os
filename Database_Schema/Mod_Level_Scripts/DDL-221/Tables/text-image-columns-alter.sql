go
alter table c_Component_Attribute_Def alter column description nvarchar(max)
go
alter table c_Component_Base_Attribute_Def alter column description nvarchar(max)
go
alter table c_Component_Log alter column error_message nvarchar(max)
go
alter table c_Component_Param alter column helptext nvarchar(max)
go
alter table c_Component_Param alter column query nvarchar(max)
go
alter table c_Component_Param_Class alter column Instructions nvarchar(max)
go
alter table c_Component_Registry alter column component_install varbinary(max)
go
alter table c_Component_Version alter column notes nvarchar(max)
go
alter table c_Component_Version alter column objectdata varbinary(max)
go
alter table c_Component_Version alter column version_description nvarchar(max)
go
alter table c_Config_Object alter column long_description nvarchar(max)
go
alter table c_Config_Object_Library alter column long_description nvarchar(max)
go
alter table c_Config_Object_Version alter column objectdata varbinary(max)
go
alter table c_Config_Object_Version alter column version_description nvarchar(max)
go
alter table c_CPT_Updates alter column from_long_desc nvarchar(max)
go
alter table c_CPT_Updates alter column long_description nvarchar(max)
go
alter table c_Database_Script alter column comment nvarchar(max)
go
alter table c_Database_Script alter column db_script nvarchar(max)
go
alter table c_Database_Script_Log alter column db_script nvarchar(max)
go
alter table c_Database_Table alter column create_script nvarchar(max)
go
alter table c_Database_Table alter column index_script nvarchar(max)
go
alter table c_Database_Table alter column trigger_script nvarchar(max)
go
alter table c_Display_Command_Definition alter column command_help nvarchar(max)
go
alter table c_Display_Script alter column example nvarchar(max)
go
alter table c_Display_Script_Cmd_Attribute alter column long_value nvarchar(max)
go
alter table c_Document_Type alter column SampleDocument nvarchar(max)
go
alter table c_Domain_Master alter column param_query nvarchar(max)
go
alter table c_Drug_Instruction alter column instruction nvarchar(max)
go
alter table c_Epro_Object alter column base_table_query nvarchar(max)
go
alter table c_ICD_Code alter column long_description nvarchar(max)
go
alter table c_ICD_Properties alter column long_description nvarchar(max)
go
alter table c_ICD_Updates alter column long_description nvarchar(max)
go
alter table c_Message_Part alter column part_query nvarchar(max)
go
alter table c_Observation alter column legal_notice nvarchar(max)
go
alter table c_Observation alter column narrative_phrase nvarchar(max)
go
alter table c_Patient_material alter column object varbinary(max)
go
alter table c_Preference alter column change_script nvarchar(max)
go
alter table c_Preference alter column help nvarchar(max)
go
alter table c_Preference alter column query nvarchar(max)
go
alter table c_Procedure alter column long_description nvarchar(max)
go
alter table c_Property alter column property_value_object_cat_query nvarchar(max)
go
alter table c_Property alter column script nvarchar(max)
go
alter table c_Report_Attribute alter column objectdata varbinary(max)
go
alter table c_Report_Definition alter column example varbinary(max)
go
alter table c_Report_Definition alter column long_description nvarchar(max)
go
alter table c_Report_Definition alter column sql nvarchar(max)
go
alter table c_Report_Definition alter column template varbinary(max)
go
alter table c_Report_Params alter column helptext nvarchar(max)
go
alter table c_Report_Params alter column query nvarchar(max)
go
alter table c_Risk_Factor alter column comments nvarchar(max)
go
alter table c_User alter column signature_stamp varbinary(max)
go
alter table c_User_Progress alter column progress nvarchar(max)
go
alter table o_Event_Component_Attribute alter column value nvarchar(max)
go
alter table o_Event_Queue_Attribute alter column value nvarchar(max)
go
alter table o_Log alter column log_data nvarchar(max)
go
alter table o_Message_Log alter column message varbinary(max)
go
alter table p_assessment_Progress alter column progress nvarchar(max)
go
alter table p_Attachment alter column attachment_image varbinary(max)
go
alter table p_Attachment alter column attachment_text nvarchar(max)
go
alter table p_Attachment_Progress alter column attachment_image varbinary(max)
go
alter table p_Attachment_Progress alter column progress nvarchar(max)
go
alter table p_Chart_Alert alter column alert_text nvarchar(max)
go
alter table p_Chart_Alert_Progress alter column progress nvarchar(max)
go
alter table p_Family_History alter column comment nvarchar(max)
go
alter table p_Family_Illness alter column comment nvarchar(max)
go
alter table p_Observation_Comment_Save alter column comment nvarchar(max)
go
alter table p_Observation_Result alter column long_result_value nvarchar(max)
go
alter table p_Observation_Result_Progress alter column progress nvarchar(max)
go
alter table p_Patient_Encounter alter column billing_note nvarchar(max)
go
alter table p_Patient_Encounter_Progress alter column progress nvarchar(max)
go
alter table p_Patient_Progress alter column progress nvarchar(max)
go
alter table p_Patient_WP_Item_Attribute alter column message nvarchar(max)
go
alter table p_Patient_WP_Item_Attribute_Archive alter column message nvarchar(max)
go
alter table p_Treatment_Progress alter column progress nvarchar(max)
go
alter table u_assessment_treat_def_attrib alter column long_value nvarchar(max)
go
alter table u_Exam_Default_Results alter column long_result_value nvarchar(max)
go
alter table u_Top_20 alter column item_text_long nvarchar(max)
go
alter table x_External_Application alter column notes nvarchar(max)
go
alter table x_External_Application_Message alter column notes nvarchar(max)
go
alter table x_Message_Type alter column documentation nvarchar(max)
go
alter table x_Message_Type alter column [schema] nvarchar(max)
go
alter table x_Property_Exception alter column property_value_binary varbinary(max)
go
alter table x_Property_Exception alter column property_value_text nvarchar(max)

-- alter table trace-displayscript alter column BinaryData varbinary(max)

-- Because o_Log is used in the upgrade process, we need to close out 
-- the transaction now and begin a new one

commit transaction
begin transaction



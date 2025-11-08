/* tables
select object_name(c.object_id), * from sys.columns c
join sys.tables t on t.object_id = c.object_id
where (c.name like '%_by' or c.name like '%user%')
and max_length = 24
*/
/* functions, table types
select distinct object_name(c.object_id), c.* from sys.columns c
left join sys.tables t on t.object_id = c.object_id
where (c.name like '%_by' or c.name like '%user%')
and max_length = 24
and t.name is null

-- function return types

select ROUTINE_NAME from INFORMATION_SCHEMA.ROUTINES 
where ROUTINE_TYPE = 'FUNCTION'
and DATA_TYPE = 'varchar'
and CHARACTER_MAXIMUM_LENGTH = 24
and (ROUTINE_NAME like '%_by' or ROUTINE_NAME like '%user%')
order by 1

select * from sys.objects where name = 'TT_tab_p_Patient_WP_Item_Progress_36B12243'
*/



/*
select  'ALTER TABLE ' + t.name + ' ALTER COLUMN ' + c.name + ' varchar(255) ' 
	+ case when c.is_nullable = 0 then 'NOT NULL ' ELSE 'NULL '  END 
from sys.columns c
join sys.tables t on t.object_id = c.object_id
where (c.name like '%_by' or c.name like '%user%')
and max_length = 24
order by t.name, c.name
*/

ALTER TABLE b_Resource ALTER COLUMN user_id varchar(255) NULL 
ALTER TABLE c_Actor_Address ALTER COLUMN created_by varchar(255) NULL 
ALTER TABLE c_Actor_Communication ALTER COLUMN created_by varchar(255) NULL 
ALTER TABLE c_Actor_Route_Purpose ALTER COLUMN created_by varchar(255) NULL 
ALTER TABLE c_Chart_Section ALTER COLUMN user_id varchar(255) NULL 
ALTER TABLE c_Chart_Section_Page_Attribute ALTER COLUMN user_id varchar(255) NULL 
ALTER TABLE c_Classification_Set ALTER COLUMN created_by varchar(255) NOT NULL 
ALTER TABLE c_Classification_Set_Item ALTER COLUMN created_by varchar(255) NOT NULL 
ALTER TABLE c_Component_Log ALTER COLUMN created_by varchar(255) NOT NULL 
ALTER TABLE c_Component_Version ALTER COLUMN created_by varchar(255) NOT NULL 
ALTER TABLE c_Config_Log ALTER COLUMN performed_by varchar(255) NOT NULL 
ALTER TABLE c_Config_Object ALTER COLUMN checked_out_by varchar(255) NULL 
ALTER TABLE c_Config_Object ALTER COLUMN created_by varchar(255) NOT NULL 
ALTER TABLE c_Config_Object_Library ALTER COLUMN created_by varchar(255) NOT NULL 
ALTER TABLE c_Config_Object_Type ALTER COLUMN created_by varchar(255) NOT NULL 
ALTER TABLE c_Config_Object_Version ALTER COLUMN checked_out_by varchar(255) NULL 
ALTER TABLE c_Config_Object_Version ALTER COLUMN created_by varchar(255) NOT NULL 
ALTER TABLE c_Display_Script ALTER COLUMN updated_by varchar(255) NULL 
ALTER TABLE c_Document_Purpose ALTER COLUMN created_by varchar(255) NOT NULL 
ALTER TABLE c_Domain_Master ALTER COLUMN created_by varchar(255) NOT NULL 
ALTER TABLE c_Encounter_Type ALTER COLUMN created_by varchar(255) NULL 
ALTER TABLE c_Equivalence ALTER COLUMN created_by varchar(255) NULL 
ALTER TABLE c_Equivalence_Group ALTER COLUMN created_by varchar(255) NULL 
ALTER TABLE c_Folder_Workplan ALTER COLUMN owned_by varchar(255) NULL 
ALTER TABLE c_Maintenance_Metric ALTER COLUMN created_by varchar(255) NOT NULL 
ALTER TABLE c_Maintenance_Policy ALTER COLUMN created_by varchar(255) NOT NULL 
ALTER TABLE c_Maintenance_Protocol ALTER COLUMN created_by varchar(255) NOT NULL 
ALTER TABLE c_Maintenance_Protocol_Item ALTER COLUMN created_by varchar(255) NOT NULL 
ALTER TABLE c_Maintenance_Treatment ALTER COLUMN created_by varchar(255) NOT NULL 
ALTER TABLE c_Menu_Item ALTER COLUMN authorized_user_id varchar(255) NULL 
ALTER TABLE c_Observation ALTER COLUMN updated_by varchar(255) NULL 
ALTER TABLE c_Observation_Result ALTER COLUMN updated_by varchar(255) NULL 
ALTER TABLE c_Observation_Result_Range ALTER COLUMN ordered_by varchar(255) NULL 
ALTER TABLE c_Observation_Stage ALTER COLUMN updated_by varchar(255) NULL 
ALTER TABLE c_Observation_Tree ALTER COLUMN updated_by varchar(255) NULL 
ALTER TABLE c_Owner ALTER COLUMN created_by varchar(255) NOT NULL 
ALTER TABLE c_Patient_material ALTER COLUMN created_by varchar(255) NULL 
ALTER TABLE c_Privilege ALTER COLUMN created_by varchar(255) NOT NULL 
ALTER TABLE c_Query_Term ALTER COLUMN user_query_term varchar(255) NOT NULL 
ALTER TABLE c_Report_Definition ALTER COLUMN created_by varchar(255) NULL 
ALTER TABLE c_Table_Update ALTER COLUMN updated_by varchar(255) NULL 
ALTER TABLE c_Treatment_Type_Service ALTER COLUMN user_id varchar(255) NULL 
ALTER TABLE c_User ALTER COLUMN created_by varchar(255) NULL 
ALTER TABLE c_User ALTER COLUMN modified_by varchar(255) NULL 
ALTER TABLE c_User ALTER COLUMN parent_actor_user_id varchar(255) NULL 
ALTER TABLE c_User ALTER COLUMN supervisor_user_id varchar(255) NULL 
ALTER TABLE c_User ALTER COLUMN user_id varchar(255) NOT NULL 
ALTER TABLE c_User_Progress ALTER COLUMN created_by varchar(255) NOT NULL 
ALTER TABLE c_User_Progress ALTER COLUMN progress_user_id varchar(255) NOT NULL 
ALTER TABLE c_User_Progress ALTER COLUMN user_id varchar(255) NOT NULL 
ALTER TABLE c_User_Role ALTER COLUMN user_id varchar(255) NOT NULL 
ALTER TABLE c_XML_Class ALTER COLUMN created_by varchar(255) NULL 
ALTER TABLE c_XML_Class_Selection ALTER COLUMN created_by varchar(255) NULL 
ALTER TABLE c_XML_Code ALTER COLUMN created_by varchar(255) NOT NULL 
ALTER TABLE c_XML_Code_Domain ALTER COLUMN created_by varchar(255) NOT NULL 
ALTER TABLE c_XML_Code_Domain_Item ALTER COLUMN created_by varchar(255) NOT NULL 
ALTER TABLE o_Active_Services ALTER COLUMN ordered_by varchar(255) NOT NULL 
ALTER TABLE o_Active_Services ALTER COLUMN owned_by varchar(255) NULL 
ALTER TABLE o_Active_Services ALTER COLUMN user_id varchar(255) NULL 
ALTER TABLE o_Component_Selection ALTER COLUMN created_by varchar(255) NOT NULL 
ALTER TABLE o_Log ALTER COLUMN scribe_user_id varchar(255) NULL 
ALTER TABLE o_Log ALTER COLUMN user_id varchar(255) NULL 
ALTER TABLE o_menu_selection ALTER COLUMN user_id varchar(255) NULL 
ALTER TABLE o_Server_Component ALTER COLUMN system_user_id varchar(255) NULL 
ALTER TABLE o_Service_Attribute ALTER COLUMN user_id varchar(255) NULL 
ALTER TABLE o_Service_Schedule ALTER COLUMN created_by varchar(255) NOT NULL 
ALTER TABLE o_Service_Schedule ALTER COLUMN user_id varchar(255) NOT NULL 
ALTER TABLE o_Service_Schedule_Attribute ALTER COLUMN user_id varchar(255) NOT NULL 
ALTER TABLE o_Treatment_Type_Default_Mode ALTER COLUMN created_by varchar(255) NOT NULL 
ALTER TABLE o_User_Logins ALTER COLUMN action_for_user_id varchar(255) NULL 
ALTER TABLE o_User_Logins ALTER COLUMN scribe_for_user_id varchar(255) NULL 
ALTER TABLE o_User_Logins ALTER COLUMN user_id varchar(255) NOT NULL 
ALTER TABLE o_User_Privilege ALTER COLUMN created_by varchar(255) NOT NULL 
ALTER TABLE o_User_Privilege ALTER COLUMN user_id varchar(255) NOT NULL 
ALTER TABLE o_User_Service ALTER COLUMN created_by varchar(255) NOT NULL 
ALTER TABLE o_User_Service ALTER COLUMN user_id varchar(255) NOT NULL 
ALTER TABLE o_User_Service_Lock ALTER COLUMN user_id varchar(255) NOT NULL 
ALTER TABLE o_Users ALTER COLUMN scribe_for_user_id varchar(255) NULL 
ALTER TABLE o_Users ALTER COLUMN user_id varchar(255) NOT NULL 
ALTER TABLE p_Assessment ALTER COLUMN created_by varchar(255) NULL 
ALTER TABLE p_Assessment ALTER COLUMN diagnosed_by varchar(255) NULL 
ALTER TABLE p_assessment_Progress ALTER COLUMN created_by varchar(255) NULL 
ALTER TABLE p_assessment_Progress ALTER COLUMN user_id varchar(255) NOT NULL 
ALTER TABLE p_Assessment_Treatment ALTER COLUMN created_by varchar(255) NULL 
ALTER TABLE p_Attachment ALTER COLUMN attached_by varchar(255) NULL 
ALTER TABLE p_Attachment ALTER COLUMN created_by varchar(255) NULL 
ALTER TABLE p_Attachment_Progress ALTER COLUMN created_by varchar(255) NULL 
ALTER TABLE p_Attachment_Progress ALTER COLUMN user_id varchar(255) NOT NULL 
ALTER TABLE p_Chart_Alert ALTER COLUMN created_by varchar(255) NULL 
ALTER TABLE p_Chart_Alert ALTER COLUMN ordered_by varchar(255) NULL 
ALTER TABLE p_Chart_Alert_Progress ALTER COLUMN created_by varchar(255) NULL 
ALTER TABLE p_Chart_Alert_Progress ALTER COLUMN user_id varchar(255) NULL 
ALTER TABLE p_Classification_Set_Item ALTER COLUMN created_by varchar(255) NOT NULL 
ALTER TABLE p_Encounter_Assessment ALTER COLUMN created_by varchar(255) NULL 
ALTER TABLE p_Encounter_Assessment_Charge ALTER COLUMN created_by varchar(255) NULL 
ALTER TABLE p_Encounter_Charge ALTER COLUMN created_by varchar(255) NULL 
ALTER TABLE p_Encounter_Charge ALTER COLUMN last_updated_by varchar(255) NULL 
ALTER TABLE p_Family_History ALTER COLUMN created_by varchar(255) NULL 
ALTER TABLE p_Family_Illness ALTER COLUMN created_by varchar(255) NULL 
ALTER TABLE p_Letter ALTER COLUMN created_by varchar(255) NULL 
ALTER TABLE p_Material_Used ALTER COLUMN created_by varchar(255) NULL 
ALTER TABLE p_Object_Security ALTER COLUMN created_by varchar(255) NULL 
ALTER TABLE p_Object_Security ALTER COLUMN user_id varchar(255) NOT NULL 
ALTER TABLE p_Objective_Location ALTER COLUMN created_by varchar(255) NOT NULL 
ALTER TABLE p_Observation ALTER COLUMN created_by varchar(255) NULL 
ALTER TABLE p_Observation ALTER COLUMN observed_by varchar(255) NULL 
ALTER TABLE p_Observation_Comment_Save ALTER COLUMN created_by varchar(255) NOT NULL 
ALTER TABLE p_Observation_Comment_Save ALTER COLUMN user_id varchar(255) NOT NULL 
ALTER TABLE p_Observation_Location ALTER COLUMN created_by varchar(255) NOT NULL 
ALTER TABLE p_Observation_Result ALTER COLUMN created_by varchar(255) NULL 
ALTER TABLE p_Observation_Result ALTER COLUMN observed_by varchar(255) NULL 
ALTER TABLE p_Observation_Result_Progress ALTER COLUMN created_by varchar(255) NOT NULL 
ALTER TABLE p_Observation_Result_Progress ALTER COLUMN user_id varchar(255) NOT NULL 
ALTER TABLE p_Observation_Result_Qualifier ALTER COLUMN created_by varchar(255) NULL 
ALTER TABLE p_Patient ALTER COLUMN created_by varchar(255) NULL 
ALTER TABLE p_Patient ALTER COLUMN locked_by varchar(255) NULL 
ALTER TABLE p_Patient ALTER COLUMN modified_by varchar(255) NULL 
ALTER TABLE p_Patient_Alias ALTER COLUMN created_by varchar(255) NOT NULL 
ALTER TABLE p_Patient_Authority ALTER COLUMN created_by varchar(255) NULL 
ALTER TABLE p_Patient_Authority ALTER COLUMN modified_by varchar(255) NULL 
ALTER TABLE p_Patient_Encounter ALTER COLUMN created_by varchar(255) NULL 
ALTER TABLE p_Patient_Encounter_Progress ALTER COLUMN created_by varchar(255) NOT NULL 
ALTER TABLE p_Patient_Encounter_Progress ALTER COLUMN user_id varchar(255) NOT NULL 
ALTER TABLE p_Patient_Guarantor ALTER COLUMN created_by varchar(255) NOT NULL 
ALTER TABLE p_Patient_Guarantor ALTER COLUMN modified_by varchar(255) NULL 
ALTER TABLE p_Patient_Guarantor ALTER COLUMN status_changed_by varchar(255) NULL 
ALTER TABLE p_Patient_Progress ALTER COLUMN created_by varchar(255) NOT NULL 
ALTER TABLE p_Patient_Progress ALTER COLUMN user_id varchar(255) NOT NULL 
ALTER TABLE p_Patient_Relation ALTER COLUMN created_by varchar(255) NOT NULL 
ALTER TABLE p_Patient_Relation ALTER COLUMN modified_by varchar(255) NULL 
ALTER TABLE p_Patient_WP ALTER COLUMN created_by varchar(255) NOT NULL 
ALTER TABLE p_Patient_WP ALTER COLUMN ordered_by varchar(255) NOT NULL 
ALTER TABLE p_Patient_WP ALTER COLUMN owned_by varchar(255) NULL 
ALTER TABLE p_Patient_WP_Archive ALTER COLUMN created_by varchar(255) NOT NULL 
ALTER TABLE p_Patient_WP_Archive ALTER COLUMN ordered_by varchar(255) NOT NULL 
ALTER TABLE p_Patient_WP_Archive ALTER COLUMN owned_by varchar(255) NULL 
ALTER TABLE p_Patient_WP_Item ALTER COLUMN completed_by varchar(255) NULL 
ALTER TABLE p_Patient_WP_Item ALTER COLUMN created_by varchar(255) NOT NULL 
ALTER TABLE p_Patient_WP_Item ALTER COLUMN ordered_by varchar(255) NOT NULL 
ALTER TABLE p_Patient_WP_Item ALTER COLUMN owned_by varchar(255) NULL 
ALTER TABLE p_Patient_WP_Item_Archive ALTER COLUMN completed_by varchar(255) NULL 
ALTER TABLE p_Patient_WP_Item_Archive ALTER COLUMN created_by varchar(255) NOT NULL 
ALTER TABLE p_Patient_WP_Item_Archive ALTER COLUMN ordered_by varchar(255) NOT NULL 
ALTER TABLE p_Patient_WP_Item_Archive ALTER COLUMN owned_by varchar(255) NULL 
ALTER TABLE p_Patient_WP_Item_Attribute ALTER COLUMN created_by varchar(255) NOT NULL 
ALTER TABLE p_Patient_WP_Item_Attribute_Archive ALTER COLUMN created_by varchar(255) NOT NULL 
ALTER TABLE p_Patient_WP_Item_Progress ALTER COLUMN created_by varchar(255) NOT NULL 
ALTER TABLE p_Patient_WP_Item_Progress ALTER COLUMN user_id varchar(255) NOT NULL 
ALTER TABLE p_Patient_WP_Item_Progress_Archive ALTER COLUMN created_by varchar(255) NOT NULL 
ALTER TABLE p_Patient_WP_Item_Progress_Archive ALTER COLUMN user_id varchar(255) NOT NULL 
ALTER TABLE p_Treatment_Item ALTER COLUMN completed_by varchar(255) NULL 
ALTER TABLE p_Treatment_Item ALTER COLUMN created_by varchar(255) NULL 
ALTER TABLE p_Treatment_Item ALTER COLUMN ordered_by varchar(255) NULL 
ALTER TABLE p_Treatment_Progress ALTER COLUMN created_by varchar(255) NULL 
ALTER TABLE p_Treatment_Progress ALTER COLUMN user_id varchar(255) NOT NULL 
ALTER TABLE u_assessment_treat_definition ALTER COLUMN user_id varchar(255) NULL 
ALTER TABLE u_Chart_Selection ALTER COLUMN user_id varchar(255) NULL 
ALTER TABLE u_Display_Format_Selection ALTER COLUMN user_id varchar(255) NULL 
ALTER TABLE u_Display_Script_Selection ALTER COLUMN user_id varchar(255) NULL 
ALTER TABLE u_Exam_Default_Results ALTER COLUMN user_id varchar(255) NOT NULL 
ALTER TABLE u_Exam_Selection ALTER COLUMN user_id varchar(255) NOT NULL 
ALTER TABLE u_Top_20 ALTER COLUMN user_id varchar(255) NOT NULL 
ALTER TABLE x_External_Application ALTER COLUMN created_by varchar(255) NOT NULL 
ALTER TABLE x_External_Application_Message ALTER COLUMN created_by varchar(255) NOT NULL 
ALTER TABLE x_Integration_Operation ALTER COLUMN created_by varchar(255) NOT NULL 
ALTER TABLE x_Integration_Operation_Tree ALTER COLUMN created_by varchar(255) NOT NULL 
ALTER TABLE x_Message_Type ALTER COLUMN created_by varchar(255) NOT NULL 
ALTER TABLE x_Performance_Log ALTER COLUMN user_id varchar(255) NOT NULL 
ALTER TABLE x_Translate_A ALTER COLUMN created_by varchar(255) NULL 
ALTER TABLE x_Translate_P ALTER COLUMN created_by varchar(255) NOT NULL 
ALTER TABLE x_Translation_Rule ALTER COLUMN created_by varchar(255) NOT NULL 
ALTER TABLE x_Translation_Set ALTER COLUMN created_by varchar(255) NOT NULL 
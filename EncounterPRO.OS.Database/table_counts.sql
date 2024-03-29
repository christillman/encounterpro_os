select 'select ''' + name + ''', count(*) from ' + name + ' union '
from sys.tables where type = 'U' 
order by name

create table #tabs (name varchar(100), cnt int)

insert into #tabs (name , cnt )
select 'b_Appointment_Type', count(*) from b_Appointment_Type union 
select 'b_Provider_Translation', count(*) from b_Provider_Translation union 
select 'b_Resource', count(*) from b_Resource union 
select 'c_1_record', count(*) from c_1_record union 
select 'c_Actor_Address', count(*) from c_Actor_Address union 
select 'c_Actor_Class', count(*) from c_Actor_Class union 
select 'c_Actor_Class_Purpose', count(*) from c_Actor_Class_Purpose union 
select 'c_Actor_Class_Route', count(*) from c_Actor_Class_Route union 
select 'c_Actor_Class_Type', count(*) from c_Actor_Class_Type union 
select 'c_Actor_Communication', count(*) from c_Actor_Communication union 
select 'c_Actor_Route_Purpose', count(*) from c_Actor_Route_Purpose union 
select 'c_Administration_Frequency', count(*) from c_Administration_Frequency union 
select 'c_Administration_Method', count(*) from c_Administration_Method union 
select 'c_Administration_Method_Proc', count(*) from c_Administration_Method_Proc union 
select 'c_Adverse_Reaction_Drug', count(*) from c_Adverse_Reaction_Drug union 
select 'c_Adverse_Reaction_Drug_Class', count(*) from c_Adverse_Reaction_Drug_Class union 
select 'c_Age_Range', count(*) from c_Age_Range union 
select 'c_Age_Range_Assessment', count(*) from c_Age_Range_Assessment union 
select 'c_Age_Range_Category', count(*) from c_Age_Range_Category union 
select 'c_Age_Range_Procedure', count(*) from c_Age_Range_Procedure union 
select 'c_Allergen', count(*) from c_Allergen union 
select 'c_Allergen_Drug', count(*) from c_Allergen_Drug union 
select 'c_Allergen_Drug_Class', count(*) from c_Allergen_Drug_Class union 
select 'c_Allergens', count(*) from c_Allergens union 
select 'c_Allergy_Drug', count(*) from c_Allergy_Drug union 
select 'c_Assessment_Category', count(*) from c_Assessment_Category union 
select 'c_Assessment_Coding', count(*) from c_Assessment_Coding union 
select 'c_Assessment_Definition', count(*) from c_Assessment_Definition union 
select 'c_Assessment_Type', count(*) from c_Assessment_Type union 
select 'c_Assessment_Type_Progress_Key', count(*) from c_Assessment_Type_Progress_Key union 
select 'c_Assessment_Type_Progress_Type', count(*) from c_Assessment_Type_Progress_Type union 
select 'c_Attachment_Extension', count(*) from c_Attachment_Extension union 
select 'c_Attachment_Extension_Attribute', count(*) from c_Attachment_Extension_Attribute union 
select 'c_Attachment_Location', count(*) from c_Attachment_Location union 
select 'c_Attachment_Type', count(*) from c_Attachment_Type union 
select 'c_Authority', count(*) from c_Authority union 
select 'c_Authority_Category', count(*) from c_Authority_Category union 
select 'c_Authority_Formulary', count(*) from c_Authority_Formulary union 
select 'c_Authority_Type', count(*) from c_Authority_Type union 
select 'c_Cdc_BmiAge', count(*) from c_Cdc_BmiAge union 
select 'c_Cdc_HcAgeInf', count(*) from c_Cdc_HcAgeInf union 
select 'c_Cdc_LenAgeInf', count(*) from c_Cdc_LenAgeInf union 
select 'c_Cdc_StatAge', count(*) from c_Cdc_StatAge union 
select 'c_Cdc_WtAge', count(*) from c_Cdc_WtAge union 
select 'c_Cdc_WtAgeInf', count(*) from c_Cdc_WtAgeInf union 
select 'c_Cdc_WtLenInf', count(*) from c_Cdc_WtLenInf union 
select 'c_Cdc_WtStat', count(*) from c_Cdc_WtStat union 
select 'c_Chart', count(*) from c_Chart union 
select 'c_Chart_Alert_Category', count(*) from c_Chart_Alert_Category union 
select 'c_Chart_Page_Attribute', count(*) from c_Chart_Page_Attribute union 
select 'c_Chart_Page_Definition', count(*) from c_Chart_Page_Definition union 
select 'c_Chart_Section', count(*) from c_Chart_Section union 
select 'c_Chart_Section_Page', count(*) from c_Chart_Section_Page union 
select 'c_Chart_Section_Page_Attribute', count(*) from c_Chart_Section_Page_Attribute union 
select 'c_Classification_Set', count(*) from c_Classification_Set union 
select 'c_Classification_Set_Item', count(*) from c_Classification_Set_Item union 
select 'c_Common_Assessment', count(*) from c_Common_Assessment union 
select 'c_Common_Drug', count(*) from c_Common_Drug union 
select 'c_Common_Observation', count(*) from c_Common_Observation union 
select 'c_Common_Procedure', count(*) from c_Common_Procedure union 
select 'c_Component', count(*) from c_Component union 
select 'c_Component_Attribute', count(*) from c_Component_Attribute union 
select 'c_Component_Attribute_Def', count(*) from c_Component_Attribute_Def union 
select 'c_Component_Base_Attribute', count(*) from c_Component_Base_Attribute union 
select 'c_Component_Base_Attribute_Def', count(*) from c_Component_Base_Attribute_Def union 
select 'c_Component_Definition', count(*) from c_Component_Definition union 
select 'c_Component_Interface', count(*) from c_Component_Interface union 
select 'c_component_interface_object_log', count(*) from c_component_interface_object_log union 
select 'c_component_interface_route', count(*) from c_component_interface_route union 
select 'c_component_interface_route_property', count(*) from c_component_interface_route_property union 
select 'c_Component_Log', count(*) from c_Component_Log union 
select 'c_Component_Param', count(*) from c_Component_Param union 
select 'c_Component_Param_Class', count(*) from c_Component_Param_Class union 
select 'c_Component_Registry', count(*) from c_Component_Registry union 
select 'c_Component_Type', count(*) from c_Component_Type union 
select 'c_Component_Version', count(*) from c_Component_Version union 
select 'c_Config_Log', count(*) from c_Config_Log union 
select 'c_Config_Object', count(*) from c_Config_Object union 
select 'c_Config_Object_Category', count(*) from c_Config_Object_Category union 
select 'c_Config_Object_Library', count(*) from c_Config_Object_Library union 
select 'c_Config_Object_Type', count(*) from c_Config_Object_Type union 
select 'c_Config_Object_Version', count(*) from c_Config_Object_Version union 
select 'c_Consultant', count(*) from c_Consultant union 
select 'c_CPT_Updates', count(*) from c_CPT_Updates union 
select 'c_Database_Column', count(*) from c_Database_Column union 
select 'c_Database_Maintenance', count(*) from c_Database_Maintenance union 
select 'c_Database_Modification_Dependancy', count(*) from c_Database_Modification_Dependancy union 
select 'c_Database_Script', count(*) from c_Database_Script union 
select 'c_Database_Script_Log', count(*) from c_Database_Script_Log union 
select 'c_Database_Script_Type', count(*) from c_Database_Script_Type union 
select 'c_Database_Status', count(*) from c_Database_Status union 
select 'c_Database_System', count(*) from c_Database_System union 
select 'c_Database_Table', count(*) from c_Database_Table union 
select 'c_Disease', count(*) from c_Disease union 
select 'c_Disease_Assessment', count(*) from c_Disease_Assessment union 
select 'c_Disease_Group', count(*) from c_Disease_Group union 
select 'c_Disease_Group_Item', count(*) from c_Disease_Group_Item union 
select 'c_Display_Command_Definition', count(*) from c_Display_Command_Definition union 
select 'c_Display_Format', count(*) from c_Display_Format union 
select 'c_Display_Format_Item', count(*) from c_Display_Format_Item union 
select 'c_Display_Script', count(*) from c_Display_Script union 
select 'c_Display_Script_Cmd_Attribute', count(*) from c_Display_Script_Cmd_Attribute union 
select 'c_Display_Script_Command', count(*) from c_Display_Script_Command union 
select 'c_Document_Purpose', count(*) from c_Document_Purpose union 
select 'c_Document_Route', count(*) from c_Document_Route union 
select 'c_Document_Type', count(*) from c_Document_Type union 
select 'c_Domain', count(*) from c_Domain union 
select 'c_Domain_Master', count(*) from c_Domain_Master union 
select 'c_Dosage_Form', count(*) from c_Dosage_Form union 
select 'c_Drug_Administration', count(*) from c_Drug_Administration union 
select 'c_Drug_Brand', count(*) from c_Drug_Brand union 
select 'c_Drug_Brand_Ingredient', count(*) from c_Drug_Brand_Ingredient union 
select 'c_Drug_Category', count(*) from c_Drug_Category union 
select 'c_Drug_Compound', count(*) from c_Drug_Compound union 
select 'c_Drug_Definition', count(*) from c_Drug_Definition union 
select 'c_Drug_Drug_Category', count(*) from c_Drug_Drug_Category union 
select 'c_Drug_Generic', count(*) from c_Drug_Generic union 
select 'c_Drug_Generic_Ingredient', count(*) from c_Drug_Generic_Ingredient union 
select 'c_Drug_HCPCS', count(*) from c_Drug_HCPCS union 
select 'c_Drug_Instruction', count(*) from c_Drug_Instruction union 
select 'c_Drug_Interaction', count(*) from c_Drug_Interaction union 
select 'c_Drug_Interaction_Class', count(*) from c_Drug_Interaction_Class union 
select 'c_Drug_Maker', count(*) from c_Drug_Maker union 
select 'c_Drug_Package', count(*) from c_Drug_Package union 
select 'c_Drug_Package_Dispense', count(*) from c_Drug_Package_Dispense union 
select 'c_Drug_Type', count(*) from c_Drug_Type union 
select 'c_Encounter_Procedure', count(*) from c_Encounter_Procedure union 
select 'c_Encounter_Type', count(*) from c_Encounter_Type union 
select 'c_Encounter_Type_Progress_Key', count(*) from c_Encounter_Type_Progress_Key union 
select 'c_Encounter_Type_Progress_Type', count(*) from c_Encounter_Type_Progress_Type union 
select 'c_Epro_Object', count(*) from c_Epro_Object union 
select 'c_Equivalence', count(*) from c_Equivalence union 
select 'c_Equivalence_Group', count(*) from c_Equivalence_Group union 
select 'c_Event', count(*) from c_Event union 
select 'c_External_Observation', count(*) from c_External_Observation union 
select 'c_External_Observation_Location', count(*) from c_External_Observation_Location union 
select 'c_External_Observation_Result', count(*) from c_External_Observation_Result union 
select 'c_External_Source', count(*) from c_External_Source union 
select 'c_External_Source_Attribute', count(*) from c_External_Source_Attribute union 
select 'c_External_Source_Type', count(*) from c_External_Source_Type union 
select 'c_Folder', count(*) from c_Folder union 
select 'c_Folder_Attribute', count(*) from c_Folder_Attribute union 
select 'c_Folder_Selection', count(*) from c_Folder_Selection union 
select 'c_Folder_Workplan', count(*) from c_Folder_Workplan union 
select 'c_Formulary', count(*) from c_Formulary union 
select 'c_Formulary_Type', count(*) from c_Formulary_Type union 
select 'c_Growth_Data', count(*) from c_Growth_Data union 
select 'c_ICD_Code', count(*) from c_ICD_Code union 
select 'c_ICD_Properties', count(*) from c_ICD_Properties union 
select 'c_ICD_Updates', count(*) from c_ICD_Updates union 
select 'c_Immunization_Dose_Schedule', count(*) from c_Immunization_Dose_Schedule union 
select 'c_Immunization_Schedule', count(*) from c_Immunization_Schedule union 
select 'c_List_Item', count(*) from c_List_Item union 
select 'c_Location', count(*) from c_Location union 
select 'c_Location_Domain', count(*) from c_Location_Domain union 
select 'c_Maintenance_Assessment', count(*) from c_Maintenance_Assessment union 
select 'c_Maintenance_Metric', count(*) from c_Maintenance_Metric union 
select 'c_Maintenance_Patient_Class', count(*) from c_Maintenance_Patient_Class union 
select 'c_Maintenance_Policy', count(*) from c_Maintenance_Policy union 
select 'c_Maintenance_Procedure', count(*) from c_Maintenance_Procedure union 
select 'c_Maintenance_Protocol', count(*) from c_Maintenance_Protocol union 
select 'c_Maintenance_Protocol_Item', count(*) from c_Maintenance_Protocol_Item union 
select 'c_Maintenance_Treatment', count(*) from c_Maintenance_Treatment union 
select 'c_Material', count(*) from c_Material union 
select 'c_Material_Item', count(*) from c_Material_Item union 
select 'c_Menu', count(*) from c_Menu union 
select 'c_Menu_Item', count(*) from c_Menu_Item union 
select 'c_Menu_Item_Attribute', count(*) from c_Menu_Item_Attribute union 
select 'c_Message_Definition', count(*) from c_Message_Definition union 
select 'c_Message_Fkey', count(*) from c_Message_Fkey union 
select 'c_Message_Part', count(*) from c_Message_Part union 
select 'c_Message_Stream', count(*) from c_Message_Stream union 
select 'c_Nomenclature_Medcin', count(*) from c_Nomenclature_Medcin union 
select 'c_Object_Default_Progress_Type', count(*) from c_Object_Default_Progress_Type union 
select 'c_Observation', count(*) from c_Observation union 
select 'c_Observation_Category', count(*) from c_Observation_Category union 
select 'c_Observation_Observation_Cat', count(*) from c_Observation_Observation_Cat union 
select 'c_Observation_Result', count(*) from c_Observation_Result union 
select 'c_Observation_Result_Qualifier', count(*) from c_Observation_Result_Qualifier union 
select 'c_Observation_Result_Range', count(*) from c_Observation_Result_Range union 
select 'c_Observation_Result_Set', count(*) from c_Observation_Result_Set union 
select 'c_Observation_Result_Set_Item', count(*) from c_Observation_Result_Set_Item union 
select 'c_Observation_Stage', count(*) from c_Observation_Stage union 
select 'c_Observation_Treatment_Type', count(*) from c_Observation_Treatment_Type union 
select 'c_Observation_Tree', count(*) from c_Observation_Tree union 
select 'c_Observation_Tree_Root', count(*) from c_Observation_Tree_Root union 
select 'c_Observation_Type', count(*) from c_Observation_Type union 
select 'c_Office', count(*) from c_Office union 
select 'c_Owner', count(*) from c_Owner union 
select 'c_Package', count(*) from c_Package union 
select 'c_Patient_material', count(*) from c_Patient_material union 
select 'c_Patient_material_category', count(*) from c_Patient_material_category union 
select 'c_Preference', count(*) from c_Preference union 
select 'c_Preference_Type', count(*) from c_Preference_Type union 
select 'c_Preferred_Provider', count(*) from c_Preferred_Provider union 
select 'c_Prescription_Format', count(*) from c_Prescription_Format union 
select 'c_Privilege', count(*) from c_Privilege union 
select 'c_Procedure', count(*) from c_Procedure union 
select 'c_Procedure_Category', count(*) from c_Procedure_Category union 
select 'c_Procedure_Coding', count(*) from c_Procedure_Coding union 
select 'c_Procedure_Extra_Charge', count(*) from c_Procedure_Extra_Charge union 
select 'c_Procedure_Material', count(*) from c_Procedure_Material union 
select 'c_Procedure_Type', count(*) from c_Procedure_Type union 
select 'c_Property', count(*) from c_Property union 
select 'c_Property_Attribute', count(*) from c_Property_Attribute union 
select 'c_Property_Type', count(*) from c_Property_Type union 
select 'c_Qualifier', count(*) from c_Qualifier union 
select 'c_Qualifier_Domain', count(*) from c_Qualifier_Domain union 
select 'c_Qualifier_Domain_Category', count(*) from c_Qualifier_Domain_Category union 
select 'c_Query_Term', count(*) from c_Query_Term union 
select 'c_Report_Attribute', count(*) from c_Report_Attribute union 
select 'c_Report_Category', count(*) from c_Report_Category union 
select 'c_Report_Definition', count(*) from c_Report_Definition union 
select 'c_Report_Params', count(*) from c_Report_Params union 
select 'c_Report_Recipient', count(*) from c_Report_Recipient union 
select 'c_Report_Type', count(*) from c_Report_Type union 
select 'c_Risk_Factor', count(*) from c_Risk_Factor union 
select 'c_Role', count(*) from c_Role union 
select 'c_Room_Type', count(*) from c_Room_Type union 
select 'c_Specialty', count(*) from c_Specialty union 
select 'c_Specialty_Assessment_Category', count(*) from c_Specialty_Assessment_Category union 
select 'c_Specialty_Drug_Category', count(*) from c_Specialty_Drug_Category union 
select 'c_Specialty_Observation_Category', count(*) from c_Specialty_Observation_Category union 
select 'c_Specialty_Procedure_Category', count(*) from c_Specialty_Procedure_Category union 
select 'c_Specimen_Type', count(*) from c_Specimen_Type union 
select 'c_Stream', count(*) from c_Stream union 
select 'c_Table_Altkey', count(*) from c_Table_Altkey union 
select 'c_Table_Fkey', count(*) from c_Table_Fkey union 
select 'c_Table_Update', count(*) from c_Table_Update union 
select 'c_Therapy_Model', count(*) from c_Therapy_Model union 
select 'c_Treatment_Type', count(*) from c_Treatment_Type union 
select 'c_Treatment_Type_List', count(*) from c_Treatment_Type_List union 
select 'c_Treatment_Type_List_Attribute', count(*) from c_Treatment_Type_List_Attribute union 
select 'c_Treatment_Type_List_Def', count(*) from c_Treatment_Type_List_Def union 
select 'c_Treatment_Type_Progress_Key', count(*) from c_Treatment_Type_Progress_Key union 
select 'c_Treatment_Type_Progress_Type', count(*) from c_Treatment_Type_Progress_Type union 
select 'c_Treatment_Type_Service', count(*) from c_Treatment_Type_Service union 
select 'c_Treatment_Type_Service_Attribute', count(*) from c_Treatment_Type_Service_Attribute union 
select 'c_Treatment_Type_Workplan', count(*) from c_Treatment_Type_Workplan union 
select 'c_Unit', count(*) from c_Unit union 
select 'c_Unit_Conversion', count(*) from c_Unit_Conversion union 
select 'c_Unit_Type', count(*) from c_Unit_Type union 
select 'c_User', count(*) from c_User union 
select 'c_User_Progress', count(*) from c_User_Progress union 
select 'c_User_Role', count(*) from c_User_Role union 
select 'c_Vaccine', count(*) from c_Vaccine union 
select 'c_Vaccine_Disease', count(*) from c_Vaccine_Disease union 
select 'c_Vaccine_Maker', count(*) from c_Vaccine_Maker union 
select 'c_Vaccine_Schedule', count(*) from c_Vaccine_Schedule union 
select 'c_Vial_Schedule', count(*) from c_Vial_Schedule union 
select 'c_Vial_Type', count(*) from c_Vial_Type union 
select 'c_Workplan', count(*) from c_Workplan union 
select 'c_Workplan_Item', count(*) from c_Workplan_Item union 
select 'c_Workplan_Item_Attribute', count(*) from c_Workplan_Item_Attribute union 
select 'c_Workplan_Selection', count(*) from c_Workplan_Selection union 
select 'c_Workplan_Step', count(*) from c_Workplan_Step union 
select 'c_Workplan_Step_Room', count(*) from c_Workplan_Step_Room union 
select 'c_Workplan_Type', count(*) from c_Workplan_Type union 
select 'c_XML_Class', count(*) from c_XML_Class union 
select 'c_XML_Class_Selection', count(*) from c_XML_Class_Selection union 
select 'c_XML_Code', count(*) from c_XML_Code union 
select 'c_XML_Code_Domain', count(*) from c_XML_Code_Domain union 
select 'c_XML_Code_Domain_Item', count(*) from c_XML_Code_Domain_Item union 
select 'dtproperties', count(*) from dtproperties union 
select 'em_Category', count(*) from em_Category union 
select 'em_Component', count(*) from em_Component union 
select 'em_Component_Level', count(*) from em_Component_Level union 
select 'em_Component_Rule', count(*) from em_Component_Rule union 
select 'em_Component_Rule_Item', count(*) from em_Component_Rule_Item union 
select 'em_Documentation_Guide', count(*) from em_Documentation_Guide union 
select 'em_Element', count(*) from em_Element union 
select 'em_Observation_Element', count(*) from em_Observation_Element union 
select 'em_Risk', count(*) from em_Risk union 
select 'em_Type', count(*) from em_Type union 
select 'em_Type_Level', count(*) from em_Type_Level union 
select 'em_Type_Rule', count(*) from em_Type_Rule union 
select 'em_Type_Rule_Item', count(*) from em_Type_Rule_Item union 
select 'em_Visit_Code_Group', count(*) from em_Visit_Code_Group union 
select 'em_Visit_Code_Item', count(*) from em_Visit_Code_Item union 
select 'em_Visit_Level', count(*) from em_Visit_Level union 
select 'em_Visit_Level_Rule', count(*) from em_Visit_Level_Rule union 
select 'em_Visit_Level_Rule_Item', count(*) from em_Visit_Level_Rule_Item union 
select 'icd10_rwanda', count(*) from icd10_rwanda union 
select 'icd10_who', count(*) from icd10_who union 
select 'icd10cm_codes', count(*) from icd10cm_codes union 
select 'icd10cm_codes_2018', count(*) from icd10cm_codes_2018 union 
select 'icd10cm_codes_2019', count(*) from icd10cm_codes_2019 union 
select 'icd9_gem', count(*) from icd9_gem union 
select 'jmc_display_stuff', count(*) from jmc_display_stuff union 
select 'o_Active_Services', count(*) from o_Active_Services union 
select 'o_box', count(*) from o_box union 
select 'o_Component_Attribute', count(*) from o_Component_Attribute union 
select 'o_Component_Base_Attribute', count(*) from o_Component_Base_Attribute union 
select 'o_Component_Computer_Attribute', count(*) from o_Component_Computer_Attribute union 
select 'o_Component_Preference', count(*) from o_Component_Preference union 
select 'o_Component_Selection', count(*) from o_Component_Selection union 
select 'o_Computer_External_Source', count(*) from o_Computer_External_Source union 
select 'o_Computer_Printer', count(*) from o_Computer_Printer union 
select 'o_Computer_Printer_Office', count(*) from o_Computer_Printer_Office union 
select 'o_Computers', count(*) from o_Computers union 
select 'o_Event_Component_Attribute', count(*) from o_Event_Component_Attribute union 
select 'o_Event_Component_Trigger', count(*) from o_Event_Component_Trigger union 
select 'o_Event_Queue', count(*) from o_Event_Queue union 
select 'o_Event_Queue_Attribute', count(*) from o_Event_Queue_Attribute union 
select 'o_External_Source_Attribute', count(*) from o_External_Source_Attribute union 
select 'o_Group_Rooms', count(*) from o_Group_Rooms union 
select 'o_Groups', count(*) from o_Groups union 
select 'o_Log', count(*) from o_Log union 
select 'o_menu_selection', count(*) from o_menu_selection union 
select 'o_Message_Log', count(*) from o_Message_Log union 
select 'o_Message_Subscription', count(*) from o_Message_Subscription union 
select 'o_office', count(*) from o_office union 
select 'o_Preferences', count(*) from o_Preferences union 
select 'o_printer', count(*) from o_printer union 
select 'o_Report_Attribute', count(*) from o_Report_Attribute union 
select 'o_Report_Printer', count(*) from o_Report_Printer union 
select 'o_Report_Trigger', count(*) from o_Report_Trigger union 
select 'o_Rooms', count(*) from o_Rooms union 
select 'o_Server_Component', count(*) from o_Server_Component union 
select 'o_Service', count(*) from o_Service union 
select 'o_Service_Attribute', count(*) from o_Service_Attribute union 
select 'o_Service_Schedule', count(*) from o_Service_Schedule union 
select 'o_Service_Schedule_Attribute', count(*) from o_Service_Schedule_Attribute union 
select 'o_Service_Trigger', count(*) from o_Service_Trigger union 
select 'o_Treatment_Service', count(*) from o_Treatment_Service union 
select 'o_Treatment_Type_Default_Mode', count(*) from o_Treatment_Type_Default_Mode union 
select 'o_User_Logins', count(*) from o_User_Logins union 
select 'o_User_Privilege', count(*) from o_User_Privilege union 
select 'o_User_Service', count(*) from o_User_Service union 
select 'o_User_Service_Lock', count(*) from o_User_Service_Lock union 
select 'o_Users', count(*) from o_Users union 
select 'p_Adverse_Reaction', count(*) from p_Adverse_Reaction union 
select 'p_Adverse_Sensitivity_Test', count(*) from p_Adverse_Sensitivity_Test union 
select 'p_Assessment', count(*) from p_Assessment union 
select 'p_assessment_Progress', count(*) from p_assessment_Progress union 
select 'p_Assessment_Treatment', count(*) from p_Assessment_Treatment union 
select 'p_Attachment', count(*) from p_Attachment union 
select 'p_Attachment_Progress', count(*) from p_Attachment_Progress union 
select 'p_Chart_Alert', count(*) from p_Chart_Alert union 
select 'p_Chart_Alert_Progress', count(*) from p_Chart_Alert_Progress union 
select 'p_Classification_Set_Item', count(*) from p_Classification_Set_Item union 
select 'p_Encounter_Assessment', count(*) from p_Encounter_Assessment union 
select 'p_Encounter_Assessment_Charge', count(*) from p_Encounter_Assessment_Charge union 
select 'p_Encounter_Charge', count(*) from p_Encounter_Charge union 
select 'p_Encounter_Charge_Modifier', count(*) from p_Encounter_Charge_Modifier union 
select 'p_Family_History', count(*) from p_Family_History union 
select 'p_Family_Illness', count(*) from p_Family_Illness union 
select 'p_Lastkey', count(*) from p_Lastkey union 
select 'p_Letter', count(*) from p_Letter union 
select 'p_Maintenance_Class', count(*) from p_Maintenance_Class union 
select 'p_Material_Used', count(*) from p_Material_Used union 
select 'p_Object_Security', count(*) from p_Object_Security union 
select 'p_Objective_Location', count(*) from p_Objective_Location union 
select 'p_Observation', count(*) from p_Observation union 
select 'p_Observation_Comment_Save', count(*) from p_Observation_Comment_Save union 
select 'p_Observation_Location', count(*) from p_Observation_Location union 
select 'p_Observation_Result', count(*) from p_Observation_Result union 
select 'p_Observation_Result_Progress', count(*) from p_Observation_Result_Progress union 
select 'p_Observation_Result_Qualifier', count(*) from p_Observation_Result_Qualifier union 
select 'p_Patient', count(*) from p_Patient union 
select 'p_Patient_Alias', count(*) from p_Patient_Alias union 
select 'p_Patient_Authority', count(*) from p_Patient_Authority union 
select 'p_Patient_Encounter', count(*) from p_Patient_Encounter union 
select 'p_Patient_Encounter_Progress', count(*) from p_Patient_Encounter_Progress union 
select 'p_Patient_Guarantor', count(*) from p_Patient_Guarantor union 
select 'p_patient_list_item', count(*) from p_patient_list_item union 
select 'p_Patient_Progress', count(*) from p_Patient_Progress union 
select 'p_Patient_Relation', count(*) from p_Patient_Relation union 
select 'p_Patient_WP', count(*) from p_Patient_WP union 
select 'p_Patient_WP_Archive', count(*) from p_Patient_WP_Archive union 
select 'p_Patient_WP_Item', count(*) from p_Patient_WP_Item union 
select 'p_Patient_WP_Item_Archive', count(*) from p_Patient_WP_Item_Archive union 
select 'p_Patient_WP_Item_Attribute', count(*) from p_Patient_WP_Item_Attribute union 
select 'p_Patient_WP_Item_Attribute_Archive', count(*) from p_Patient_WP_Item_Attribute_Archive union 
select 'p_Patient_WP_Item_Progress', count(*) from p_Patient_WP_Item_Progress union 
select 'p_Patient_WP_Item_Progress_Archive', count(*) from p_Patient_WP_Item_Progress_Archive union 
select 'p_Propensity', count(*) from p_Propensity union 
select 'p_Treatment_Item', count(*) from p_Treatment_Item union 
select 'p_Treatment_Progress', count(*) from p_Treatment_Progress union 
select 'pbcatcol', count(*) from pbcatcol union 
select 'pbcatedt', count(*) from pbcatedt union 
select 'pbcatfmt', count(*) from pbcatfmt union 
select 'pbcattbl', count(*) from pbcattbl union 
select 'pbcatvld', count(*) from pbcatvld union 
select 'r_Assessment_Treatment_Efficacy', count(*) from r_Assessment_Treatment_Efficacy union 
select 'r_Efficacy_Data', count(*) from r_Efficacy_Data union 
select 'tmp_xml_permissions', count(*) from tmp_xml_permissions union 
select 'tmprelease_display_scripts', count(*) from tmprelease_display_scripts union 
select 'tmprelease_menus', count(*) from tmprelease_menus union 
select 'tmprelease_prefs', count(*) from tmprelease_prefs union 
select 'tmprelease_workplans', count(*) from tmprelease_workplans union 
select 'u_assessment_treat_def_attrib', count(*) from u_assessment_treat_def_attrib union 
select 'u_assessment_treat_definition', count(*) from u_assessment_treat_definition union 
select 'u_Chart_Selection', count(*) from u_Chart_Selection union 
select 'u_Display_Format_Selection', count(*) from u_Display_Format_Selection union 
select 'u_Display_Script_Selection', count(*) from u_Display_Script_Selection union 
select 'u_Exam_Default_Results', count(*) from u_Exam_Default_Results union 
select 'u_Exam_Definition', count(*) from u_Exam_Definition union 
select 'u_Exam_Selection', count(*) from u_Exam_Selection union 
select 'u_Top_20', count(*) from u_Top_20 union 
select 'x_document_mapping', count(*) from x_document_mapping union 
select 'x_encounterpro_Arrived', count(*) from x_encounterpro_Arrived union 
select 'x_External_Application', count(*) from x_External_Application union 
select 'x_External_Application_Message', count(*) from x_External_Application_Message union 
select 'x_ID_Lists', count(*) from x_ID_Lists union 
select 'x_Integration_Operation', count(*) from x_Integration_Operation union 
select 'x_Integration_Operation_Tree', count(*) from x_Integration_Operation_Tree union 
select 'x_Integrations', count(*) from x_Integrations union 
select 'x_MedMan_Arrived', count(*) from x_MedMan_Arrived union 
select 'x_Message_Type', count(*) from x_Message_Type union 
select 'x_Performance_Log', count(*) from x_Performance_Log union 
select 'x_Property_Exception', count(*) from x_Property_Exception union 
select 'x_Translate_A', count(*) from x_Translate_A union 
select 'x_Translate_P', count(*) from x_Translate_P union 
select 'x_Translation_Rule', count(*) from x_Translation_Rule union 
select 'x_Translation_Set', count(*) from x_Translation_Set

select * from #tabs

name	cnt
b_Appointment_Type	0
b_Provider_Translation	0
b_Resource	0
c_1_record	1
c_Actor_Address	0
c_Actor_Class	13
c_Actor_Class_Purpose	21
c_Actor_Class_Route	17
c_Actor_Class_Type	14
c_Actor_Communication	17
c_Actor_Route_Purpose	0
c_Administration_Frequency	42
c_Administration_Method	40
c_Administration_Method_Proc	73
c_Adverse_Reaction_Drug	0
c_Adverse_Reaction_Drug_Class	0
c_Age_Range	197
c_Age_Range_Assessment	28
c_Age_Range_Category	35
c_Age_Range_Procedure	250
c_Allergen	0
c_Allergen_Drug	0
c_Allergen_Drug_Class	0
c_Allergens	0
c_Allergy_Drug	1323
c_Assessment_Category	50
c_Assessment_Coding	0
c_Assessment_Definition	80128
c_Assessment_Type	9
c_Assessment_Type_Progress_Key	24
c_Assessment_Type_Progress_Type	20
c_Attachment_Extension	32
c_Attachment_Extension_Attribute	3
c_Attachment_Location	1
c_Attachment_Type	9
c_Authority	213
c_Authority_Category	10
c_Authority_Formulary	0
c_Authority_Type	1
c_Cdc_BmiAge	436
c_Cdc_HcAgeInf	76
c_Cdc_LenAgeInf	76
c_Cdc_StatAge	436
c_Cdc_WtAge	436
c_Cdc_WtAgeInf	76
c_Cdc_WtLenInf	120
c_Cdc_WtStat	92
c_Chart	44
c_Chart_Alert_Category	0
c_Chart_Page_Attribute	7
c_Chart_Page_Definition	22
c_Chart_Section	295
c_Chart_Section_Page	625
c_Chart_Section_Page_Attribute	763
c_Classification_Set	0
c_Classification_Set_Item	0
c_Common_Assessment	14974
c_Common_Drug	7207
c_Common_Observation	64713
c_Common_Procedure	7144
c_Component	49
c_Component_Attribute	79
c_Component_Attribute_Def	41
c_Component_Base_Attribute	0
c_Component_Base_Attribute_Def	2
c_Component_Definition	11
c_Component_Interface	7
c_component_interface_object_log	0
c_component_interface_route	2
c_component_interface_route_property	3
c_Component_Log	35
c_Component_Param	1682
c_Component_Param_Class	39
c_Component_Registry	216
c_Component_Type	35
c_Component_Version	17
c_Config_Log	41
c_Config_Object	253
c_Config_Object_Category	0
c_Config_Object_Library	379
c_Config_Object_Type	20
c_Config_Object_Version	207
c_Consultant	108
c_CPT_Updates	0
c_Database_Column	3992
c_Database_Maintenance	32
c_Database_Modification_Dependancy	624
c_Database_Script	0
c_Database_Script_Log	0
c_Database_Script_Type	13
c_Database_Status	1
c_Database_System	4
c_Database_Table	398
c_Disease	35
c_Disease_Assessment	0
c_Disease_Group	13
c_Disease_Group_Item	19
c_Display_Command_Definition	212
c_Display_Format	155
c_Display_Format_Item	2091
c_Display_Script	2112
c_Display_Script_Cmd_Attribute	70864
c_Display_Script_Command	31606
c_Document_Purpose	26
c_Document_Route	9
c_Document_Type	73
c_Domain	541
c_Domain_Master	40
c_Dosage_Form	123
c_Drug_Administration	5971
c_Drug_Brand	4390
c_Drug_Brand_Ingredient	7261
c_Drug_Category	39
c_Drug_Compound	5
c_Drug_Definition	13861
c_Drug_Drug_Category	3856
c_Drug_Generic	8108
c_Drug_Generic_Ingredient	10616
c_Drug_HCPCS	490
c_Drug_Instruction	213
c_Drug_Interaction	66
c_Drug_Interaction_Class	617
c_Drug_Maker	11
c_Drug_Package	5360
c_Drug_Package_Dispense	6076
c_Drug_Type	5
c_Encounter_Procedure	186
c_Encounter_Type	486
c_Encounter_Type_Progress_Key	3834
c_Encounter_Type_Progress_Type	2486
c_Epro_Object	76
c_Equivalence	10
c_Equivalence_Group	12
c_Event	2
c_External_Observation	13
c_External_Observation_Location	6
c_External_Observation_Result	17
c_External_Source	26
c_External_Source_Attribute	15
c_External_Source_Type	16
c_Folder	34
c_Folder_Attribute	24
c_Folder_Selection	16
c_Folder_Workplan	7
c_Formulary	1
c_Formulary_Type	1
c_Growth_Data	37
c_ICD_Code	0
c_ICD_Properties	0
c_ICD_Updates	325
c_Immunization_Dose_Schedule	70
c_Immunization_Schedule	56
c_List_Item	277
c_Location	6819
c_Location_Domain	751
c_Maintenance_Assessment	215
c_Maintenance_Metric	0
c_Maintenance_Patient_Class	29
c_Maintenance_Policy	0
c_Maintenance_Procedure	64
c_Maintenance_Protocol	24
c_Maintenance_Protocol_Item	53
c_Maintenance_Treatment	0
c_Material	22
c_Material_Item	48
c_Menu	972
c_Menu_Item	5444
c_Menu_Item_Attribute	5040
c_Message_Definition	12
c_Message_Fkey	0
c_Message_Part	41
c_Message_Stream	0
c_Nomenclature_Medcin	0
c_Object_Default_Progress_Type	16
c_Observation	20246
c_Observation_Category	151
c_Observation_Observation_Cat	5721
c_Observation_Result	93290
c_Observation_Result_Qualifier	7819
c_Observation_Result_Range	15
c_Observation_Result_Set	17
c_Observation_Result_Set_Item	75
c_Observation_Stage	134
c_Observation_Treatment_Type	17168
c_Observation_Tree	29801
c_Observation_Tree_Root	69
c_Observation_Type	8
c_Office	1
c_Owner	0
c_Package	1745
c_Patient_material	198
c_Patient_material_category	8
c_Preference	469
c_Preference_Type	19
c_Preferred_Provider	24
c_Prescription_Format	6
c_Privilege	25
c_Procedure	7894
c_Procedure_Category	62
c_Procedure_Coding	0
c_Procedure_Extra_Charge	0
c_Procedure_Material	33
c_Procedure_Type	11
c_Property	1243
c_Property_Attribute	0
c_Property_Type	6
c_Qualifier	2651
c_Qualifier_Domain	362
c_Qualifier_Domain_Category	11
c_Query_Term	85
c_Report_Attribute	516
c_Report_Category	0
c_Report_Definition	252
c_Report_Params	27
c_Report_Recipient	2
c_Report_Type	5
c_Risk_Factor	0
c_Role	25
c_Room_Type	7
c_Specialty	109
c_Specialty_Assessment_Category	1325
c_Specialty_Drug_Category	1051
c_Specialty_Observation_Category	3515
c_Specialty_Procedure_Category	1481
c_Specimen_Type	0
c_Stream	0
c_Table_Altkey	113
c_Table_Fkey	98
c_Table_Update	41
c_Therapy_Model	0
c_Treatment_Type	58
c_Treatment_Type_List	197
c_Treatment_Type_List_Attribute	0
c_Treatment_Type_List_Def	11
c_Treatment_Type_Progress_Key	126
c_Treatment_Type_Progress_Type	139
c_Treatment_Type_Service	354
c_Treatment_Type_Service_Attribute	829
c_Treatment_Type_Workplan	177
c_Unit	180
c_Unit_Conversion	34
c_Unit_Type	3
c_User	33
c_User_Progress	108
c_User_Role	135
c_Vaccine	68
c_Vaccine_Disease	120
c_Vaccine_Maker	467
c_Vaccine_Schedule	17
c_Vial_Schedule	53
c_Vial_Type	6
c_Workplan	758
c_Workplan_Item	3342
c_Workplan_Item_Attribute	3308
c_Workplan_Selection	675
c_Workplan_Step	4401
c_Workplan_Step_Room	37
c_Workplan_Type	7
c_XML_Class	10
c_XML_Class_Selection	6
c_XML_Code	430
c_XML_Code_Domain	2
c_XML_Code_Domain_Item	391
dtproperties	0
em_Category	207
em_Component	3
em_Component_Level	12
em_Component_Rule	12
em_Component_Rule_Item	29
em_Documentation_Guide	1
em_Element	429
em_Observation_Element	6684
em_Risk	4
em_Type	19
em_Type_Level	68
em_Type_Rule	70
em_Type_Rule_Item	224
em_Visit_Code_Group	46
em_Visit_Code_Item	445
em_Visit_Level	5
em_Visit_Level_Rule	10
em_Visit_Level_Rule_Item	27
icd10_rwanda	6518
icd10_who	14333
icd10cm_codes	71932
icd10cm_codes_2018	71704
icd10cm_codes_2019	71932
icd9_gem	24860
jmc_display_stuff	15
o_Active_Services	4
o_box	0
o_Component_Attribute	0
o_Component_Base_Attribute	0
o_Component_Computer_Attribute	0
o_Component_Preference	0
o_Component_Selection	0
o_Computer_External_Source	0
o_Computer_Printer	20
o_Computer_Printer_Office	0
o_Computers	3
o_Event_Component_Attribute	1
o_Event_Component_Trigger	1
o_Event_Queue	762
o_Event_Queue_Attribute	762
o_External_Source_Attribute	0
o_Group_Rooms	35
o_Groups	4
o_Log	12479
o_menu_selection	89
o_Message_Log	0
o_Message_Subscription	0
o_office	1
o_Preferences	2280
o_printer	0
o_Report_Attribute	12
o_Report_Printer	10
o_Report_Trigger	4
o_Rooms	34
o_Server_Component	10
o_Service	227
o_Service_Attribute	1155
o_Service_Schedule	0
o_Service_Schedule_Attribute	0
o_Service_Trigger	2
o_Treatment_Service	6
o_Treatment_Type_Default_Mode	2100
o_User_Logins	127
o_User_Privilege	42
o_User_Service	4
o_User_Service_Lock	0
o_Users	0
p_Adverse_Reaction	0
p_Adverse_Sensitivity_Test	0
p_Assessment	99
p_assessment_Progress	102
p_Assessment_Treatment	47
p_Attachment	18
p_Attachment_Progress	34
p_Chart_Alert	2
p_Chart_Alert_Progress	2
p_Classification_Set_Item	0
p_Encounter_Assessment	59
p_Encounter_Assessment_Charge	38
p_Encounter_Charge	38
p_Encounter_Charge_Modifier	0
p_Family_History	0
p_Family_Illness	0
p_Lastkey	1
p_Letter	0
p_Maintenance_Class	0
p_Material_Used	0
p_Object_Security	0
p_Objective_Location	0
p_Observation	1217
p_Observation_Comment_Save	0
p_Observation_Location	0
p_Observation_Result	786
p_Observation_Result_Progress	61
p_Observation_Result_Qualifier	0
p_Patient	13
p_Patient_Alias	15
p_Patient_Authority	2
p_Patient_Encounter	72
p_Patient_Encounter_Progress	477
p_Patient_Guarantor	0
p_patient_list_item	0
p_Patient_Progress	684
p_Patient_Relation	1
p_Patient_WP	53
p_Patient_WP_Archive	0
p_Patient_WP_Item	293
p_Patient_WP_Item_Archive	0
p_Patient_WP_Item_Attribute	1734
p_Patient_WP_Item_Attribute_Archive	0
p_Patient_WP_Item_Progress	1432
p_Patient_WP_Item_Progress_Archive	0
p_Propensity	0
p_Treatment_Item	392
p_Treatment_Progress	2780
pbcatcol	0
pbcatedt	21
pbcatfmt	20
pbcattbl	0
pbcatvld	0
r_Assessment_Treatment_Efficacy	2
r_Efficacy_Data	0
tmp_xml_permissions	2897
tmprelease_display_scripts	150
tmprelease_menus	88
tmprelease_prefs	165
tmprelease_workplans	48
u_assessment_treat_def_attrib	72074
u_assessment_treat_definition	32055
u_Chart_Selection	307
u_Display_Format_Selection	3
u_Display_Script_Selection	254
u_Exam_Default_Results	10289
u_Exam_Definition	1490
u_Exam_Selection	559
u_Top_20	71207
x_document_mapping	0
x_encounterpro_Arrived	0
x_External_Application	0
x_External_Application_Message	0
x_ID_Lists	0
x_Integration_Operation	0
x_Integration_Operation_Tree	0
x_Integrations	19
x_MedMan_Arrived	0
x_Message_Type	0
x_Performance_Log	515
x_Property_Exception	0
x_Translate_A	0
x_Translate_P	0
x_Translation_Rule	0
x_Translation_Set	0

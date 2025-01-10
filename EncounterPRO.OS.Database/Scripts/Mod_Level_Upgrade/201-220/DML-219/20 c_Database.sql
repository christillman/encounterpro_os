
/*
select * from dbo.fn_database_schemacheck_columns ()
order by tablename

select * from [c_Database_Column] where [tablename] = 'c_Drug_Definition' order by [tablename], [column_sequence]
*/
exec add_c_database_table 'c_Adverse_Reaction_Drug'
exec add_c_database_table 'c_Adverse_Reaction_Drug_Class'
exec add_c_database_table 'c_Allergen'
exec add_c_database_table 'c_Allergen_Drug'
exec add_c_database_table 'c_Allergen_Drug_Class'
exec add_c_database_table 'c_Drug_Brand'
exec add_c_database_table 'c_Drug_Definition_Archive'
exec add_c_database_table 'c_Drug_EPC'
exec add_c_database_table 'c_Drug_Formulation'
exec add_c_database_table 'c_Drug_Generic'
exec add_c_database_table 'c_Drug_Interaction'
exec add_c_database_table 'c_Drug_Interaction_Class'
exec add_c_database_table 'c_Drug_Pack'
exec add_c_database_table 'c_Drug_Pack_Formulation'
exec add_c_database_table 'c_Drug_Package_Archive'
exec add_c_database_table 'c_Drug_Source_Formulation'
exec add_c_database_table 'c_Drug_Tall_Man'
exec add_c_database_table 'c_EPC'
exec add_c_database_table 'c_Package_Administration_Method'
exec add_c_database_table 'c_Package_Archive'
exec add_c_database_table 'c_Query_Term'
exec add_c_database_table 'c_Synonym'
exec add_c_database_table 'icd_block'
exec add_c_database_table 'icd10_rwanda'
exec add_c_database_table 'icd10_who'
exec add_c_database_table 'icd10cm_codes'
exec add_c_database_table 'icd9_gem'
exec add_c_database_table 'p_Adverse_Reaction'
exec add_c_database_table 'p_Adverse_Sensitivity_Test'
exec add_c_database_table 'p_Observation_Comment_Save'
exec add_c_database_table 'p_patient_list_item'
exec add_c_database_table 'p_Propensity'

DELETE FROM [c_Database_Column] where [tablename] IN ( 'c_Nomenclature_Medcin', 'x_ID_Lists')
DELETE FROM [c_Database_Table] where [tablename] IN ( 'c_Nomenclature_Medcin', 'x_ID_Lists')

DELETE FROM [c_Database_Column] where [tablename] = 'o_Log' and [columnname] = 'caused_by_id'
DELETE FROM [c_Database_Column] where [tablename] = 'o_Log' and [columnname] = 'id'
DELETE FROM [c_Database_Column] where [tablename] = 'c_Package' and [columnname] = 'id'
DELETE FROM [c_Database_Column] where [tablename] = 'c_Drug_Administration' and [columnname] = 'id'
DELETE FROM [c_Database_Column] where [tablename] = 'c_Vaccine' and [columnname] = 'procedure_id'

-- correct format of [column_definition]
exec add_c_database_column 'c_ICD_Code', 'icd_9_code'
exec add_c_database_column 'c_ICD_Properties', 'icd_9_code'
exec add_c_database_column 'c_ICD_Updates', 'icd_9_code'
exec add_c_database_column 'c_List_Item', 'list_id'
exec add_c_database_column 'c_List_Item', 'list_item'
exec add_c_database_column 'c_List_Item', 'list_item_id'
exec add_c_database_column 'c_List_Item', 'sort_sequence'
exec add_c_database_column 'c_List_Item', 'status'

-- added columns
exec add_c_database_column 'c_Dosage_Form', 'rxcui'
exec add_c_database_column 'c_Drug_Administration', 'form_rxcui'
exec add_c_database_column 'c_Drug_Definition', 'available_strengths'
exec add_c_database_column 'c_Drug_Definition', 'fda_generic_available'
exec add_c_database_column 'c_Drug_Definition', 'is_generic'
exec add_c_database_column 'c_Drug_Package', 'form_rxcui'
exec add_c_database_column 'c_Immunization_Dose_Schedule', 'valid_in'
exec add_c_database_column 'c_Vaccine', 'valid_in'
exec add_c_database_column 'c_Vaccine', 'drug_id'
exec add_c_database_column 'c_Vaccine_Disease', 'last_updated'
exec add_c_database_column 'c_Workplan_Step', 'mutually_exclusive_items'
exec add_c_database_column 'c_Equivalence', 'description'
exec add_c_database_column 'c_Office', 'country'
exec add_c_database_column 'o_Log', 'progress_seconds'
exec add_c_database_column 'p_Treatment_Item', 'form_rxcui'
exec add_c_database_column 'p_Treatment_Item', 'route'

-- update col length 
exec add_c_database_column 'c_Actor_Address', 'country'
exec add_c_database_column 'c_Administration_Method', 'administer_method'
exec add_c_database_column 'c_Vaccine', 'description'
exec add_c_database_column 'c_Package', 'administer_method'
exec add_c_database_column 'c_Package', 'administer_unit'
exec add_c_database_column 'c_Package', 'description'
exec add_c_database_column 'c_Package', 'dose_unit'
exec add_c_database_column 'c_Drug_Package', 'default_dispense_unit'
exec add_c_database_column 'c_Procedure', 'description'
exec add_c_database_column 'c_Procedure', 'definition'
exec add_c_database_column 'c_Unit', 'unit_id'
exec add_c_database_column 'c_Unit_Conversion', 'unit_from'
exec add_c_database_column 'c_Unit_Conversion', 'unit_to'
exec add_c_database_column 'o_Log', 'caller'
exec add_c_database_column 'o_Log', 'script'
exec add_c_database_column 'o_Log', 'message'
exec add_c_database_column 'o_Log', 'computername'
exec add_c_database_column 'o_Log', 'windows_logon_id'
exec add_c_database_column 'o_Log', 'cpr_id'
exec add_c_database_column 'o_Log', 'program'
exec add_c_database_column 'o_Log', 'cleared_by'
exec add_c_database_column 'o_Log', 'sql_version'
exec add_c_database_column 'p_Treatment_Item', 'treatment_description'

-- update column_nullable
exec add_c_database_column 'c_Property', 'return_data_type'

-- defaults
exec add_c_database_column 'c_Table_Update', 'last_updated'
exec add_c_database_column 'c_Table_Update', 'updated_by'
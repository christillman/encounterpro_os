
/*
select * from fn_database_schemacheck_columns ()
order by tablename

select * from [c_Database_Column] where [tablename] = 'c_Drug_Definition' order by [tablename], [column_sequence]
*/

-- re-create these, defective routine
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

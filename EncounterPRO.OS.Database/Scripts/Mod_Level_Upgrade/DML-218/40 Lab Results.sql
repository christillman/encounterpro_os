
update p_Treatment_item set drug_id = 'Proventil' WHERE drug_id = 'Albuterol0083%'
update p_Treatment_item set drug_id = 'RXNB203457' WHERE drug_id = 'BENADRYL'
update p_Treatment_item set drug_id = 'RXNB261702' WHERE drug_id = 'Xopenex'
update p_Treatment_item set drug_id = 'RXNB261702' WHERE drug_id = 'Xopenex125'
update p_Treatment_item set drug_id = 'RITALIN5' WHERE drug_id = 'RitalinSR'
update p_Treatment_item set drug_id = 'PHENERGAN' WHERE drug_id = 'PhenerganInjectable'
update p_Treatment_item set drug_id = 'PHENERGAN' WHERE drug_id = 'PHENERGANDM'
update p_Treatment_item set drug_id = 'RXNB219191' WHERE drug_id = 'PhazymeInfant'
update p_Treatment_item set drug_id = 'RXNB219191' WHERE drug_id = 'Phazyme'
update p_Treatment_item set drug_id = 'KEBI2307' WHERE drug_id = 'Azmacort'
update p_Treatment_item set drug_id = 'RXNG6902' WHERE drug_id = 'Prelone'

-- retrieve happy pills
insert into c_Drug_Definition
( [drug_id]
      ,[drug_type]
      ,[common_name]
      ,[generic_name]
      ,[controlled_substance_flag]
      ,[default_duration_amount]
      ,[default_duration_unit]
      ,[default_duration_prn]
      ,[max_dose_per_day]
      ,[max_dose_unit]
      ,[status]
      ,[last_updated]
      ,[owner_id]
      ,[patient_reference_material_id]
      ,[provider_reference_material_id]
      ,[dea_schedule]
      ,[dea_number]
      ,[dea_narcotic_status]
      ,[procedure_id]
      ,[reference_ndc_code]
      ,[fda_generic_available]
      ,[available_strengths]
      ,[is_generic]
)

SELECT [drug_id]
      ,[drug_type]
      ,[common_name]
      ,[generic_name]
      ,[controlled_substance_flag]
      ,[default_duration_amount]
      ,[default_duration_unit]
      ,[default_duration_prn]
      ,[max_dose_per_day]
      ,[max_dose_unit]
      ,[status]
      ,[last_updated]
      ,[owner_id]
      ,[patient_reference_material_id]
      ,[provider_reference_material_id]
      ,[dea_schedule]
      ,[dea_number]
      ,[dea_narcotic_status]
      ,[procedure_id]
      ,[reference_ndc_code]
      ,[fda_generic_available]
      ,[available_strengths]
      ,[is_generic] 
	  from c_Drug_Definition_Archive 
	  where drug_id = '981^33'
		AND NOT EXISTS (SELECT 1 FROM c_Drug_Definition p
		where drug_id = '981^33'
		)

-- Clean these up, we have no objects to support them (ancient anyway)
DELETE from c_Component_Registry
where status != 'OK'

-- Make warnings appear for Nurse Patty, Dr Pedia, and Clinical Support
insert into o_Preferences ( [preference_type]
      ,[preference_level]
      ,[preference_key]
      ,[preference_id]
      ,[preference_value]
	  )
SELECT 'SYSTEM','User','CLINSUPT','display_log_level','3'
FROM  c_1_record r
WHERE NOT EXISTS (SELECT 1 FROM o_Preferences p
	where p.preference_id = 'display_log_level'
	and p.[preference_key] = 'CLINSUPT'
	)

insert into o_Preferences ( [preference_type]
      ,[preference_level]
      ,[preference_key]
      ,[preference_id]
      ,[preference_value]
	  )
SELECT 'SYSTEM','User','981^2','display_log_level','3'
FROM  c_1_record r
WHERE NOT EXISTS (SELECT 1 FROM o_Preferences p
	where p.preference_id = 'display_log_level'
	and p.[preference_key] = '981^2'
	)

insert into o_Preferences ( [preference_type]
      ,[preference_level]
      ,[preference_key]
      ,[preference_id]
      ,[preference_value]
	  )
SELECT 'SYSTEM','User','981^1','display_log_level','3'
FROM  c_1_record r
WHERE NOT EXISTS (SELECT 1 FROM o_Preferences p
	where p.preference_id = 'display_log_level'
	and p.[preference_key] = '981^1'
	)

-- Add Lab Results folder
insert into c_Folder 
( [folder]
      ,[context_object]
      -- ,[context_object_type] NULL
      ,[description]
      ,[status]
      ,[sort_sequence]
      ,[workplan_required_flag]
)
SELECT 'Lab Results','Encounter','Lab Results','OK', 9,	'N'
FROM  c_1_record r
WHERE NOT EXISTS (SELECT 1 FROM c_Folder p
	where p.[folder] = 'Lab Results'
	)

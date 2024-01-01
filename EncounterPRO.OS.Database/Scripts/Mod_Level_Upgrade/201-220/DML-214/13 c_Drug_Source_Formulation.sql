
UPDATE Kenya_Drugs
SET Corresponding_RXCUI = 'SCD-1658226' 
WHERE Corresponding_RXCUI = '1658226'

INSERT INTO c_Drug_Source_Formulation (
	[country_code]
      ,[source_id]
      ,[is_single_ingredient]
	  ,[is_pack]
      ,[active_ingredients]
      ,[source_generic_form_descr]
      ,[generic_form_rxcui]
      ,[generic_rxcui]
      ,[source_brand_form_descr]
      ,[brand_form_rxcui]
      ,[brand_name_rxcui]
)
SELECT gr.[country_code]
      ,gr.[source_id]
      ,CASE WHEN source_generic_form_descr like '% / %' THEN 0 ELSE 1 END
	  ,CASE WHEN br.source_brand_form_descr like '%{%' THEN 1 ELSE 0 END
      ,[active_ingredients]
      ,[source_generic_form_descr]
      ,upper(gr.[country_code]) + 'G' + gr.[source_id] AS [generic_form_rxcui]
      ,[generic_rxcui]
      ,[source_brand_form_descr]
      ,CASE WHEN br.source_id IS NULL THEN NULL 
		ELSE upper(gr.[country_code]) + 'B' + gr.[source_id] END AS [brand_form_rxcui]
      ,[brand_name_rxcui]
FROM [dbo].[c_Drug_Generic_Related] gr 
LEFT JOIN [dbo].[c_Drug_Brand_Related] br ON gr.source_id = br.source_id AND gr.[country_code] = br.[country_code]
-- (2714 rows affected)

INSERT INTO c_Drug_Source_Formulation (
	[country_code]
      ,[source_id]
      ,[is_single_ingredient]
	  ,[is_pack]
      ,[active_ingredients]
      ,[source_generic_form_descr]
      ,[generic_form_rxcui]
      ,[generic_rxcui]
      ,[source_brand_form_descr]
      ,[brand_form_rxcui]
      ,[brand_name_rxcui]
)
SELECT br.[country_code]
      ,br.[source_id]
      ,br.[is_single_ingredient]
	  ,CASE WHEN br.source_brand_form_descr like '%{%' THEN 1 ELSE 0 END
      ,[active_ingredients]
      ,[source_generic_form_descr]
      ,upper(br.[country_code]) + 'G' + br.[source_id] AS [generic_form_rxcui]
      ,[generic_rxcui]
      ,[source_brand_form_descr]
      ,upper(br.[country_code]) + 'B' + br.[source_id] AS [brand_form_rxcui]
      ,[brand_name_rxcui] 
FROM [dbo].[c_Drug_Brand_Related] br
LEFT JOIN [dbo].[c_Drug_Generic_Related] gr ON gr.source_id = br.source_id AND gr.[country_code] = br.[country_code]
WHERE gr.source_id IS NULL
-- (23 rows affected)

UPDATE f
SET generic_form_rxcui = Substring(k.Corresponding_RXCUI, 5, 100)
-- select * -- distinct k.Corresponding_RXCUI
FROM c_Drug_Source_Formulation f
JOIN Kenya_Drugs k ON k.Retention_No = f.source_id
WHERE country_code = 'ke'
AND k.SCD_PSN_Version IS NOT NULL
AND f.generic_form_rxcui != Substring(k.Corresponding_RXCUI, 5, 100)
AND LEFT(k.Corresponding_RXCUI,4) IN ('SCD-','PSN-')
-- (1495 rows affected)

UPDATE c_Drug_Source_Formulation SET generic_form_rxcui = 'KEG4015' WHERE generic_form_rxcui = 'KEG7623' 
UPDATE c_Drug_Source_Formulation SET generic_form_rxcui = 'KEG4495' WHERE generic_form_rxcui = 'KEG9133' 
UPDATE c_Drug_Source_Formulation SET generic_form_rxcui = 'KEG5916' WHERE generic_form_rxcui = 'KEG9632B' 

UPDATE f
SET generic_form_rxcui = u.generic_form_RXCUI
-- select distinct u.generic_form_RXCUI
FROM c_Drug_Source_Formulation f
JOIN Uganda_Drugs u ON u.NDA_MAL_HDP = f.source_id
WHERE country_code = 'ug'
AND u.generic_form_RXCUI IS NOT NULL
AND f.generic_form_rxcui != u.generic_form_RXCUI
--(69 rows affected

UPDATE sf
SET brand_form_rxcui = fb.form_rxcui
-- select fb.form_rxcui
FROM c_Drug_Source_Formulation sf
JOIN c_Drug_Formulation fb ON fb.form_descr = sf.source_brand_form_descr
AND sf.brand_form_rxcui != fb.form_rxcui
-- (247 rows affected)

-- similar description, but not quite the same
UPDATE c_Drug_Source_Formulation SET brand_form_rxcui = '860977' WHERE source_id = '10484' AND country_code = 'ke'
UPDATE c_Drug_Source_Formulation SET brand_form_rxcui = '807283' WHERE source_id = '1034' AND country_code = 'ke'
UPDATE c_Drug_Source_Formulation SET brand_form_rxcui = '860983' WHERE source_id = '10485' AND country_code = 'ke'
UPDATE c_Drug_Source_Formulation SET brand_form_rxcui = '861752' WHERE source_id = '10487' AND country_code = 'ke'
UPDATE c_Drug_Source_Formulation SET brand_form_rxcui = '861757' WHERE source_id = '10488' AND country_code = 'ke'
UPDATE c_Drug_Source_Formulation SET brand_form_rxcui = '1546894' WHERE source_id = '12082' AND country_code = 'ke'
UPDATE c_Drug_Source_Formulation SET brand_form_rxcui = '1743781' WHERE source_id = '3308' AND country_code = 'ke'
UPDATE c_Drug_Source_Formulation SET brand_form_rxcui = '1000128' WHERE source_id = '3309' AND country_code = 'ke'
UPDATE c_Drug_Source_Formulation SET brand_form_rxcui = '104897' WHERE source_id = '3692' AND country_code = 'ke'
UPDATE c_Drug_Source_Formulation SET brand_form_rxcui = '1659595' WHERE source_id = '5216' AND country_code = 'ke'
UPDATE c_Drug_Source_Formulation SET brand_form_rxcui = '897714' WHERE source_id = '5575' AND country_code = 'ke'
UPDATE c_Drug_Source_Formulation SET brand_form_rxcui = '285018' WHERE source_id = '5912' AND country_code = 'ke'
UPDATE c_Drug_Source_Formulation SET brand_form_rxcui = '104377' WHERE source_id = '7850' AND country_code = 'ke'
UPDATE c_Drug_Source_Formulation SET brand_form_rxcui = '104378' WHERE source_id = '7852' AND country_code = 'ke'

-- quotes interfering with match
UPDATE sf
SET source_brand_form_descr = p.descr
-- select source_brand_form_descr, p.descr
FROM c_Drug_Source_Formulation sf
JOIN c_Drug_Pack p ON p.rxcui = sf.brand_form_rxcui
AND (source_brand_form_descr IS NULL 
	OR source_brand_form_descr != p.descr)
-- (21 rows affected)

UPDATE sf
SET generic_form_rxcui = f.generic_form_rxcui
-- select sf.generic_form_rxcui, f.generic_form_rxcui
FROM c_Drug_Source_Formulation sf
JOIN c_Drug_Formulation f ON f.form_rxcui = sf.brand_form_rxcui
JOIN c_Drug_Formulation fg ON fg.form_rxcui = f.generic_form_rxcui
WHERE f.generic_form_rxcui != sf.generic_form_rxcui
-- (244 rows affected)

UPDATE sf
SET generic_form_rxcui = fg.form_rxcui
-- select sf.generic_form_rxcui, fg.form_rxcui
FROM c_Drug_Source_Formulation sf
JOIN c_Drug_Formulation fg ON fg.form_descr = sf.source_generic_form_descr
LEFT JOIN c_Drug_Formulation f ON f.form_rxcui = sf.generic_form_rxcui
LEFT JOIN c_Drug_Pack p ON p.rxcui = sf.generic_form_rxcui
WHERE f.form_rxcui IS NULL AND p.rxcui IS NULL
-- (8 rows affected)

UPDATE sf
SET source_generic_form_descr = p.descr
-- select source_generic_form_descr, p.descr
FROM c_Drug_Source_Formulation sf
JOIN c_Drug_Pack p ON p.rxcui = 'KEG' + source_id
WHERE source_brand_form_descr like '%{%'
AND (source_generic_form_descr IS NULL 
	OR source_generic_form_descr != p.descr)
-- (23 rows affected)

/*
select * FROM c_Drug_Source_Formulation sf
LEFT JOIN c_Drug_Formulation f ON f.form_rxcui = sf.generic_form_rxcui
LEFT JOIN c_Drug_Pack p ON p.rxcui = sf.generic_form_rxcui
WHERE f.form_rxcui IS NULL AND p.rxcui IS NULL

select * FROM c_Drug_Source_Formulation sf
JOIN c_Drug_Formulation fb ON fb.ingr_rxcui = sf.brand_name_rxcui
LEFT JOIN c_Drug_Formulation f ON f.form_rxcui = sf.brand_form_rxcui
LEFT JOIN c_Drug_Pack p ON p.rxcui = sf.brand_form_rxcui
WHERE f.form_rxcui IS NULL AND p.rxcui IS NULL
AND sf.brand_form_rxcui IS NOT NULL

select source_id, country_code from (
select source_id, country_code from c_Drug_Brand_Related
union
select source_id, country_code from c_Drug_Generic_Related
) t
except
select source_id, country_code from c_Drug_Source_Formulation
*/

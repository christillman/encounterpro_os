

UPDATE df
SET valid_in = valid_in + 'ke;'
 -- select *
from Kenya_Drugs KD
join c_Drug_Formulation DF
on kd.SBD_Version=df.form_descr 
OR kd.SCD_PSN_Version = df.form_descr 
OR substring(kd.Corresponding_RXCUI,5,20) = df.form_rxcui
where df.valid_in = 'us;'
-- (249 row(s) affected)

UPDATE f
SET valid_in = 'us;'
-- select *
FROM c_Drug_Formulation f
WHERE valid_in LIKE '%ke;%' AND valid_in LIKE '%us;%'
AND form_tty LIKE 'SCD%' -- and form_descr like 'Lamivudine 300%'
AND NOT EXISTS (SELECT 1 FROM c_Drug_Formulation f2
	WHERE f2.generic_form_rxcui = f.form_rxcui
	AND f2.valid_in LIKE '%ke;%'
	)
-- (1990 row(s) affected)

UPDATE f
SET valid_in = valid_in + 'ke;'
-- select *
FROM c_Drug_Formulation f
WHERE f.valid_in = 'us;'
AND form_rxcui IN (
'1233709',
'884173',
'884185',
'884189',
'892791'
)
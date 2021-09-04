/*


select distinct 'exec sp_remove_epro_drug 0, ''KE'', ''' + k.Retention_No + ''', ' 
	+ '''KEBI' + k.Retention_No + ''', ''KEGI' + k.Retention_No + ''''
from [dbo].[05_07_2021_VaccineFormulations_Diseases] v
left join Kenya_Drugs k
on (k.Retention_No = v.[SBD_RXCUI or Kenya Retention Number]
 or k.Retention_No = left(v.[SBD_RXCUI or Kenya Retention Number],4))
where [Notes on formulations RXNORM versus Kenya] like 'Dupl%'

-- after generating removal statements
DELETE v -- select distinct k.Retention_No
from [dbo].[05_07_2021_VaccineFormulations_Diseases] v
join Kenya_Drugs k
on (k.Retention_No = v.[SBD_RXCUI or Kenya Retention Number]
 or k.Retention_No = left(v.[SBD_RXCUI or Kenya Retention Number],4))
WHERE [Notes on formulations RXNORM versus Kenya] like 'Dupl%'
*/

exec sp_remove_epro_drug 0, 'KE', '10093', 'KEBI10093', 'KEGI10093'
exec sp_remove_epro_drug 0, 'KE', '3627', 'KEBI3627', 'KEGI3627'
exec sp_remove_epro_drug 0, 'KE', '3629', 'KEBI3629', 'KEGI3629'
exec sp_remove_epro_drug 0, 'KE', '6341A', 'KEBI6341A', 'KEGI6341A'
exec sp_remove_epro_drug 0, 'KE', '6341B', 'KEBI6341B', 'KEGI6341B'
exec sp_remove_epro_drug 0, 'KE', '6343', 'KEBI6343', 'KEGI6343'
exec sp_remove_epro_drug 0, 'KE', '6896', 'KEBI6896', 'KEGI6896'
exec sp_remove_epro_drug 0, 'KE', '7601A', 'KEBI7601A', 'KEGI7601A'
exec sp_remove_epro_drug 0, 'KE', '7601B', 'KEBI7601B', 'KEGI7601B'
exec sp_remove_epro_drug 0, 'KE', '7608A', 'KEBI7608A', 'KEGI7608A'
exec sp_remove_epro_drug 0, 'KE', '7608B', 'KEBI7608B', 'KEGI7608B'
exec sp_remove_epro_drug 0, 'KE', '7691', 'KEBI7691', 'KEGI7691'
exec sp_remove_epro_drug 0, 'KE', '7697A', 'KEBI7697A', 'KEGI7697A'
exec sp_remove_epro_drug 0, 'KE', '7697B', 'KEBI7697B', 'KEGI7697B'

-- Additionally these were found to be duplicated by RXNORM generic name

-- 1008395
exec sp_remove_epro_drug 0, 'KE', '12367'
-- 1008803
exec sp_remove_epro_drug 0, 'KE', '2911'
-- 1006915
exec sp_remove_epro_drug 0, 'KE', '7884A'
exec sp_remove_epro_drug 0, 'KE', '7884B'
-- only formulation difference 
exec sp_remove_epro_drug 0, 'KE', '7058A'

-- Different usages
exec sp_remove_epro_drug 0, 'KE', '1544A'
exec sp_remove_epro_drug 0, 'KE', '1544B'

exec sp_add_epro_drug 0, 0, 'KE', '1544A', 'No Brand', 'BCG, Live (children over one year and adult) vaccine between 2 x105 and 8x105 C.F.U per 0.1 ML Injection', 'No Corresponding SCD RXCUI', 'BCG Vaccine Adult', 'Vaccine'
exec sp_add_epro_drug 0, 0, 'KE', '1544B', 'No Brand', 'BCG, Live, BCG, Live (Infant under one year) vaccine between 2 x105 and 8x105 C.F.U per 0.05 ML Injection', 'No Corresponding SCD RXCUI', 'BCG Vaccine Infant', 'Vaccine'

exec sp_add_epro_drug 1, 0, 'US', '2178781', 'No Brand', 'BCG, Live, BCG, Live (Infant under one year) vaccine between 2 x105 and 8x105 C.F.U per 0.05 ML Injection', 'No Corresponding SCD RXCUI', 'BCG Vaccine Infant', 'Vaccine'


/*
 select * 
FROM c_Drug_Definition where drug_id IN (
'2209^1',
'981^29',
'981^30',
'981^31',
'DTAP',
'DTaP/Hib/IPV',
'HEPA',
'HEPB',
'HEPBand',
'HibActHIB)',
'HibPedvaxHIB)',
'IPV',
'Japaneseencephalit',
'Menactra',
'Menningococcus',
'MMR',
'MMRV',
'PEDDT',
'Pediarix',
'RABIES',
'ROTAVIRUS',
'ROTAVIRUS2',
'TdaP',
'TYPHOID',
'Varivax1',
'YELLOW',
'ZADULTTD',
'ZosterShingles'
)
*/

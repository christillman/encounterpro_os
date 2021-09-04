

UPDATE [dbo].[Kenya_Drugs] 
SET SBD_Version = replace(SBD_Version,'  ',' ') 
WHERE SBD_Version like  '%  %'

UPDATE [dbo].[Kenya_Drugs] 
SET SCD_PSN_Version = replace(SCD_PSN_Version,'  ',' ') 
WHERE SCD_PSN_Version like '%  %'

UPDATE [dbo].[Kenya_Drugs] 
SET ingredient = replace(ingredient,'  ',' ') 
WHERE ingredient like '%  %'

UPDATE [dbo].[c_Drug_Generic_Related]
SET [active_ingredients] = replace([active_ingredients],'  ',' ') 
WHERE [active_ingredients] like '%  %'

UPDATE [dbo].[c_Drug_Generic_Related]
SET [source_generic_form_descr] = replace([source_generic_form_descr],'  ',' ') 
WHERE [source_generic_form_descr] like '%  %'

UPDATE [dbo].[c_Drug_Brand_Related]
SET [source_brand_form_descr] = replace([source_brand_form_descr],'  ',' ') 
WHERE [source_brand_form_descr] like '%  %'

UPDATE [dbo].[c_Drug_Generic]
SET generic_name = replace(generic_name,'  ',' ') 
WHERE generic_name like '%  %'

UPDATE [dbo].c_Drug_Definition
SET common_name = replace(common_name,'  ',' ') 
WHERE common_name like '%  %'

UPDATE [dbo].c_Drug_Definition
SET generic_name = replace(generic_name,'  ',' ') 
WHERE generic_name like '%  %'

/*
select '''' + generic_name + ''','
from c_Drug_Generic
group by generic_name
having count(*) > 1

select '''' + generic_rxcui + ''','
from c_Drug_Generic
where generic_name in (
'Hepatitis A Vaccine (Inactivated) Strain HM175 / Hepatitis B Surface Antigen Vaccine',
'Human-Bovine Reassortant Rotavirus Strain G1 Vaccine / Human-Bovine Reassortant Rotavirus Strain G2 Vaccine / Human-Bovine Reassortant Rotavirus Strain G3 Vaccine / Human-Bovine Reassortant Rotavirus Strain G4 Vaccine / Human-Bovine Reassortant Rotavirus Strain P1A[8] Vaccine',
'L1 protein, human papillomavirus type 11 vaccine / L1 protein, human papillomavirus type 16 vaccine / L1 protein, human papillomavirus type 18 vaccine / L1 protein, human papillomavirus type 6 vaccine',
'meningococcal group A polysaccharide / meningococcal group C polysaccharide / MENINGOCOCCAL POLYSACCHARIDE VACCINE GROUP W-135 / MENINGOCOCCAL POLYSACCHARIDE VACCINE GROUP Y',
'Neisseria meningitidis serogroup A capsular polysaccharide diphtheria toxoid protein conjugate vaccine / Neisseria meningitidis serogroup C capsular polysaccharide diphtheria toxoid protein conjugate vaccine / Neisseria meningitidis serogroup W-135 capsular polysaccharide diphtheria toxoid protein conjugate vaccine / Neisseria meningitidis serogroup Y capsular polysaccharide diphtheria toxoid protein conjugate vaccine',
'poliovirus vaccine inactivated, type 1 (Mahoney) / poliovirus vaccine inactivated, type 2 (MEF-1) / poliovirus vaccine inactivated, type 3 (Saukett)',
'Streptococcus pneumoniae serotype 1 capsular antigen diphtheria CRM197 protein conjugate vaccine / Streptococcus pneumoniae serotype 14 capsular antigen diphtheria CRM197 protein conjugate vaccine / Streptococcus pneumoniae serotype 18C capsular antigen diphtheria CRM197 protein conjugate vaccine / Streptococcus pneumoniae serotype 19A capsular antigen diphtheria CRM197 protein conjugate vaccine / Streptococcus pneumoniae serotype 19F capsular antigen diphtheria CRM197 protein conjugate vaccine / Streptococcus pneumoniae serotype 23F capsular antigen diphtheria CRM197 protein conjugate vaccine / Streptococcus pneumoniae serotype 3 capsular antigen diphtheria CRM197 protein conjugate vaccine / Streptococcus pneumoniae serotype 4 capsular antigen diphtheria CRM197 protein conjugate vaccine / Streptococcus pneumoniae serotype 5 capsular antigen diphtheria CRM197 protein conjugate vaccine / Streptococcus pneumoniae serotype 6A capsular antigen diphtheria CRM197 protein conjugate vaccine / Streptococcus pneumoniae serotype 6B capsular antigen diphtheria CRM197 protein conjugate vaccine / Streptococcus pneumoniae serotype 7F capsular antigen diphtheria CRM197 protein conjugate vaccine / Streptococcus pneumoniae serotype 9V capsular antigen diphtheria CRM197 protein conjugate vaccine'
)
order by 1

select generic_rxcui, generic_name 
from c_Drug_Generic
where generic_rxcui IN (
'1006915',
'1007640',
'1008034',
'1008395',
'1008803',
'1008837',
'KEGI10093',
'KEGI12367',
'KEGI2911',
'KEGI6896',
'KEGI7697A',
'KEGI7884A',
'KEGI7884B',
'KEGI7058A')
order by generic_name
*/

delete 
-- select *
from c_Unit where unit_id in
(
'µg/L',
'µmol/L',
'10^12/L',
'10^9/L',
'AI',
'g/collection',
'g/L',
'GPL',
'IU/mL',
'klU/L',
'mg/mmol',
'mIU/L',
'mL/min',
'mL/min/1.73m2',
'mlU/mL',
'mmol/collection',
'mmol/L',
'mmol/mmol',
'mmol/mol',
'MPL',
'mU/L',
'ng/L',
'nmol/L',
'pmol/L',
'ratio (L/L)',
'ratio',
'sec',
'Titre',
'U/mL',
'Ul/mL'
)

insert into c_Unit (
[unit_id]
      ,[description]
      ,[unit_type]
      ,[pretty_fraction]
      ,[plural_flag]
      ,[print_unit]
      ,[display_mask]
)
/*
select distinct
r.units,	r.units,	'NUMBER',	'display_mask',	'N',	'Y',	'0.###'
from c_Lab_Reference_Range r
left join c_Age_Range a on a.age_range_id = r.age_range_id
left join c_Unit u on u.description = r.units
where u.unit_id is null
*/
VALUES
('µg/L','µg/L','NUMBER','display_mask','N','Y','0.###'),
('µmol/L','µmol/L','NUMBER','display_mask','N','Y','0.###'),
('10^12/L','10^12/L','NUMBER','display_mask','N','Y','0.###'),
('10^9/L','10^9/L','NUMBER','display_mask','N','Y','0.###'),
('AI','AI','NUMBER','display_mask','N','Y','0.###'),
('g/collection','g/collection','NUMBER','display_mask','N','Y','0.###'),
('g/L','g/L','NUMBER','display_mask','N','Y','0.###'),
('GPL','GPL','NUMBER','display_mask','N','Y','0.###'),
('IU/mL','IU/mL','NUMBER','display_mask','N','Y','0.###'),
('klU/L','klU/L','NUMBER','display_mask','N','Y','0.###'),
('mg/mmol','mg/mmol','NUMBER','display_mask','N','Y','0.###'),
('mIU/L','mIU/L','NUMBER','display_mask','N','Y','0.###'),
('mL/min','mL/min','NUMBER','display_mask','N','Y','0.###'),
('mL/min/1.73m2','mL/min/1.73m2','NUMBER','display_mask','N','Y','0.###'),
('mlU/mL','mlU/mL','NUMBER','display_mask','N','Y','0.###'),
('mmol/collection','mmol/collection','NUMBER','display_mask','N','Y','0.###'),
('mmol/L','mmol/L','NUMBER','display_mask','N','Y','0.###'),
('mmol/mmol','mmol/mmol','NUMBER','display_mask','N','Y','0.###'),
('mmol/mol','mmol/mol','NUMBER','display_mask','N','Y','0.###'),
('MPL','MPL','NUMBER','display_mask','N','Y','0.###'),
('mU/L','mU/L','NUMBER','display_mask','N','Y','0.###'),
('ng/L','ng/L','NUMBER','display_mask','N','Y','0.###'),
('nmol/L','nmol/L','NUMBER','display_mask','N','Y','0.###'),
('pmol/L','pmol/L','NUMBER','display_mask','N','Y','0.###'),
('ratio (L/L)','ratio (L/L)','NUMBER','display_mask','N','Y','0.###'),
('ratio','ratio','NUMBER','display_mask','N','Y','0.###'),
('sec','sec','NUMBER','display_mask','N','Y','0.###'),
('Titre','Titre','NUMBER','display_mask','N','Y','0.###'),
('U/mL','U/mL','NUMBER','display_mask','N','Y','0.###'),
('Ul/mL','Ul/mL','NUMBER','display_mask','N','Y','0.###')
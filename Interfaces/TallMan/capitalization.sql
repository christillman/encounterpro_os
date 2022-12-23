
select distinct generic_name 
from c_Drug_Generic g
where g.generic_name collate SQL_Latin1_General_CP1_CS_AS 
	!= lower(g.generic_name collate SQL_Latin1_General_CP1_CS_AS)
and generic_name > 'bz'
-- 2525

select distinct generic_name 
from c_Drug_Definition g
where g.generic_name collate SQL_Latin1_General_CP1_CS_AS 
	!= lower(g.generic_name collate SQL_Latin1_General_CP1_CS_AS)
-- 2759

select distinct generic_name 
from c_Drug_Generic g
where g.generic_name like '%.%' 

generic_name not like '%influ%'
generic_name not like '%antigen%'
generic_name not like '%vaccine%'
generic_name not like '%factor [IVX]%'
generic_name not like '%in [IVX]%'
generic_name not like '% [A-Z]'
like '%BCG%'
'%[( ]USP%' '%NPH%' '%Rho(D)%' '%St. %' 
rimabotulinumtoxinB
Zinc-DTPA

Pepsin A Vitamin A Polymyxin B Type A factor X Penicillin G Protein C , A

capitalize letters on their own 
'% [A-Z] %' '% [A-Z]' '%-[A-Z] %' '%[D]-%' 
letters preceding numbers
'% [A-Z][0-9]%' 


Replace(generic_name, ' B 12',' B12') 
Replace(generic_name, 'Vitamin', 'vitamin'
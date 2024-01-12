

/*
981^29	Vaccine	Hib PRP-T 4dose (Hiberix)
981^30	Vaccine	Pneumococcal conj (PCV13)
981^31	Vaccine	Hib-MenCY-TT (MenHibrix)
981^33	Single Drug	My Favorite Drug
981^46	Single Drug	CEFTRICZONE
981^47	Single Drug	PREDISOLON
981^48	Single Drug	flurinase
981^49	Compound Drug	frinase
981^50	Single Drug	FEFAN
981^53	Cocktail	jena cough
981^54	Single Drug	Montelukast / Levocetrizine
*/

update c_Drug_Definition
set drug_type = 'Vaccine'
where drug_id = 'KEBI12367'

DELETE FROM c_Drug_Definition
where drug_id not in (select drug_id from c_Drug_Brand)
and drug_id not in (select drug_id from c_Drug_Generic)
and drug_id not in (select drug_id from c_Vaccine)
and drug_id in (
'214250',
'281',
'42372',
'42954',
'5492',
'6876',
'6918',
'723',
'KEBI10671',
'KEBI16615',
'KEBI7647',
'KEGI12367',
'KEGI2422',
'KEGI4064',
'KEGI4754',
'KEGI7884B',
'UGGI4855',
'UGGI6424',
'UGGI6489',
'UGGI9413',
'UGGI9416'
)

delete d1
from c_Drug_Definition d1
join c_Drug_Definition d2 on d2.drug_id = d1.generic_name
and d1.generic_name = d2.generic_name
and d1.common_name = d2.common_name
where d1.drug_id not in (select drug_id from c_Drug_Brand)
and d1.drug_id not in (select drug_id from c_Drug_Generic)
and d1.drug_id not in (select drug_id from c_Vaccine)
and d2.drug_id in (select drug_id from c_Drug_Generic)

update [p_Treatment_Item] set drug_id = 'HEPB', treatment_key = 'HEPB' 
where drug_id = '981^42'

/*
specialty_id	drug_id
$ENT	981^46
$ENT	981^47
$ENT	981^48
$ENT	981^49
$PEDS	981^5
$ENT	981^50
$ENT	981^51
$ENT	981^52
$ENT	981^53
$ONC	981^54
*/

delete
from c_Common_Drug
where drug_id not in (select drug_id from c_Drug_Brand)
and drug_id not in (select drug_id from c_Drug_Generic)
and drug_id not in (select drug_id from c_Vaccine)

delete
from u_Top_20
where top_20_code like '%medication%'
and item_id not in (select drug_id from c_Drug_Brand)
and item_id not in (select drug_id from c_Drug_Generic)
and item_id not in (select drug_id from c_Vaccine)
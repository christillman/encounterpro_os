
delete from c_Drug_Package
where drug_id in ('KEBI7647',
'KEGI7058B',
'RXNB1801607',
'RXNB1801825',
'RXNB1946970',
'RXNB2177693',
'RXNB2178358',
'RXNB2381146',
'UGGI4801',
'UGGI4855',
'UGGI9415')

delete from c_Drug_Package where form_rxcui in ('KEB5912', 'KEB5216')


update c_Drug_Package set form_rxcui = '1799654' where form_rxcui = 'R1799654'
update c_Drug_Package set form_rxcui = '793741' where form_rxcui = 'R793741'
update c_Drug_Package set form_rxcui = '1658472' where form_rxcui = '854981'
update c_Drug_Package set form_rxcui = '546627' where form_rxcui = 'R546627'
update c_Drug_Package set form_rxcui = '313072' where form_rxcui = 'R313072'

update c_Drug_Definition
set is_generic = 1
where is_generic is null
and left(common_name,77) = left(generic_name,77)

update c_Drug_Definition
set is_generic = 0
where is_generic is null
and common_name != generic_name

update c_Drug_Definition
set status = 'OK'
where status is null

delete from c_Drug_Definition where drug_id = 'KEGI10618'
update c_Drug_Definition set common_name = 'sennosides', generic_name = 'sennosides' where drug_id = 'RXNG36387'
update c_Drug_Generic set generic_rxcui = '36387', drug_id = 'RXNG36387' where generic_rxcui = 'KEGI10618'
update c_Drug_Brand set generic_rxcui = '36387' where generic_rxcui = 'KEGI10618'
update c_Drug_Formulation set ingr_rxcui = '36387' where ingr_rxcui = 'KEGI10618'

-- old flu vaccine formulations (now they all have an effective year designation)
delete f
from c_Drug_Formulation f
where not exists (select 1 from c_Drug_Generic g where g.generic_rxcui = f.ingr_rxcui)
and not exists (select 1 from c_Drug_Brand b where b.brand_name_rxcui = f.ingr_rxcui)

delete from c_Drug_Formulation where form_rxcui = 'R313072'

exec sp_add_missing_drug_defn_pkg_adm_method

-- Previously, sp_add_missing_drug_defn_pkg_adm_method was defective (used vw_dose_unit)
UPDATE p
SET [dosage_form] = df.[dosage_form],
	[dose_unit] = df.[default_dose_unit]
FROM c_Drug_Formulation f
JOIN c_Drug_Brand b ON b.brand_name_rxcui = f.ingr_rxcui
JOIN c_Drug_Package dp ON dp.drug_id = b.drug_id
	AND dp.form_rxcui = f.form_rxcui
join c_Package p on p.package_id = dp.package_id
LEFT JOIN c_Drug_Formulation fg ON fg.form_rxcui = f.generic_form_rxcui
LEFT JOIN c_Dosage_Form df ON df.dosage_form = dbo.fn_std_dosage_form(f.form_descr, fg.form_descr)
WHERE (p.dose_unit is null and df.[default_dose_unit] is not null)
or (p.[dosage_form] is null and df.[dosage_form] is not null)


select * into Drug_Generic
from c_Drug_Generic

select * into Drug_Brand
from c_Drug_Brand


-- Generic formulations removed
select fg.*
from form_generic fg
where fg.form_descr not like '%201%'
and fg.form_descr not like '%vaccine%'
and not exists (select 1 
	from c_Drug_Formulation f
where fg.form_rxcui = f.form_rxcui)
order by fg.form_descr


-- Brand formulations removed
select fb.*
from form_brand fb
where not exists (select 1 
	from c_Drug_Formulation f
where fb.form_rxcui = f.form_rxcui)
order by fb.form_descr

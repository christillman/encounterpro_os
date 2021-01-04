
SELECT 'INSERT INTO c_Drug_Formulation VALUES (''' + 
	[form_rxcui] + ''',''' +
      [form_tty] + ''',''' +
      [form_descr] + ''',''' +
      [ingr_rxcui] + ''',''' +
      [ingr_tty] + ''',''' +
      [valid_in] + ''',NULL)'
from c_Drug_Formulation2
where form_rxcui in (
'1549372',
'1000978',
'411846',
'1088455',
'1236182',
'198229',
'251135',
'836466',
'849329',
'854872',
'857705',
'992898',
'997550'
)
order by form_rxcui
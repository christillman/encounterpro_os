  
update c_Synonym set preferred_term = 'ascorbic acid' where term = 'ascorbic acid'
update c_Synonym set preferred_term = 'benzathine penicillin' where term = 'benzathine penicillin'
update c_Synonym set preferred_term = 'colaspase' where term = 'colaspase'
update c_Synonym set preferred_term = 'cyanocobalamin' where term = 'cyanocobalamin'
update c_Synonym set preferred_term = 'dihydrocodeine tartrate' where term = 'dihydrocodeine tartrate'
update c_Synonym set preferred_term = 'meclozine' where term = 'meclozine'
update c_Synonym set preferred_term = 'pericyazine' where term = 'pericyazine'
update c_Synonym set preferred_term = 'pethidine' where term = 'pethidine'
update c_Synonym set preferred_term = 'phytomenadione' where term = 'phytomenadione'
update c_Synonym set preferred_term = 'procaine benzylpenicillin' where term = 'procaine benzylpenicillin'
update c_Synonym set preferred_term = 'simeticone' where term = 'simeticone'
update c_Synonym set preferred_term = 'cLOMIFEne Citrate' where term = 'cLOMIFEne Citrate'
update c_Synonym set preferred_term = 'EPINEPHrine' where preferred_term = 'adrenaline'

-- Remove circular definitions
delete s1 from c_Synonym s1
join c_Synonym s2 on s2.term = s1.alternate
	and s2.alternate = s1.term
	and s1.preferred_term = s2.preferred_term
	and s1.alternate = s1.preferred_term
	
delete from c_Synonym where alternate = 'cycloSPORINE'
delete from c_Synonym where term = 'Vitamin D3'
delete from c_Synonym where alternate = 'carbocisteine'
delete from c_Synonym where alternate = 'Ethamsylate'
delete from c_Synonym where alternate = 'Vitamin K1'

update c_Synonym set term = 'ciclosPORIN', alternate = 'cyclosporin' where term = 'cyclosporin'
update c_Synonym set preferred_term = 'carbocisteine' where preferred_term = 'carbocysteine'
update c_Synonym set preferred_term = 'etamsylate' where preferred_term = 'Ethamsylate'
update c_Synonym set preferred_term = 'phytonadione' where preferred_term = 'Vitamin K1'
update c_Synonym set term = 'phylloquinone', alternate = 'Vitamin K1' where term = 'Vitamin K' and alternate = 'phytonadione'
update c_Synonym set term = 'phytomenadione', alternate = 'Vitamin K1' where term = 'Vitamin K1' and alternate = 'phytonadione'
update c_Synonym set preferred_term = 'vaginal insert' where term = 'Vaginal Pessary'
update c_Synonym set term_type = 'brand_name' where term like 'Aminosyn%'



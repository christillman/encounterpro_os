


update c_Dosage_Form
set [dosage_form] = replace([dosage_form],'*','')
-- select replace([dosage_form],'*','') from c_Dosage_Form
where [dosage_form] = 'Liquid**'

delete from c_Dosage_Form 
where [dosage_form] like '%*%'
    or [description] like '%*%'


update c_Drug_Tall_Man set spelling = 'doXEpin' where spelling = 'doXepin'
update c_Drug_Tall_Man set spelling = 'LaMISil' where spelling = 'laMISil'
update c_Drug_Tall_Man set spelling = 'meDROXYPROGESTERone' where spelling = 'medroxyPROGESTERone'
update c_Drug_Tall_Man set spelling = 'mOXifloxacin' where spelling = 'MOXifloxacin'
update c_Drug_Tall_Man set spelling = 'pACLitaxel' where spelling = 'PACLitaxel'
update c_Drug_Tall_Man set spelling = 'prEDNISone' where spelling = 'predniSONE'
update c_Drug_Tall_Man set spelling = 'sulfaDIazine' where spelling = 'sulfaDiazine'
delete from c_Drug_Tall_Man where spelling in ( 
'rifAMPin','OncoTICE','trimIPRAMINE','YaZ')

insert into c_Drug_Tall_Man values ('OncoTICE')
insert into c_Drug_Tall_Man values ('trimIPRAMINE')
insert into c_Drug_Tall_Man values ('YaZ')

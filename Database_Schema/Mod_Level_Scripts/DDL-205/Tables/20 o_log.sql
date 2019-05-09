
-- widen the message column so long messages don't get ignored
alter table o_log 
	alter column message varchar(1000) null
	
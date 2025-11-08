
IF (select count(*) from sys.columns c join sys.tables t on t.object_id = c.object_id where t.name = 'c_Observation_Result_Range' and c.name = 'detail') = 0
	ALTER TABLE c_Observation_Result_Range ADD detail varchar(100)
	

ALTER TABLE c_Observation_Result_Range ALTER COLUMN unit_id varchar(30)
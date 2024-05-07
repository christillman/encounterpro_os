
IF NOT EXISTS (SELECT 1 from sys.columns WHERE name = 'timezone') 
ALTER TABLE c_Database_Status ADD timezone varchar(40)



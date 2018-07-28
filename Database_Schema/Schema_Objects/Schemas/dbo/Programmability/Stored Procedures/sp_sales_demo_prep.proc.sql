CREATE PROCEDURE sp_sales_demo_prep 
AS
-- This procedure prepares a copy of the master database for use as a demo database

IF NOT EXISTS (SELECT domain_sequence FROM c_Domain WHERE domain_id = 'SYSTEM' AND domain_item = 'DEMOMODE')
	BEGIN
	RAISERROR ('Database is not in DEMO mode',16,-1)
	RETURN
	END

DELETE FROM o_Computers




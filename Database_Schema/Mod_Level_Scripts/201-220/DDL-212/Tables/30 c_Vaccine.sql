-- Add drug_id and form_rxcui to vaccine table to fully identify vaccine
if not exists (select * from sys.columns where object_id = object_id('c_Vaccine') and
	 name = 'drug_id')
	BEGIN
	
	SELECT * INTO #Vaccine 
	FROM c_Vaccine
	
	DROP TABLE [dbo].[c_Vaccine]
	CREATE TABLE [dbo].[c_Vaccine] (
    [vaccine_id]    VARCHAR (24) NOT NULL,
    [drug_id]    VARCHAR (24) NOT NULL,
    [description]   VARCHAR (200) NULL,
    [status]        VARCHAR (12) NULL,
    [sort_sequence] SMALLINT     NULL
	)
	ALTER TABLE [dbo].[c_Vaccine]
    ADD CONSTRAINT [PK_c_Vaccine_1__10] PRIMARY KEY CLUSTERED ([vaccine_id] ASC) 
	
	GRANT SELECT, INSERT, UPDATE, DELETE, REFERENCES ON [c_Vaccine] TO [cprsystem] 

	INSERT INTO c_Vaccine (
		vaccine_id,
		drug_id,
		description,
		status,
		sort_sequence
		)
	SELECT 
		vaccine_id,
		-- as a default, but we will be specifying drug_id separately going forward
		vaccine_id as drug_id,
		description,
		status,
		sort_sequence
	FROM #Vaccine v
	
	END
	
-- Note the insert and update triggers which maintained a link to
-- c_drug_definition are not re-created; this is now an independent table

SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

if exists (select * from sys.objects where object_id = object_id('tr_c_Vaccine_all') and
	 type = 'TR')
	DROP TRIGGER [dbo].[tr_c_Vaccine_all]
GO

	CREATE TRIGGER [dbo].[tr_c_Vaccine_all] ON [dbo].[c_Vaccine]
	FOR INSERT, UPDATE
	AS
	BEGIN
	IF @@ROWCOUNT = 0
		RETURN

	UPDATE c_Table_Update
	SET last_updated = getdate()
	WHERE table_name = 'c_vaccine'
	END

GO


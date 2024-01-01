
ALTER TABLE p_patient 
	ALTER COLUMN address_line_1 varchar(80)

IF (EXISTS(SELECT * FROM sys.objects WHERE [object_id] = OBJECT_ID(N'[dbo].[p_patient_list_item]') AND [type]='U'))
	DROP TABLE [dbo].[p_patient_list_item]
GO

CREATE TABLE p_patient_list_item (
	cpr_id varchar(24) NOT NULL,
	list_id varchar(24) NOT NULL, 
	list_item varchar(24) NOT NULL,
	list_item_patient_data varchar(80) NULL
	)

GRANT SELECT, INSERT, UPDATE, DELETE ON [dbo].[p_Patient_List_Item] TO CPRSYSTEM

-- Drop unused id column
IF EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[DF__p_Patient_Pr__id__3959501B]') AND type = 'D')
BEGIN
	ALTER TABLE [dbo].[p_Patient_Progress]
	DROP CONSTRAINT [DF__p_Patient_Pr__id__3959501B]
END
GO

IF EXISTS (SELECT * FROM sys.columns c 
		JOIN sys.tables t ON t.object_id = c.object_id
		WHERE c.object_id = OBJECT_ID(N'[dbo].[p_Patient_Progress]') AND c.name = 'id')
BEGIN
	ALTER TABLE p_Patient_Progress DROP COLUMN id
END
GO

DROP TRIGGER [tr_c_Drug_Formulation_insert_update]
GO
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[c_Drug_Formulation]') AND type in (N'U'))
DROP TABLE [c_Drug_Formulation]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [c_Drug_Formulation](
	[form_rxcui] [varchar](20) NOT NULL,
	[form_tty] [varchar](20) NULL,
	[form_descr] [varchar](1000) NULL,
	[ingr_rxcui] [varchar](20) NULL,
	[ingr_tty] [varchar](20) NULL,
	[valid_in] [varchar](100) NULL,
	[generic_form_rxcui] [varchar](20) NULL,
 CONSTRAINT [PK_Drug_Formulation] PRIMARY KEY CLUSTERED 
(
	[form_rxcui] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TRIGGER [tr_c_Drug_Formulation_insert_update]
ON [c_Drug_Formulation]
FOR INSERT, UPDATE 
AS 
	BEGIN 
	IF EXISTS (SELECT 1 FROM c_Drug_Formulation f
				JOIN inserted i ON i.form_descr = f.form_descr
				WHERE i.form_rxcui != f.form_rxcui)
		BEGIN
		RAISERROR ('Not a unique value for form_descr', 16, 10)
		-- Force Violation of PRIMARY KEY to prevent insertion
		INSERT INTO c_Drug_Formulation (form_rxcui)
		SELECT f.form_rxcui FROM c_Drug_Formulation f
		JOIN inserted i ON i.form_descr = f.form_descr
		END
	END
  

GO
ALTER TABLE [dbo].[c_Drug_Formulation] ENABLE TRIGGER [tr_c_Drug_Formulation_insert_update]
GO

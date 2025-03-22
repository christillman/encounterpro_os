
DROP TABLE IF EXISTS [dbo].[c_Drug_Generic]
GO

SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

SET ARITHABORT ON
GO

CREATE TABLE [dbo].[c_Drug_Generic](
	[generic_name] [varchar](2000) NOT NULL,
	[generic_rxcui] [varchar](30) NOT NULL,
	[is_single_ingredient] [bit] NOT NULL,
	[drug_id] [varchar](24) NULL,
	[mesh_definition] [varchar](800) NULL,
	[mesh_source] [varchar](100) NULL,
	[scope_note] [varchar](400) NULL,
	[dea_class] [varchar](10) NULL,
	[valid_in] [varchar](100) NULL,
	[uq_name_checksum]  AS (checksum([generic_name])) PERSISTED,
 CONSTRAINT [uq_generic_name] UNIQUE NONCLUSTERED 
(
	/* A unique constraint is required to avoid the error
		Warning! The maximum key length for a nonclustered index is 1700 bytes. The index 'uq_generic_name' has maximum length of 2000 bytes. For some combination of large values, the insert/update operation will fail.
	*/
	[uq_name_checksum] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO

CREATE UNIQUE INDEX uq_generic_drug_id ON c_Drug_Generic (drug_id)
GO
GRANT DELETE ON [dbo].[c_Drug_Generic] TO [cprsystem]
GO
GRANT INSERT ON [dbo].[c_Drug_Generic] TO [cprsystem]
GO
GRANT REFERENCES ON [dbo].[c_Drug_Generic] TO [cprsystem]
GO
GRANT SELECT ON [dbo].[c_Drug_Generic] TO [cprsystem]
GO
GRANT UPDATE ON [dbo].[c_Drug_Generic] TO [cprsystem]
GO

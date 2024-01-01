
SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
SET ANSI_PADDING ON
GO
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'c_EPC') AND type in (N'U'))
	DROP TABLE c_EPC
GO
CREATE TABLE c_EPC (generic_name varchar(250), epc_category varchar(100))

GRANT DELETE, INSERT, SELECT, UPDATE ON c_EPC TO [cprsystem] AS [dbo]
GO
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'c_Drug_EPC') AND type in (N'U'))
	DROP TABLE c_Drug_EPC
GO
CREATE TABLE c_Drug_EPC (drug_id varchar(24), epc_category varchar(100))

GRANT DELETE, INSERT, SELECT, UPDATE ON c_Drug_EPC TO [cprsystem] AS [dbo]
GO


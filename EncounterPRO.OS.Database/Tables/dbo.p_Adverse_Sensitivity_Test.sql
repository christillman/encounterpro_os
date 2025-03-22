IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[p_Adverse_Sensitivity_Test]') AND type in (N'U'))
DROP TABLE [p_Adverse_Sensitivity_Test]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [p_Adverse_Sensitivity_Test](
	[patient_id] [varchar](24) NOT NULL,
	[substance] [varchar](40) NOT NULL,
	[test_performed] [varchar](250) NULL,
	[test_result] [varchar](250) NULL
) ON [PRIMARY]
GO
GRANT DELETE ON [dbo].[p_Adverse_Sensitivity_Test] TO [cprsystem]
GO
GRANT INSERT ON [dbo].[p_Adverse_Sensitivity_Test] TO [cprsystem]
GO
GRANT REFERENCES ON [dbo].[p_Adverse_Sensitivity_Test] TO [cprsystem]
GO
GRANT SELECT ON [dbo].[p_Adverse_Sensitivity_Test] TO [cprsystem]
GO
GRANT UPDATE ON [dbo].[p_Adverse_Sensitivity_Test] TO [cprsystem]

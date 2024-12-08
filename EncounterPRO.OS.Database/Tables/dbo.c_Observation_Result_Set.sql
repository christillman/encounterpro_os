SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[c_Observation_Result_Set]') AND type in (N'U'))
BEGIN
CREATE TABLE [c_Observation_Result_Set](
	[result_set_id] [int] IDENTITY(1,1) NOT NULL,
	[description] [varchar](80) NOT NULL,
	[result_type] [varchar](12) NULL,
 CONSTRAINT [PK_c_Obs_Res_Set_27] PRIMARY KEY CLUSTERED 
(
	[result_set_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 100, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
END
GO
GRANT DELETE ON [c_Observation_Result_Set] TO [cprsystem] AS [dbo]
GRANT INSERT ON [c_Observation_Result_Set] TO [cprsystem] AS [dbo]
GRANT REFERENCES ON [c_Observation_Result_Set] TO [cprsystem] AS [dbo]
GRANT SELECT ON [c_Observation_Result_Set] TO [cprsystem] AS [dbo]
GRANT UPDATE ON [c_Observation_Result_Set] TO [cprsystem] AS [dbo]
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[DF__c_Observa__resul__743A1EC7]') AND type = 'D')
BEGIN
ALTER TABLE [c_Observation_Result_Set] ADD  CONSTRAINT [DF__c_Observa__resul__743A1EC7]  DEFAULT ('PERFORM') FOR [result_type]
END


ALTER TABLE [dbo].[c_External_Observation_Result]
    ADD CONSTRAINT [PK_c_c_Ext_Obs_Res_40] PRIMARY KEY CLUSTERED ([external_source] ASC, [external_observation] ASC, [external_observation_result_sequence] ASC) WITH (FILLFACTOR = 100, ALLOW_PAGE_LOCKS = ON, ALLOW_ROW_LOCKS = ON, PAD_INDEX = OFF, IGNORE_DUP_KEY = OFF, STATISTICS_NORECOMPUTE = OFF);


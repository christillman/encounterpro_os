ALTER TABLE [dbo].[c_Observation_Result]
    ADD CONSTRAINT [DF_c_obs_res_severity] DEFAULT ((0)) FOR [severity];


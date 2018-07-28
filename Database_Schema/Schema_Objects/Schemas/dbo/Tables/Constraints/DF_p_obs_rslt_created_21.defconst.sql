ALTER TABLE [dbo].[p_Observation_Result]
    ADD CONSTRAINT [DF_p_obs_rslt_created_21] DEFAULT (getdate()) FOR [created];


ALTER TABLE [dbo].[p_Observation_Result_Qualifier]
    ADD CONSTRAINT [DF_p_obs_rslt_qual_27] DEFAULT (getdate()) FOR [created];


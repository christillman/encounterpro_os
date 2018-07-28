ALTER TABLE [dbo].[p_Observation_Result]
    ADD CONSTRAINT [DF__p_Obs_result_abnflg] DEFAULT ('N') FOR [abnormal_flag];


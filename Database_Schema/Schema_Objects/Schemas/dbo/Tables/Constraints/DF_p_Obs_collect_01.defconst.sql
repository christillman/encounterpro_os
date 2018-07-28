ALTER TABLE [dbo].[p_Observation_Location]
    ADD CONSTRAINT [DF_p_Obs_collect_01] DEFAULT ('P') FOR [collect_perform_flag];


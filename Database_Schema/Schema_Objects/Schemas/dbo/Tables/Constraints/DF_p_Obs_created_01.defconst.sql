ALTER TABLE [dbo].[p_Observation_Location]
    ADD CONSTRAINT [DF_p_Obs_created_01] DEFAULT (getdate()) FOR [created];


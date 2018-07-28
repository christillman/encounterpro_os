ALTER TABLE [dbo].[p_Observation]
    ADD CONSTRAINT [DF_p_Observation_created_21] DEFAULT (getdate()) FOR [created];


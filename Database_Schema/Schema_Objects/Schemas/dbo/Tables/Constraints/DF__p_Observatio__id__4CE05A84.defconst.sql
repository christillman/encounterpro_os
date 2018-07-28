ALTER TABLE [dbo].[p_Observation]
    ADD CONSTRAINT [DF__p_Observatio__id__4CE05A84] DEFAULT (newid()) FOR [id];


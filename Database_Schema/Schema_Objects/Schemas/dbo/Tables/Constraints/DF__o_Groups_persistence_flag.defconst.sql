ALTER TABLE [dbo].[o_Groups]
    ADD CONSTRAINT [DF__o_Groups_persistence_flag] DEFAULT ('Y') FOR [persistence_flag];


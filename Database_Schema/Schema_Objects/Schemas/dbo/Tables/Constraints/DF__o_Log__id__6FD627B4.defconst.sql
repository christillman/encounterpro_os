ALTER TABLE [dbo].[o_Log]
    ADD CONSTRAINT [DF__o_Log__id__6FD627B4] DEFAULT (newid()) FOR [id];


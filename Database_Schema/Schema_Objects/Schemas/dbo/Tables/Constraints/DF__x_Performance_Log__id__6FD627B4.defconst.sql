ALTER TABLE [dbo].[x_Performance_Log]
    ADD CONSTRAINT [DF__x_Performance_Log__id__6FD627B4] DEFAULT (newid()) FOR [id];


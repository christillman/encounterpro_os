ALTER TABLE [dbo].[o_Message_Log]
    ADD CONSTRAINT [DF_o_Message_Log_batch_mode] DEFAULT ('N') FOR [batch_mode];


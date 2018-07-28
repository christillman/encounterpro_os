ALTER TABLE [dbo].[o_Log]
    ADD CONSTRAINT [DF__o_Log_spid_127] DEFAULT (@@spid) FOR [spid];


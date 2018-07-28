ALTER TABLE [dbo].[o_Message_Log]
    ADD CONSTRAINT [DF__o_Message_Lo__id__0FADFA69] DEFAULT (newid()) FOR [id];


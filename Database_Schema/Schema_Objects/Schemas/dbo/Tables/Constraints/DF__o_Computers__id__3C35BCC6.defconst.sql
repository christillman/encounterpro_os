ALTER TABLE [dbo].[o_Computers]
    ADD CONSTRAINT [DF__o_Computers__id__3C35BCC6] DEFAULT (newid()) FOR [id];


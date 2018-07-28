ALTER TABLE [dbo].[p_Attachment]
    ADD CONSTRAINT [DF_p_att_created_40] DEFAULT (getdate()) FOR [created];


ALTER TABLE [dbo].[p_Attachment_Progress]
    ADD CONSTRAINT [DF_p_att_pr_created_40] DEFAULT (getdate()) FOR [created];


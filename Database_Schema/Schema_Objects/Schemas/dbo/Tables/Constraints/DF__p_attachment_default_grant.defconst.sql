ALTER TABLE [dbo].[p_Attachment]
    ADD CONSTRAINT [DF__p_attachment_default_grant] DEFAULT ((1)) FOR [default_grant];


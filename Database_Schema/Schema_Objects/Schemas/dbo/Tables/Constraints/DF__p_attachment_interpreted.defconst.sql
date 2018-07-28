ALTER TABLE [dbo].[p_Attachment]
    ADD CONSTRAINT [DF__p_attachment_interpreted] DEFAULT ((0)) FOR [interpreted];


ALTER TABLE [dbo].[p_Attachment_Progress]
    ADD CONSTRAINT [DF__p_Attachment__id__5DA0D232] DEFAULT (newid()) FOR [id];


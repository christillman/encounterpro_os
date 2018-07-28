ALTER TABLE [dbo].[p_Attachment]
    ADD CONSTRAINT [DF__p_Attachment__id__550B8C31] DEFAULT (newid()) FOR [id];


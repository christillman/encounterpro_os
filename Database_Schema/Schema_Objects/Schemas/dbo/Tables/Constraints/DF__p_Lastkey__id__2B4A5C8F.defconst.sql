ALTER TABLE [dbo].[p_Lastkey]
    ADD CONSTRAINT [DF__p_Lastkey__id__2B4A5C8F] DEFAULT (newid()) FOR [id];


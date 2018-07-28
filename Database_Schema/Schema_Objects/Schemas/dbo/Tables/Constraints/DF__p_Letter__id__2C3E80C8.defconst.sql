ALTER TABLE [dbo].[p_Letter]
    ADD CONSTRAINT [DF__p_Letter__id__2C3E80C8] DEFAULT (newid()) FOR [id];


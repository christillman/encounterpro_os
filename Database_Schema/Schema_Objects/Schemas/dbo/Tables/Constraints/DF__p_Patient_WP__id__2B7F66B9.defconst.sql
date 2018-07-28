ALTER TABLE [dbo].[p_Patient_WP]
    ADD CONSTRAINT [DF__p_Patient_WP__id__2B7F66B9] DEFAULT (newid()) FOR [id];


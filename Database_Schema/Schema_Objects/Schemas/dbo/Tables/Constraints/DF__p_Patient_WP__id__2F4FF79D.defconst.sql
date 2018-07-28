ALTER TABLE [dbo].[p_Patient_WP_Item]
    ADD CONSTRAINT [DF__p_Patient_WP__id__2F4FF79D] DEFAULT (newid()) FOR [id];


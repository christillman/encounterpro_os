ALTER TABLE [dbo].[p_Patient_WP_Item_Progress]
    ADD CONSTRAINT [DF_p_Patient_WP_Item_Progress_created] DEFAULT (getdate()) FOR [created];


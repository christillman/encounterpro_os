ALTER TABLE [dbo].[p_Patient_WP_Item]
    ADD CONSTRAINT [DF_p_Patient_Workplan_Item_created] DEFAULT (getdate()) FOR [created];


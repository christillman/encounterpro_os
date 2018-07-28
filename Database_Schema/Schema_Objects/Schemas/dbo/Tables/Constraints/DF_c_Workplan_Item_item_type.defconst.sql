ALTER TABLE [dbo].[c_Workplan_Item]
    ADD CONSTRAINT [DF_c_Workplan_Item_item_type] DEFAULT ('Service') FOR [item_type];


ALTER TABLE [dbo].[c_Workplan_Item_Attribute]
    ADD CONSTRAINT [PK_c_Workplan_Item_Attribute] PRIMARY KEY CLUSTERED ([workplan_id] ASC, [item_number] ASC, [attribute_sequence] ASC) WITH (FILLFACTOR = 100, ALLOW_PAGE_LOCKS = ON, ALLOW_ROW_LOCKS = ON, PAD_INDEX = OFF, IGNORE_DUP_KEY = OFF, STATISTICS_NORECOMPUTE = OFF);


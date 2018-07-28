ALTER TABLE [dbo].[p_Patient_WP_Item_Attribute_Archive]
    ADD CONSTRAINT [PK_p_Patient_WP_Item_Attribute_Archive] PRIMARY KEY NONCLUSTERED ([patient_workplan_item_id] ASC, [attribute_sequence] ASC) WITH (FILLFACTOR = 95, ALLOW_PAGE_LOCKS = ON, ALLOW_ROW_LOCKS = ON, PAD_INDEX = OFF, IGNORE_DUP_KEY = OFF, STATISTICS_NORECOMPUTE = OFF) ON [Workflow];


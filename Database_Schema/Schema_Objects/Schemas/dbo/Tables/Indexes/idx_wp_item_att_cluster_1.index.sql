CREATE CLUSTERED INDEX [idx_wp_item_att_cluster]
    ON [dbo].[p_Patient_WP_Item_Attribute_Archive]([cpr_id] ASC, [patient_workplan_item_id] ASC, [attribute_sequence] ASC) WITH (FILLFACTOR = 80, ALLOW_PAGE_LOCKS = ON, ALLOW_ROW_LOCKS = ON, PAD_INDEX = ON, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, IGNORE_DUP_KEY = OFF, STATISTICS_NORECOMPUTE = OFF, ONLINE = OFF, MAXDOP = 0);


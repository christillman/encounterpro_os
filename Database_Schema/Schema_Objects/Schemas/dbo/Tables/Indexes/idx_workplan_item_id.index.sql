CREATE UNIQUE NONCLUSTERED INDEX [idx_workplan_item_id]
    ON [dbo].[p_Patient_WP_Item]([patient_workplan_id] ASC, [patient_workplan_item_id] ASC, [item_number] ASC) WITH (FILLFACTOR = 70, ALLOW_PAGE_LOCKS = ON, ALLOW_ROW_LOCKS = ON, PAD_INDEX = ON, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, IGNORE_DUP_KEY = OFF, STATISTICS_NORECOMPUTE = OFF, ONLINE = OFF, MAXDOP = 0)
    ON [Workflow];


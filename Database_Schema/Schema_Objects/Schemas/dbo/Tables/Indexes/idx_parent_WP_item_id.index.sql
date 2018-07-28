CREATE NONCLUSTERED INDEX [idx_parent_WP_item_id]
    ON [dbo].[p_Patient_WP]([parent_patient_workplan_item_id] ASC, [patient_workplan_id] ASC, [in_office_flag] ASC) WITH (FILLFACTOR = 80, ALLOW_PAGE_LOCKS = ON, ALLOW_ROW_LOCKS = ON, PAD_INDEX = ON, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, IGNORE_DUP_KEY = OFF, STATISTICS_NORECOMPUTE = OFF, ONLINE = OFF, MAXDOP = 0)
    ON [Workflow];


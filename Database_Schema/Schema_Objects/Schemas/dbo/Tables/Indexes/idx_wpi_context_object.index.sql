CREATE NONCLUSTERED INDEX [idx_wpi_context_object]
    ON [dbo].[p_Patient_WP_Item]([cpr_id] ASC, [context_object] ASC, [encounter_id] ASC, [treatment_id] ASC) WITH (FILLFACTOR = 70, ALLOW_PAGE_LOCKS = ON, ALLOW_ROW_LOCKS = ON, PAD_INDEX = ON, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, IGNORE_DUP_KEY = OFF, STATISTICS_NORECOMPUTE = OFF, ONLINE = OFF, MAXDOP = 0)
    ON [Workflow];


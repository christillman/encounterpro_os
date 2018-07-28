CREATE NONCLUSTERED INDEX [idx_ordered_by]
    ON [dbo].[p_Patient_WP_Item]([ordered_by] ASC, [ordered_service] ASC, [dispatch_date] ASC) WITH (FILLFACTOR = 70, ALLOW_PAGE_LOCKS = ON, ALLOW_ROW_LOCKS = ON, PAD_INDEX = ON, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, IGNORE_DUP_KEY = OFF, STATISTICS_NORECOMPUTE = OFF, ONLINE = OFF, MAXDOP = 0)
    ON [Workflow];


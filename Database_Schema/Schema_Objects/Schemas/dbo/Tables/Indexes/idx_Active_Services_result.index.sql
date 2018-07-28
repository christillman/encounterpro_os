CREATE NONCLUSTERED INDEX [idx_Active_Services_result]
    ON [dbo].[o_Active_Services]([cpr_id] ASC, [treatment_id] ASC, [observation_id] ASC, [result_sequence] ASC) WITH (FILLFACTOR = 80, ALLOW_PAGE_LOCKS = ON, ALLOW_ROW_LOCKS = ON, PAD_INDEX = ON, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, IGNORE_DUP_KEY = OFF, STATISTICS_NORECOMPUTE = OFF, ONLINE = OFF, MAXDOP = 0)
    ON [PRIMARY];


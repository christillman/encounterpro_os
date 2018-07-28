CREATE NONCLUSTERED INDEX [idx_observation_id_result_sequence]
    ON [dbo].[p_Observation_Result]([cpr_id] ASC, [observation_id] ASC, [result_sequence] ASC) WITH (FILLFACTOR = 90, ALLOW_PAGE_LOCKS = ON, ALLOW_ROW_LOCKS = ON, PAD_INDEX = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, IGNORE_DUP_KEY = OFF, STATISTICS_NORECOMPUTE = OFF, ONLINE = OFF, MAXDOP = 0)
    ON [PRIMARY];


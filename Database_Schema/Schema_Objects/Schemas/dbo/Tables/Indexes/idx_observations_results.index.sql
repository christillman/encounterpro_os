CREATE NONCLUSTERED INDEX [idx_observations_results]
    ON [dbo].[p_Observation_Result]([observation_id] ASC, [result_sequence] ASC, [cpr_id] ASC, [location_result_sequence] ASC, [current_flag] ASC, [result_date_time] ASC) WITH (FILLFACTOR = 90, ALLOW_PAGE_LOCKS = ON, ALLOW_ROW_LOCKS = ON, PAD_INDEX = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, IGNORE_DUP_KEY = OFF, STATISTICS_NORECOMPUTE = OFF, ONLINE = OFF, MAXDOP = 0)
    ON [PRIMARY];


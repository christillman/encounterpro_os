CREATE NONCLUSTERED INDEX [idx_obs_res_prg_treatment]
    ON [dbo].[p_Observation_Result_Progress]([cpr_id] ASC, [treatment_id] ASC, [observation_sequence] ASC, [location_result_sequence] ASC, [result_progress_sequence] ASC) WITH (ALLOW_PAGE_LOCKS = ON, ALLOW_ROW_LOCKS = ON, PAD_INDEX = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, IGNORE_DUP_KEY = OFF, STATISTICS_NORECOMPUTE = OFF, ONLINE = OFF, MAXDOP = 0)
    ON [PRIMARY];


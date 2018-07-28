CREATE NONCLUSTERED INDEX [idx_aprg_current_flag]
    ON [dbo].[p_assessment_Progress]([cpr_id] ASC, [problem_id] ASC, [current_flag] ASC, [progress_type] ASC, [progress_key] ASC) WITH (FILLFACTOR = 70, ALLOW_PAGE_LOCKS = ON, ALLOW_ROW_LOCKS = ON, PAD_INDEX = ON, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, IGNORE_DUP_KEY = OFF, STATISTICS_NORECOMPUTE = OFF, ONLINE = OFF, MAXDOP = 0)
    ON [PRIMARY];


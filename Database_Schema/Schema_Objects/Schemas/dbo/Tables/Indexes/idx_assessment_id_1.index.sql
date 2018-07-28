CREATE NONCLUSTERED INDEX [idx_assessment_id]
    ON [dbo].[p_Assessment]([assessment_id] ASC, [assessment_status] ASC, [cpr_id] ASC, [problem_id] ASC, [created] ASC) WITH (FILLFACTOR = 80, ALLOW_PAGE_LOCKS = ON, ALLOW_ROW_LOCKS = ON, PAD_INDEX = ON, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, IGNORE_DUP_KEY = OFF, STATISTICS_NORECOMPUTE = OFF, ONLINE = OFF, MAXDOP = 0)
    ON [PRIMARY];


CREATE NONCLUSTERED INDEX [idx_observation_id]
    ON [dbo].[em_Observation_Element]([observation_id] ASC, [em_component] ASC, [em_type] ASC, [em_category] ASC, [em_element] ASC) WITH (FILLFACTOR = 100, ALLOW_PAGE_LOCKS = ON, ALLOW_ROW_LOCKS = ON, PAD_INDEX = ON, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, IGNORE_DUP_KEY = OFF, STATISTICS_NORECOMPUTE = OFF, ONLINE = OFF, MAXDOP = 0)
    ON [PRIMARY];


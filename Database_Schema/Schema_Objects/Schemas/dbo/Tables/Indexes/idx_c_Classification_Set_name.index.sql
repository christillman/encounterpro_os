CREATE UNIQUE NONCLUSTERED INDEX [idx_c_Classification_Set_name]
    ON [dbo].[c_Classification_Set]([owner_id] ASC, [classification_set_type] ASC, [classification_set_name] ASC) WITH (FILLFACTOR = 70, ALLOW_PAGE_LOCKS = ON, ALLOW_ROW_LOCKS = ON, PAD_INDEX = ON, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, IGNORE_DUP_KEY = OFF, STATISTICS_NORECOMPUTE = OFF, ONLINE = OFF, MAXDOP = 0)
    ON [PRIMARY];


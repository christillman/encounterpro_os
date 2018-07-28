CREATE NONCLUSTERED INDEX [idx_c_Display_Command_Definition_id]
    ON [dbo].[c_Display_Command_Definition]([id] ASC, [script_type] ASC, [context_object] ASC, [display_command] ASC) WITH (FILLFACTOR = 80, ALLOW_PAGE_LOCKS = ON, ALLOW_ROW_LOCKS = ON, PAD_INDEX = ON, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, IGNORE_DUP_KEY = OFF, STATISTICS_NORECOMPUTE = OFF, ONLINE = OFF, MAXDOP = 0)
    ON [PRIMARY];


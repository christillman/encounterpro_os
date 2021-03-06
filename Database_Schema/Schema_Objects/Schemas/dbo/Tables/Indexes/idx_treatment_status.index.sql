﻿CREATE NONCLUSTERED INDEX [idx_treatment_status]
    ON [dbo].[p_Treatment_Item]([treatment_status] ASC, [treatment_type] ASC, [cpr_id] ASC, [treatment_id] ASC) WITH (FILLFACTOR = 70, ALLOW_PAGE_LOCKS = ON, ALLOW_ROW_LOCKS = ON, PAD_INDEX = ON, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, IGNORE_DUP_KEY = OFF, STATISTICS_NORECOMPUTE = OFF, ONLINE = OFF, MAXDOP = 0)
    ON [PRIMARY];


﻿ALTER TABLE [dbo].[c_Equivalence]
    ADD CONSTRAINT [PK_c_Equivalence_1__11] PRIMARY KEY NONCLUSTERED ([object_id] ASC) WITH (FILLFACTOR = 70, ALLOW_PAGE_LOCKS = ON, ALLOW_ROW_LOCKS = ON, PAD_INDEX = OFF, IGNORE_DUP_KEY = OFF, STATISTICS_NORECOMPUTE = OFF) ON [PRIMARY];

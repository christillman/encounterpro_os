﻿ALTER TABLE [dbo].[c_Office]
    ADD CONSTRAINT [UQ_c_Office_xxx] UNIQUE NONCLUSTERED ([office_number] ASC) WITH (FILLFACTOR = 100, ALLOW_PAGE_LOCKS = ON, ALLOW_ROW_LOCKS = ON, PAD_INDEX = OFF, IGNORE_DUP_KEY = OFF, STATISTICS_NORECOMPUTE = OFF) ON [PRIMARY];

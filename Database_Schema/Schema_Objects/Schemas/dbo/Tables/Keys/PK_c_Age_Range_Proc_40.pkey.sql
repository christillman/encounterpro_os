﻿ALTER TABLE [dbo].[c_Age_Range_Procedure]
    ADD CONSTRAINT [PK_c_Age_Range_Proc_40] PRIMARY KEY CLUSTERED ([list_id] ASC, [age_range_id] ASC, [procedure_id] ASC) WITH (FILLFACTOR = 100, ALLOW_PAGE_LOCKS = ON, ALLOW_ROW_LOCKS = ON, PAD_INDEX = OFF, IGNORE_DUP_KEY = OFF, STATISTICS_NORECOMPUTE = OFF);

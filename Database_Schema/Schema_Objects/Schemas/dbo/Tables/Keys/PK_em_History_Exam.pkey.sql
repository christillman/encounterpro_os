﻿ALTER TABLE [dbo].[em_Type]
    ADD CONSTRAINT [PK_em_History_Exam] PRIMARY KEY CLUSTERED ([em_component] ASC, [em_type] ASC) WITH (FILLFACTOR = 100, ALLOW_PAGE_LOCKS = ON, ALLOW_ROW_LOCKS = ON, PAD_INDEX = OFF, IGNORE_DUP_KEY = OFF, STATISTICS_NORECOMPUTE = OFF);

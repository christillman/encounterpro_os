﻿ALTER TABLE [dbo].[em_Visit_Level]
    ADD CONSTRAINT [PK_em_Visit_Level] PRIMARY KEY CLUSTERED ([visit_level] ASC) WITH (FILLFACTOR = 100, ALLOW_PAGE_LOCKS = ON, ALLOW_ROW_LOCKS = ON, PAD_INDEX = OFF, IGNORE_DUP_KEY = OFF, STATISTICS_NORECOMPUTE = OFF);

﻿ALTER TABLE [dbo].[c_Qualifier]
    ADD CONSTRAINT [PK_c_Qualifier_21] PRIMARY KEY CLUSTERED ([qualifier_domain_id] ASC, [qualifier_sequence] ASC) WITH (FILLFACTOR = 100, ALLOW_PAGE_LOCKS = ON, ALLOW_ROW_LOCKS = ON, PAD_INDEX = OFF, IGNORE_DUP_KEY = OFF, STATISTICS_NORECOMPUTE = OFF);

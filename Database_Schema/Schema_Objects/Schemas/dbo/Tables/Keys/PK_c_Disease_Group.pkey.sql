﻿ALTER TABLE [dbo].[c_Disease_Group]
    ADD CONSTRAINT [PK_c_Disease_Group] PRIMARY KEY CLUSTERED ([disease_group] ASC) WITH (FILLFACTOR = 100, ALLOW_PAGE_LOCKS = ON, ALLOW_ROW_LOCKS = ON, PAD_INDEX = OFF, IGNORE_DUP_KEY = OFF, STATISTICS_NORECOMPUTE = OFF);

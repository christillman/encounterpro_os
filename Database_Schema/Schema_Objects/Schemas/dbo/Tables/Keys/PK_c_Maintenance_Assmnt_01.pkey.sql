﻿ALTER TABLE [dbo].[c_Maintenance_Assessment]
    ADD CONSTRAINT [PK_c_Maintenance_Assmnt_01] PRIMARY KEY CLUSTERED ([maintenance_rule_id] ASC, [assessment_id] ASC) WITH (FILLFACTOR = 100, ALLOW_PAGE_LOCKS = ON, ALLOW_ROW_LOCKS = ON, PAD_INDEX = OFF, IGNORE_DUP_KEY = OFF, STATISTICS_NORECOMPUTE = OFF);


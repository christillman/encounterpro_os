﻿ALTER TABLE [dbo].[c_Encounter_Type]
    ADD CONSTRAINT [PK_c_Encounter_type_40] PRIMARY KEY CLUSTERED ([encounter_type] ASC) WITH (FILLFACTOR = 100, ALLOW_PAGE_LOCKS = ON, ALLOW_ROW_LOCKS = ON, PAD_INDEX = OFF, IGNORE_DUP_KEY = OFF, STATISTICS_NORECOMPUTE = OFF);

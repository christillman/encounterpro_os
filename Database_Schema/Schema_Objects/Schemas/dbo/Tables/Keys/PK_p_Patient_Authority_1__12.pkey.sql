﻿ALTER TABLE [dbo].[p_Patient_Authority]
    ADD CONSTRAINT [PK_p_Patient_Authority_1__12] PRIMARY KEY CLUSTERED ([cpr_id] ASC, [authority_type] ASC, [authority_sequence] ASC) WITH (FILLFACTOR = 80, ALLOW_PAGE_LOCKS = ON, ALLOW_ROW_LOCKS = ON, PAD_INDEX = OFF, IGNORE_DUP_KEY = OFF, STATISTICS_NORECOMPUTE = OFF);

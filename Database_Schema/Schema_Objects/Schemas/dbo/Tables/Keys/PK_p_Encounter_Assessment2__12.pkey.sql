﻿ALTER TABLE [dbo].[p_Encounter_Assessment_Charge]
    ADD CONSTRAINT [PK_p_Encounter_Assessment2__12] PRIMARY KEY CLUSTERED ([cpr_id] ASC, [encounter_id] ASC, [problem_id] ASC, [encounter_charge_id] ASC) WITH (FILLFACTOR = 80, ALLOW_PAGE_LOCKS = ON, ALLOW_ROW_LOCKS = ON, PAD_INDEX = OFF, IGNORE_DUP_KEY = OFF, STATISTICS_NORECOMPUTE = OFF);

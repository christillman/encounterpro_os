﻿ALTER TABLE [dbo].[c_Observation_Result_Set_Item]
    ADD CONSTRAINT [PK_c_Obs_Res_Set_Item_27] PRIMARY KEY CLUSTERED ([result_set_id] ASC, [result_sequence] ASC) WITH (FILLFACTOR = 100, ALLOW_PAGE_LOCKS = ON, ALLOW_ROW_LOCKS = ON, PAD_INDEX = OFF, IGNORE_DUP_KEY = OFF, STATISTICS_NORECOMPUTE = OFF);

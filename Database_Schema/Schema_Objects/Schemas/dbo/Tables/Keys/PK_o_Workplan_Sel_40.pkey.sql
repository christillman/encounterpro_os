﻿ALTER TABLE [dbo].[c_Workplan_Selection]
    ADD CONSTRAINT [PK_o_Workplan_Sel_40] PRIMARY KEY CLUSTERED ([workplan_selection_id] ASC) WITH (FILLFACTOR = 100, ALLOW_PAGE_LOCKS = ON, ALLOW_ROW_LOCKS = ON, PAD_INDEX = OFF, IGNORE_DUP_KEY = OFF, STATISTICS_NORECOMPUTE = OFF);

﻿ALTER TABLE [dbo].[c_Treatment_Type_List_Def]
    ADD CONSTRAINT [PK_c_trtmnt_type_list_def_40] PRIMARY KEY CLUSTERED ([treatment_list_id] ASC) WITH (FILLFACTOR = 100, ALLOW_PAGE_LOCKS = ON, ALLOW_ROW_LOCKS = ON, PAD_INDEX = OFF, IGNORE_DUP_KEY = OFF, STATISTICS_NORECOMPUTE = OFF);

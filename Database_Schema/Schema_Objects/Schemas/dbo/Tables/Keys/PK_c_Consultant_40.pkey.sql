﻿ALTER TABLE [dbo].[c_Consultant]
    ADD CONSTRAINT [PK_c_Consultant_40] PRIMARY KEY CLUSTERED ([consultant_id] ASC) WITH (FILLFACTOR = 90, ALLOW_PAGE_LOCKS = ON, ALLOW_ROW_LOCKS = ON, PAD_INDEX = OFF, IGNORE_DUP_KEY = OFF, STATISTICS_NORECOMPUTE = OFF);

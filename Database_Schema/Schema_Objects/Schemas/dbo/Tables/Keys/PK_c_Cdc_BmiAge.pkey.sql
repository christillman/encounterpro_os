﻿ALTER TABLE [dbo].[c_Cdc_BmiAge]
    ADD CONSTRAINT [PK_c_Cdc_BmiAge] PRIMARY KEY CLUSTERED ([sex] ASC, [Months] ASC) WITH (FILLFACTOR = 100, ALLOW_PAGE_LOCKS = ON, ALLOW_ROW_LOCKS = ON, PAD_INDEX = OFF, IGNORE_DUP_KEY = OFF, STATISTICS_NORECOMPUTE = OFF);

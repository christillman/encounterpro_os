﻿ALTER TABLE [dbo].[c_Vial_Schedule]
    ADD CONSTRAINT [PK_c_Vial_Schedule_1__11] PRIMARY KEY CLUSTERED ([vial_schedule] ASC, [dose_number] ASC) WITH (FILLFACTOR = 70, ALLOW_PAGE_LOCKS = ON, ALLOW_ROW_LOCKS = ON, PAD_INDEX = OFF, IGNORE_DUP_KEY = OFF, STATISTICS_NORECOMPUTE = OFF);

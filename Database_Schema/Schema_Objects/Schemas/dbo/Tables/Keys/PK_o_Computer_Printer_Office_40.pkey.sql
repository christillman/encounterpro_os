﻿ALTER TABLE [dbo].[o_Computer_Printer_Office]
    ADD CONSTRAINT [PK_o_Computer_Printer_Office_40] PRIMARY KEY CLUSTERED ([computer_id] ASC, [printer] ASC, [office_id] ASC) WITH (FILLFACTOR = 70, ALLOW_PAGE_LOCKS = ON, ALLOW_ROW_LOCKS = ON, PAD_INDEX = OFF, IGNORE_DUP_KEY = OFF, STATISTICS_NORECOMPUTE = OFF);


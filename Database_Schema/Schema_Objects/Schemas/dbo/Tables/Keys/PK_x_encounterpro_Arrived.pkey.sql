﻿ALTER TABLE [dbo].[x_encounterpro_Arrived]
    ADD CONSTRAINT [PK_x_encounterpro_Arrived] PRIMARY KEY CLUSTERED ([message_id] ASC) WITH (FILLFACTOR = 80, ALLOW_PAGE_LOCKS = ON, ALLOW_ROW_LOCKS = ON, PAD_INDEX = OFF, IGNORE_DUP_KEY = OFF, STATISTICS_NORECOMPUTE = OFF);

﻿ALTER TABLE [dbo].[c_Message_Definition]
    ADD CONSTRAINT [PK___2__13] PRIMARY KEY CLUSTERED ([message_type] ASC) WITH (FILLFACTOR = 100, ALLOW_PAGE_LOCKS = ON, ALLOW_ROW_LOCKS = ON, PAD_INDEX = OFF, IGNORE_DUP_KEY = OFF, STATISTICS_NORECOMPUTE = OFF);

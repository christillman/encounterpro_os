﻿ALTER TABLE [dbo].[o_Event_Component_Trigger]
    ADD CONSTRAINT [PK___2__11] PRIMARY KEY CLUSTERED ([event] ASC, [component_sequence] ASC) WITH (FILLFACTOR = 100, ALLOW_PAGE_LOCKS = ON, ALLOW_ROW_LOCKS = ON, PAD_INDEX = OFF, IGNORE_DUP_KEY = OFF, STATISTICS_NORECOMPUTE = OFF);

﻿ALTER TABLE [dbo].[c_Component_Definition]
    ADD CONSTRAINT [PK_component_definition] PRIMARY KEY CLUSTERED ([component_id] ASC) WITH (FILLFACTOR = 100, ALLOW_PAGE_LOCKS = ON, ALLOW_ROW_LOCKS = ON, PAD_INDEX = OFF, IGNORE_DUP_KEY = OFF, STATISTICS_NORECOMPUTE = OFF);

﻿ALTER TABLE [dbo].[c_Config_Object_Type]
    ADD CONSTRAINT [PK_c_Config_Object_Type] PRIMARY KEY CLUSTERED ([config_object_type] ASC) WITH (FILLFACTOR = 70, ALLOW_PAGE_LOCKS = ON, ALLOW_ROW_LOCKS = ON, PAD_INDEX = OFF, IGNORE_DUP_KEY = OFF, STATISTICS_NORECOMPUTE = OFF);

﻿ALTER TABLE [dbo].[c_Config_Object_Library]
    ADD CONSTRAINT [DF_c_Config_Object_Library_status] DEFAULT ('OK') FOR [status];

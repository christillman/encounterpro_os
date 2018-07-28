ALTER TABLE [dbo].[c_Config_Object]
    ADD CONSTRAINT [DF_c_Config_Object_status] DEFAULT ('OK') FOR [status];


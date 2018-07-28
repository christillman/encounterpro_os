ALTER TABLE [dbo].[c_Config_Object_Version]
    ADD CONSTRAINT [DF_c_Config_Object_Version_status] DEFAULT ('CheckedIn') FOR [status];


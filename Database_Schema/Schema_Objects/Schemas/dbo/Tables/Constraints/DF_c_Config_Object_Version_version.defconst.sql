ALTER TABLE [dbo].[c_Config_Object_Version]
    ADD CONSTRAINT [DF_c_Config_Object_Version_version] DEFAULT ((1)) FOR [version];


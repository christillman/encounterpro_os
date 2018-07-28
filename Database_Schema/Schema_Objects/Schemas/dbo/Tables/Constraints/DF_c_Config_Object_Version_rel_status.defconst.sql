ALTER TABLE [dbo].[c_Config_Object_Version]
    ADD CONSTRAINT [DF_c_Config_Object_Version_rel_status] DEFAULT ('Production') FOR [release_status];


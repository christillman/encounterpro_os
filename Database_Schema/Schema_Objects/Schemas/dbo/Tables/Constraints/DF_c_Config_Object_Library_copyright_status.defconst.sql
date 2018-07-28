ALTER TABLE [dbo].[c_Config_Object_Library]
    ADD CONSTRAINT [DF_c_Config_Object_Library_copyright_status] DEFAULT ('Owner') FOR [copyright_status];


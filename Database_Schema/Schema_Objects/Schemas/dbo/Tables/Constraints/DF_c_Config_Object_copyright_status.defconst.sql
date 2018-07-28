ALTER TABLE [dbo].[c_Config_Object]
    ADD CONSTRAINT [DF_c_Config_Object_copyright_status] DEFAULT ('Owner') FOR [copyright_status];


ALTER TABLE [dbo].[c_Config_Object_Type]
    ADD CONSTRAINT [DF_c_Config_Object_Type_created] DEFAULT (getdate()) FOR [created];


ALTER TABLE [dbo].[c_Config_Object_Category]
    ADD CONSTRAINT [PK_c_Config_Object_Category] PRIMARY KEY CLUSTERED ([config_object_type] ASC, [context_object] ASC, [config_object_category] ASC) WITH (FILLFACTOR = 70, ALLOW_PAGE_LOCKS = ON, ALLOW_ROW_LOCKS = ON, PAD_INDEX = OFF, IGNORE_DUP_KEY = OFF, STATISTICS_NORECOMPUTE = OFF);


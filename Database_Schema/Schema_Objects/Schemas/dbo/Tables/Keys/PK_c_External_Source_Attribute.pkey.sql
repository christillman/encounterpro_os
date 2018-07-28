ALTER TABLE [dbo].[o_External_Source_Attribute]
    ADD CONSTRAINT [PK_c_External_Source_Attribute] PRIMARY KEY CLUSTERED ([external_source] ASC, [attribute_sequence] ASC) WITH (FILLFACTOR = 100, ALLOW_PAGE_LOCKS = ON, ALLOW_ROW_LOCKS = ON, PAD_INDEX = OFF, IGNORE_DUP_KEY = OFF, STATISTICS_NORECOMPUTE = OFF);


ALTER TABLE [dbo].[c_Component_Base_Attribute_Def]
    ADD CONSTRAINT [PK_comp_base_att_def] PRIMARY KEY CLUSTERED ([component_type] ASC, [component] ASC, [attribute] ASC) WITH (FILLFACTOR = 100, ALLOW_PAGE_LOCKS = ON, ALLOW_ROW_LOCKS = ON, PAD_INDEX = OFF, IGNORE_DUP_KEY = OFF, STATISTICS_NORECOMPUTE = OFF);


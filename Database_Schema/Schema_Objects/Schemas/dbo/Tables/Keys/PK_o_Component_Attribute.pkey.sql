ALTER TABLE [dbo].[o_Component_Attribute]
    ADD CONSTRAINT [PK_o_Component_Attribute] PRIMARY KEY CLUSTERED ([component_id] ASC, [office_id] ASC, [attribute_sequence] ASC) WITH (FILLFACTOR = 100, ALLOW_PAGE_LOCKS = ON, ALLOW_ROW_LOCKS = ON, PAD_INDEX = OFF, IGNORE_DUP_KEY = OFF, STATISTICS_NORECOMPUTE = OFF);


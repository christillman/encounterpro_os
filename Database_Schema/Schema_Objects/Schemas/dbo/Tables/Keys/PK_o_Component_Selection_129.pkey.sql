ALTER TABLE [dbo].[o_Component_Selection]
    ADD CONSTRAINT [PK_o_Component_Selection_129] PRIMARY KEY CLUSTERED ([component_type] ASC, [office_id] ASC, [component_id] ASC) WITH (FILLFACTOR = 100, ALLOW_PAGE_LOCKS = ON, ALLOW_ROW_LOCKS = ON, PAD_INDEX = OFF, IGNORE_DUP_KEY = OFF, STATISTICS_NORECOMPUTE = OFF);


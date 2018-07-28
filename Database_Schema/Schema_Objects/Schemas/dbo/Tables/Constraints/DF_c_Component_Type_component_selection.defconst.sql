ALTER TABLE [dbo].[c_Component_Type]
    ADD CONSTRAINT [DF_c_Component_Type_component_selection] DEFAULT ('Any') FOR [component_selection];


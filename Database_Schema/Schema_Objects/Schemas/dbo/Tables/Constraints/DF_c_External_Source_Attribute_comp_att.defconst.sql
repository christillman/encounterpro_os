ALTER TABLE [dbo].[c_External_Source_Attribute]
    ADD CONSTRAINT [DF_c_External_Source_Attribute_comp_att] DEFAULT ('N') FOR [component_attribute];


ALTER TABLE [dbo].[c_Report_Attribute]
    ADD CONSTRAINT [DF_c_Report_Attribute_component_attribute] DEFAULT ('N') FOR [component_attribute];


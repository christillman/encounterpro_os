ALTER TABLE [dbo].[c_XML_Code_Domain]
    ADD CONSTRAINT [DF_c_XML_Code_Domain_map_map_card] DEFAULT ('ManyToMany') FOR [map_cardinality];


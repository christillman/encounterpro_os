ALTER TABLE [dbo].[c_XML_Code_Domain_Item]
    ADD CONSTRAINT [DF_c_XML_Code_Domain_Item_id] DEFAULT (newid()) FOR [id];


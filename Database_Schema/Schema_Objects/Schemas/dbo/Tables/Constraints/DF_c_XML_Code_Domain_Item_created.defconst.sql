ALTER TABLE [dbo].[c_XML_Code_Domain_Item]
    ADD CONSTRAINT [DF_c_XML_Code_Domain_Item_created] DEFAULT (getdate()) FOR [created];


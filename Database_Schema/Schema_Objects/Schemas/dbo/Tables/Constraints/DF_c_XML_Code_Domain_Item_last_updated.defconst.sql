ALTER TABLE [dbo].[c_XML_Code_Domain_Item]
    ADD CONSTRAINT [DF_c_XML_Code_Domain_Item_last_updated] DEFAULT (getdate()) FOR [last_updated];


ALTER TABLE [dbo].[c_XML_Code_Domain]
    ADD CONSTRAINT [DF_c_XML_Code_Domain_last_updated] DEFAULT (getdate()) FOR [last_updated];


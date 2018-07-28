ALTER TABLE [dbo].[c_XML_Code_Domain]
    ADD CONSTRAINT [DF_c_XML_Code_Domain_created] DEFAULT (getdate()) FOR [created];


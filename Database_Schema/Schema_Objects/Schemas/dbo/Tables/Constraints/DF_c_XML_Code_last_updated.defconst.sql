ALTER TABLE [dbo].[c_XML_Code]
    ADD CONSTRAINT [DF_c_XML_Code_last_updated] DEFAULT (getdate()) FOR [last_updated];


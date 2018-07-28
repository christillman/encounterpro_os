ALTER TABLE [dbo].[c_XML_Code]
    ADD CONSTRAINT [DF_c_XML_Code_id] DEFAULT (newid()) FOR [id];


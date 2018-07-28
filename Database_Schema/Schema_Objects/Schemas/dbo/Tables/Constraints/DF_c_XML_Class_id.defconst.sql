ALTER TABLE [dbo].[c_XML_Class]
    ADD CONSTRAINT [DF_c_XML_Class_id] DEFAULT (newid()) FOR [id];


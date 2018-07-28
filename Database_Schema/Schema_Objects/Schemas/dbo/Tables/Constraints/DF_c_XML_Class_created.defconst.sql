ALTER TABLE [dbo].[c_XML_Class]
    ADD CONSTRAINT [DF_c_XML_Class_created] DEFAULT (getdate()) FOR [created];


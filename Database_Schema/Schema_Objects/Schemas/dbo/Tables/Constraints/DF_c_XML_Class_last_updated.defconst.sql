ALTER TABLE [dbo].[c_XML_Class]
    ADD CONSTRAINT [DF_c_XML_Class_last_updated] DEFAULT (getdate()) FOR [last_updated];


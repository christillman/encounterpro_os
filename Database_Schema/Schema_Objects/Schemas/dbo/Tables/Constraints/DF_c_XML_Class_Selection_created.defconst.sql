ALTER TABLE [dbo].[c_XML_Class_Selection]
    ADD CONSTRAINT [DF_c_XML_Class_Selection_created] DEFAULT (getdate()) FOR [created];


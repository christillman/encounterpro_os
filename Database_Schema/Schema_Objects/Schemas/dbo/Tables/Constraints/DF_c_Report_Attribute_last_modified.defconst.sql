ALTER TABLE [dbo].[c_Report_Attribute]
    ADD CONSTRAINT [DF_c_Report_Attribute_last_modified] DEFAULT (getdate()) FOR [last_modified];


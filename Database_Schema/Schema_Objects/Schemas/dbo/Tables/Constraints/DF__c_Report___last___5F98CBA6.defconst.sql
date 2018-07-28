ALTER TABLE [dbo].[c_Report_Definition]
    ADD CONSTRAINT [DF__c_Report___last___5F98CBA6] DEFAULT (getdate()) FOR [last_updated];


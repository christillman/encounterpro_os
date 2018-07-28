ALTER TABLE [dbo].[c_Document_Route]
    ADD CONSTRAINT [DF__c_Document_Route_last_updated_4] DEFAULT (getdate()) FOR [last_updated];


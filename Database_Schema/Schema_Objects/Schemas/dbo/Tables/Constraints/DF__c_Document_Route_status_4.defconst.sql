ALTER TABLE [dbo].[c_Document_Route]
    ADD CONSTRAINT [DF__c_Document_Route_status_4] DEFAULT ('OK') FOR [status];


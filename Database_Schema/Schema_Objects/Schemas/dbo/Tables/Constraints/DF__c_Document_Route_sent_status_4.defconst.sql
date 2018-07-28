ALTER TABLE [dbo].[c_Document_Route]
    ADD CONSTRAINT [DF__c_Document_Route_sent_status_4] DEFAULT ('Sent') FOR [sent_status];


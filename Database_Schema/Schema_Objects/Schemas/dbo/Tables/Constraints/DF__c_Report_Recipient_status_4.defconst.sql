ALTER TABLE [dbo].[c_Report_Recipient]
    ADD CONSTRAINT [DF__c_Report_Recipient_status_4] DEFAULT ('OK') FOR [status];


ALTER TABLE [dbo].[c_Report_Recipient]
    ADD CONSTRAINT [DF__c_Report_Recipient_last_updated_4] DEFAULT (getdate()) FOR [last_updated];


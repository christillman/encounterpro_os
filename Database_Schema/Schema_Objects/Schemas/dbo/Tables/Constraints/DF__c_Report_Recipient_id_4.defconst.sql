ALTER TABLE [dbo].[c_Report_Recipient]
    ADD CONSTRAINT [DF__c_Report_Recipient_id_4] DEFAULT (newid()) FOR [id];


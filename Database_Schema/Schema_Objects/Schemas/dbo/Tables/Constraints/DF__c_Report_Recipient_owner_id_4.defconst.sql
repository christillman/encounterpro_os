ALTER TABLE [dbo].[c_Report_Recipient]
    ADD CONSTRAINT [DF__c_Report_Recipient_owner_id_4] DEFAULT ([dbo].[fn_customer_id]()) FOR [owner_id];


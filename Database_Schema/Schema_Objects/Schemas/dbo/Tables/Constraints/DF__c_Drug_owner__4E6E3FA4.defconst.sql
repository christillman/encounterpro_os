ALTER TABLE [dbo].[c_Drug_Definition]
    ADD CONSTRAINT [DF__c_Drug_owner__4E6E3FA4] DEFAULT ([dbo].[fn_customer_id]()) FOR [owner_id];


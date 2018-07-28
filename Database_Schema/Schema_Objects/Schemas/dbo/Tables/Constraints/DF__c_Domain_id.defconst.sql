ALTER TABLE [dbo].[c_Domain]
    ADD CONSTRAINT [DF__c_Domain_id] DEFAULT (newid()) FOR [id];


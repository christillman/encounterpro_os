ALTER TABLE [dbo].[c_Domain_Master]
    ADD CONSTRAINT [DF__c_Domain_Master_id] DEFAULT (newid()) FOR [id];


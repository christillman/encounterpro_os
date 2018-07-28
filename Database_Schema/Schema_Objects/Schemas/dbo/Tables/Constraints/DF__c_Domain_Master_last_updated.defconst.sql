ALTER TABLE [dbo].[c_Domain_Master]
    ADD CONSTRAINT [DF__c_Domain_Master_last_updated] DEFAULT (getdate()) FOR [last_updated];


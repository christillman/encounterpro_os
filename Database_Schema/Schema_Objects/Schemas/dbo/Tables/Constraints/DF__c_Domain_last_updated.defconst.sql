ALTER TABLE [dbo].[c_Domain]
    ADD CONSTRAINT [DF__c_Domain_last_updated] DEFAULT (getdate()) FOR [last_updated];


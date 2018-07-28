ALTER TABLE [dbo].[c_Drug_Definition]
    ADD CONSTRAINT [DF__c_Drug__last___5BC83AC2] DEFAULT (getdate()) FOR [last_updated];


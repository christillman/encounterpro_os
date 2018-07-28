ALTER TABLE [dbo].[c_Location]
    ADD CONSTRAINT [DF__c_Location__id__0FA2421A] DEFAULT (newid()) FOR [id];


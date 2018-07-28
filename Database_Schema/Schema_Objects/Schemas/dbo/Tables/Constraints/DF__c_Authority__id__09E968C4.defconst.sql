ALTER TABLE [dbo].[c_Authority]
    ADD CONSTRAINT [DF__c_Authority__id__09E968C4] DEFAULT (newid()) FOR [id];


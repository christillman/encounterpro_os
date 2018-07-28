ALTER TABLE [dbo].[c_Assessment_Definition]
    ADD CONSTRAINT [DF__c_Assessment__id__24FEE861] DEFAULT (newid()) FOR [id];


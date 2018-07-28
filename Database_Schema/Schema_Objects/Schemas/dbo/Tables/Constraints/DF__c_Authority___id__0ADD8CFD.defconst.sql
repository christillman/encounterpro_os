ALTER TABLE [dbo].[c_Authority_Type]
    ADD CONSTRAINT [DF__c_Authority___id__0ADD8CFD] DEFAULT (newid()) FOR [id];


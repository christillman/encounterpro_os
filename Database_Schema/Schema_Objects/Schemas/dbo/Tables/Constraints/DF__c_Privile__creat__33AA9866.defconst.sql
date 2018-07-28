ALTER TABLE [dbo].[c_Privilege]
    ADD CONSTRAINT [DF__c_Privile__creat__33AA9866] DEFAULT (getdate()) FOR [created];


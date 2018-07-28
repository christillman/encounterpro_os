ALTER TABLE [dbo].[c_Specialty]
    ADD CONSTRAINT [DF__c_Specialty__id__192BAC54] DEFAULT (newid()) FOR [id];


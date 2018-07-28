ALTER TABLE [dbo].[c_Observation_Result]
    ADD CONSTRAINT [DF__c_Observatio__id__01892CED] DEFAULT (newid()) FOR [id];


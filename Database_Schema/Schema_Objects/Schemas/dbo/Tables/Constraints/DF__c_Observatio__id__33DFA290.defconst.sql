ALTER TABLE [dbo].[c_Observation]
    ADD CONSTRAINT [DF__c_Observatio__id__33DFA290] DEFAULT (newid()) FOR [id];


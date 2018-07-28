ALTER TABLE [dbo].[c_Observation]
    ADD CONSTRAINT [DF__c_Observa__last___32EB7E57] DEFAULT (getdate()) FOR [last_updated];


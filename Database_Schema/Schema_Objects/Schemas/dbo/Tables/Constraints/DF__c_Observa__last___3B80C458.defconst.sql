ALTER TABLE [dbo].[c_Observation_Result]
    ADD CONSTRAINT [DF__c_Observa__last___3B80C458] DEFAULT (getdate()) FOR [last_updated];


ALTER TABLE [dbo].[c_Observation_Stage]
    ADD CONSTRAINT [DF__c_Observa_Stage_last_up_40] DEFAULT (getdate()) FOR [last_updated];


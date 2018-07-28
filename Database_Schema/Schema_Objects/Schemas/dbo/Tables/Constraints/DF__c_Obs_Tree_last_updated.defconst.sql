ALTER TABLE [dbo].[c_Observation_Tree]
    ADD CONSTRAINT [DF__c_Obs_Tree_last_updated] DEFAULT (getdate()) FOR [last_updated];


ALTER TABLE [dbo].[c_Observation_Tree]
    ADD CONSTRAINT [DF__c_Obs_Tree_on_results_entered] DEFAULT ('Next') FOR [on_results_entered];


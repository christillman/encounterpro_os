ALTER TABLE [dbo].[c_Component_Param]
    ADD CONSTRAINT [DF__c_Component_Param_param_id_5] DEFAULT (newid()) FOR [param_id];


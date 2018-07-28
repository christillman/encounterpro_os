ALTER TABLE [dbo].[c_Component_Param]
    ADD CONSTRAINT [DF__c_Component_Param_last_updated_5] DEFAULT (getdate()) FOR [last_updated];


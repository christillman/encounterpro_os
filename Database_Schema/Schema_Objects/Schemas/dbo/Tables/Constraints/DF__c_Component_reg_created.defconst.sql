ALTER TABLE [dbo].[c_Component_Registry]
    ADD CONSTRAINT [DF__c_Component_reg_created] DEFAULT (getdate()) FOR [created];


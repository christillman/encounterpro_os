ALTER TABLE [dbo].[c_Component_Registry]
    ADD CONSTRAINT [DF__c_Component_reg_lic_status] DEFAULT ('Unlicensed') FOR [license_status];


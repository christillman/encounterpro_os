ALTER TABLE [dbo].[c_Component_Definition]
    ADD CONSTRAINT [DF__c_Component_def_status] DEFAULT ('OK') FOR [status];


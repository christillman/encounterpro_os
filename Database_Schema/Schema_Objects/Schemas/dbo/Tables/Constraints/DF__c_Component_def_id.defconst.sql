ALTER TABLE [dbo].[c_Component_Definition]
    ADD CONSTRAINT [DF__c_Component_def_id] DEFAULT (newid()) FOR [id];


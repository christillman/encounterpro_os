ALTER TABLE [dbo].[c_Administration_Frequency]
    ADD CONSTRAINT [DF__c_Administra_status_40] DEFAULT ('OK') FOR [status];


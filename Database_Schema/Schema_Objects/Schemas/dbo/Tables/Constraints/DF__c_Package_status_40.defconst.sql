ALTER TABLE [dbo].[c_Package]
    ADD CONSTRAINT [DF__c_Package_status_40] DEFAULT ('OK') FOR [status];


ALTER TABLE [dbo].[c_Package]
    ADD CONSTRAINT [DF__c_Package__id__127EAEC5] DEFAULT (newid()) FOR [id];


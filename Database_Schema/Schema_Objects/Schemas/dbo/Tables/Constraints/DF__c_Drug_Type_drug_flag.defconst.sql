ALTER TABLE [dbo].[c_Drug_Type]
    ADD CONSTRAINT [DF__c_Drug_Type_drug_flag] DEFAULT ('Y') FOR [drug_flag];


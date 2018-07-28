ALTER TABLE [dbo].[c_Equivalence]
    ADD CONSTRAINT [DF__c_Equiv_creat_33] DEFAULT (getdate()) FOR [created];


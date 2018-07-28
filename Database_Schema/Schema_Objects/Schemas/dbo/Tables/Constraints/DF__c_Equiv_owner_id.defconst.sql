ALTER TABLE [dbo].[c_Equivalence]
    ADD CONSTRAINT [DF__c_Equiv_owner_id] DEFAULT ((-1)) FOR [owner_id];


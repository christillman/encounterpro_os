ALTER TABLE [dbo].[c_Equivalence]
    ADD CONSTRAINT [DF__c_Equiv_id_33] DEFAULT (newid()) FOR [id];


ALTER TABLE [dbo].[c_Equivalence_Group]
    ADD CONSTRAINT [DF__c_Equiv_grp_creat_33] DEFAULT (getdate()) FOR [created];


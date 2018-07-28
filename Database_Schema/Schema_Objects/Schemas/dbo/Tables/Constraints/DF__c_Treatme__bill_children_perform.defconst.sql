ALTER TABLE [dbo].[c_Treatment_Type]
    ADD CONSTRAINT [DF__c_Treatme__bill_children_perform] DEFAULT ((0)) FOR [bill_children_perform];


ALTER TABLE [dbo].[c_Treatment_Type]
    ADD CONSTRAINT [DF__c_Treatme__bill_procedure] DEFAULT ((1)) FOR [bill_procedure];


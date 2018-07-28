ALTER TABLE [dbo].[c_Maintenance_Procedure]
    ADD CONSTRAINT [DF__c_Maintenance_Proc_treatment_type_] DEFAULT ('PROCEDURE') FOR [treatment_type];


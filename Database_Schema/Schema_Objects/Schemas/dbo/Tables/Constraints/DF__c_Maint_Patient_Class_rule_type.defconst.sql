ALTER TABLE [dbo].[c_Maintenance_Patient_Class]
    ADD CONSTRAINT [DF__c_Maint_Patient_Class_rule_type] DEFAULT ('Rule') FOR [maintenance_rule_type];


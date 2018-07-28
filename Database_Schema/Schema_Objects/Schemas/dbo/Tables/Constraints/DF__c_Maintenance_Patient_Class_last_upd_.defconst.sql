ALTER TABLE [dbo].[c_Maintenance_Patient_Class]
    ADD CONSTRAINT [DF__c_Maintenance_Patient_Class_last_upd_] DEFAULT (getdate()) FOR [last_updated];


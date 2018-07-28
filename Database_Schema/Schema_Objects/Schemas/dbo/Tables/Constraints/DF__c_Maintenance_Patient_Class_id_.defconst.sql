ALTER TABLE [dbo].[c_Maintenance_Patient_Class]
    ADD CONSTRAINT [DF__c_Maintenance_Patient_Class_id_] DEFAULT (newid()) FOR [id];


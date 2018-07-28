ALTER TABLE [dbo].[c_Maintenance_Patient_Class]
    ADD CONSTRAINT [DF__c_Maintenance_Patient_Class_status_] DEFAULT ('OK') FOR [status];


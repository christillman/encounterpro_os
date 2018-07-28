ALTER TABLE [dbo].[c_Maintenance_Patient_Class]
    ADD CONSTRAINT [DF__c_Maintenance_Patient_Class_owner_id_] DEFAULT ([dbo].[fn_customer_id]()) FOR [owner_id];


ALTER TABLE [dbo].[c_Patient_material]
    ADD CONSTRAINT [DF__c_Patmat_last_update_40] DEFAULT (getdate()) FOR [last_updated];


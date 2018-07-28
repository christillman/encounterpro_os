ALTER TABLE [dbo].[c_Patient_material]
    ADD CONSTRAINT [DF__c_Patmat_owner_id_40] DEFAULT ((-1)) FOR [owner_id];


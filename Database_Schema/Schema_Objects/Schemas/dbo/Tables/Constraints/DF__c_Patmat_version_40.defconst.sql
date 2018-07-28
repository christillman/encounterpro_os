ALTER TABLE [dbo].[c_Patient_material]
    ADD CONSTRAINT [DF__c_Patmat_version_40] DEFAULT ((1)) FOR [version];


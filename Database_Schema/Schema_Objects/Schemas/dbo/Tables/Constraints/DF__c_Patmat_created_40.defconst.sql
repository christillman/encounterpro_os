ALTER TABLE [dbo].[c_Patient_material]
    ADD CONSTRAINT [DF__c_Patmat_created_40] DEFAULT (getdate()) FOR [created];


ALTER TABLE [dbo].[c_Encounter_Type]
    ADD CONSTRAINT [DF__c_Encounter_type_version] DEFAULT ((1)) FOR [version];


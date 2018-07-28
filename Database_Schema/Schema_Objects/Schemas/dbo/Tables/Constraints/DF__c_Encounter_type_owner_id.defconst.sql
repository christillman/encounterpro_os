ALTER TABLE [dbo].[c_Encounter_Type]
    ADD CONSTRAINT [DF__c_Encounter_type_owner_id] DEFAULT ((-1)) FOR [owner_id];


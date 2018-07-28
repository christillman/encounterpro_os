ALTER TABLE [dbo].[c_Encounter_Type]
    ADD CONSTRAINT [DF__c_Encounter_type_created] DEFAULT (getdate()) FOR [created];


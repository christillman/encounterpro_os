ALTER TABLE [dbo].[c_Encounter_Type]
    ADD CONSTRAINT [DF__c_Encounter_type_coding_mode] DEFAULT ('Standard') FOR [coding_mode];


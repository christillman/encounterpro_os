ALTER TABLE [dbo].[p_Patient_Encounter]
    ADD CONSTRAINT [DF__p_encounter_default_grant] DEFAULT ((1)) FOR [default_grant];


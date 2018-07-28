ALTER TABLE [dbo].[p_Patient_Encounter]
    ADD CONSTRAINT [DF_p_encounter_stone_21] DEFAULT ('') FOR [stone_flag];


ALTER TABLE [dbo].[p_Encounter_Assessment]
    ADD CONSTRAINT [DF_p_Encounter_assm_exclusive_link] DEFAULT ('N') FOR [exclusive_link];


ALTER TABLE [dbo].[p_Encounter_Assessment]
    ADD CONSTRAINT [DF__p_Encounter___id__23A93AC7] DEFAULT (newid()) FOR [id];


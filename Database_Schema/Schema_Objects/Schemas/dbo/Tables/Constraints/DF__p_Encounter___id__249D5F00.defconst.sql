ALTER TABLE [dbo].[p_Encounter_Assessment_Charge]
    ADD CONSTRAINT [DF__p_Encounter___id__249D5F00] DEFAULT (newid()) FOR [id];


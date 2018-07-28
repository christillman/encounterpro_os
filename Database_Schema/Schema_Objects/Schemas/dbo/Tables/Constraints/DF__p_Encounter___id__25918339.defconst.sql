ALTER TABLE [dbo].[p_Encounter_Charge]
    ADD CONSTRAINT [DF__p_Encounter___id__25918339] DEFAULT (newid()) FOR [id];


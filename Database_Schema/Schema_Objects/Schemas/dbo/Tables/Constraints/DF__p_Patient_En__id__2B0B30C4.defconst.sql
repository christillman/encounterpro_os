ALTER TABLE [dbo].[p_Patient_Encounter_Progress]
    ADD CONSTRAINT [DF__p_Patient_En__id__2B0B30C4] DEFAULT (newid()) FOR [id];


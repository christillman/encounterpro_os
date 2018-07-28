ALTER TABLE [dbo].[p_Patient_Encounter]
    ADD CONSTRAINT [DF_p_encounter_created_21] DEFAULT (getdate()) FOR [created];


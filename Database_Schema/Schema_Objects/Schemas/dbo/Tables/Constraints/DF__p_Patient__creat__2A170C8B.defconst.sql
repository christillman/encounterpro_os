ALTER TABLE [dbo].[p_Patient_Encounter_Progress]
    ADD CONSTRAINT [DF__p_Patient__creat__2A170C8B] DEFAULT (getdate()) FOR [created];


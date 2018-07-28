ALTER TABLE [dbo].[p_Patient_Encounter_Progress]
    ADD CONSTRAINT [DF__p_Patient__progr__2922E852] DEFAULT (getdate()) FOR [progress_date_time];


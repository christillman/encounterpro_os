ALTER TABLE [dbo].[p_Patient_Encounter_Progress]
    ADD CONSTRAINT [PK_p_Patient_Encounter_Progress] PRIMARY KEY CLUSTERED ([cpr_id] ASC, [encounter_id] ASC, [encounter_progress_sequence] ASC) WITH (FILLFACTOR = 70, ALLOW_PAGE_LOCKS = ON, ALLOW_ROW_LOCKS = ON, PAD_INDEX = OFF, IGNORE_DUP_KEY = OFF, STATISTICS_NORECOMPUTE = OFF);


ALTER TABLE [dbo].[p_Patient_Encounter_Progress]
    ADD CONSTRAINT [DF__p_Patient_enc_prg_curflg] DEFAULT ('Y') FOR [current_flag];


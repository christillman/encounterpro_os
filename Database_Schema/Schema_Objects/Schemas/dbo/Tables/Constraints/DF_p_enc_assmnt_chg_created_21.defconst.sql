ALTER TABLE [dbo].[p_Encounter_Assessment_Charge]
    ADD CONSTRAINT [DF_p_enc_assmnt_chg_created_21] DEFAULT (getdate()) FOR [created];


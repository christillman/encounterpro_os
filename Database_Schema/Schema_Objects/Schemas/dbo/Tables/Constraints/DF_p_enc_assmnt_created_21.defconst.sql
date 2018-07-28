ALTER TABLE [dbo].[p_Encounter_Assessment]
    ADD CONSTRAINT [DF_p_enc_assmnt_created_21] DEFAULT (getdate()) FOR [created];


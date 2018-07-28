ALTER TABLE [dbo].[p_Encounter_Assessment]
    ADD CONSTRAINT [DF_p_Enc_assmnt_bill_flag_21] DEFAULT ('Y') FOR [bill_flag];


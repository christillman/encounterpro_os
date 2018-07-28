ALTER TABLE [dbo].[p_Encounter_Assessment_Charge]
    ADD CONSTRAINT [DF_p_Enc_A_T_bill_flag_1] DEFAULT ('Y') FOR [bill_flag];


ALTER TABLE [dbo].[p_Encounter_Charge]
    ADD CONSTRAINT [DF_p_Enc_charge_bill_flag_21] DEFAULT ('Y') FOR [bill_flag];


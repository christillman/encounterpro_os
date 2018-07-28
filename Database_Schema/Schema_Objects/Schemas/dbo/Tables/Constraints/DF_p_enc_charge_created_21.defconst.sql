ALTER TABLE [dbo].[p_Encounter_Charge]
    ADD CONSTRAINT [DF_p_enc_charge_created_21] DEFAULT (getdate()) FOR [created];


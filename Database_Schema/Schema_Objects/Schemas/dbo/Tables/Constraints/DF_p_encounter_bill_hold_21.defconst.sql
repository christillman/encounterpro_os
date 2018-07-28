ALTER TABLE [dbo].[p_Patient_Encounter]
    ADD CONSTRAINT [DF_p_encounter_bill_hold_21] DEFAULT ('') FOR [billing_hold_flag];


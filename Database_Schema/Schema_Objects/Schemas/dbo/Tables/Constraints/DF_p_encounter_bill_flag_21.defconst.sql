ALTER TABLE [dbo].[p_Patient_Encounter]
    ADD CONSTRAINT [DF_p_encounter_bill_flag_21] DEFAULT ('Y') FOR [bill_flag];


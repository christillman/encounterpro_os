ALTER TABLE [dbo].[p_Patient_Encounter]
    ADD CONSTRAINT [DF_p_encounter_bill_post_21] DEFAULT ('') FOR [billing_posted];


ALTER TABLE [dbo].[p_Patient_Authority]
    ADD CONSTRAINT [DF__p_Patient__insur__515BC235] DEFAULT ('') FOR [insureds_ssn];


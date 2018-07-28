ALTER TABLE [dbo].[p_Patient]
    ADD CONSTRAINT [DF__p_patient_default_grant] DEFAULT ((1)) FOR [default_grant];


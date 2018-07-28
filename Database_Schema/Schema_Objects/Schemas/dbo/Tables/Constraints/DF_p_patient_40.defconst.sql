ALTER TABLE [dbo].[p_Patient]
    ADD CONSTRAINT [DF_p_patient_40] DEFAULT (getdate()) FOR [created];


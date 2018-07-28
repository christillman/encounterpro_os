ALTER TABLE [dbo].[p_Treatment_Item]
    ADD CONSTRAINT [DF__p_treatment_default_grant] DEFAULT ((1)) FOR [default_grant];


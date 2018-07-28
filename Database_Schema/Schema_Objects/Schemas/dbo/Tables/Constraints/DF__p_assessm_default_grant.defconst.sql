ALTER TABLE [dbo].[p_Assessment]
    ADD CONSTRAINT [DF__p_assessm_default_grant] DEFAULT ((1)) FOR [default_grant];


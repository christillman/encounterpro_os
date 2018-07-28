ALTER TABLE [dbo].[p_Patient_Authority]
    ADD CONSTRAINT [DF_p_pat_auth_cre] DEFAULT (getdate()) FOR [created];


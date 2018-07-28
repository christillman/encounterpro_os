ALTER TABLE [dbo].[p_Patient_Authority]
    ADD CONSTRAINT [DF__p_Patient__insur__4F7379C3] DEFAULT ('') FOR [insureds_first_name];


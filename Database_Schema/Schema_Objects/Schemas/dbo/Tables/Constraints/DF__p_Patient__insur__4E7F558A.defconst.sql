ALTER TABLE [dbo].[p_Patient_Authority]
    ADD CONSTRAINT [DF__p_Patient__insur__4E7F558A] DEFAULT ('') FOR [insureds_last_name];


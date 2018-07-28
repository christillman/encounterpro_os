ALTER TABLE [dbo].[p_Family_Illness]
    ADD CONSTRAINT [DF_p_fam_ill_21] DEFAULT (getdate()) FOR [created];


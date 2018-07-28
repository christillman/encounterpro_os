ALTER TABLE [dbo].[p_Family_History]
    ADD CONSTRAINT [DF_p_fam_hist_21] DEFAULT (getdate()) FOR [created];


ALTER TABLE [dbo].[c_User_Progress]
    ADD CONSTRAINT [DF_c_User_prog_cre_40] DEFAULT (getdate()) FOR [created];


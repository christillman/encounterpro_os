ALTER TABLE [dbo].[c_User_Progress]
    ADD CONSTRAINT [DF_c_User_prog_current_flag_50] DEFAULT ('Y') FOR [current_flag];


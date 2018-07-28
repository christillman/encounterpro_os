ALTER TABLE [dbo].[c_User_Progress]
    ADD CONSTRAINT [DF_c_User_prog_id_40] DEFAULT (newid()) FOR [id];


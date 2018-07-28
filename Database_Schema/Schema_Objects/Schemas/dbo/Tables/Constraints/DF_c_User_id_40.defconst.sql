ALTER TABLE [dbo].[c_User]
    ADD CONSTRAINT [DF_c_User_id_40] DEFAULT (newid()) FOR [id];


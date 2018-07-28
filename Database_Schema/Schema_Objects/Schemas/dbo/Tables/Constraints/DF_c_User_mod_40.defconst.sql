ALTER TABLE [dbo].[c_User]
    ADD CONSTRAINT [DF_c_User_mod_40] DEFAULT (getdate()) FOR [modified];


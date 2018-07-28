ALTER TABLE [dbo].[c_User]
    ADD CONSTRAINT [DF_c_User_cre_40] DEFAULT (getdate()) FOR [created];


ALTER TABLE [dbo].[c_User]
    ADD CONSTRAINT [DF_c_User_status_40] DEFAULT ('OK') FOR [status];


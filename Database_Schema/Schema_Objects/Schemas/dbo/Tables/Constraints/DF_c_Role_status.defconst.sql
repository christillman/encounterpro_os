ALTER TABLE [dbo].[c_Role]
    ADD CONSTRAINT [DF_c_Role_status] DEFAULT ('OK') FOR [status];


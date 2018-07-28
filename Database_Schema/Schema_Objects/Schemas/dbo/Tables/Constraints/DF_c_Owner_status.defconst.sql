ALTER TABLE [dbo].[c_Owner]
    ADD CONSTRAINT [DF_c_Owner_status] DEFAULT ('OK') FOR [status];


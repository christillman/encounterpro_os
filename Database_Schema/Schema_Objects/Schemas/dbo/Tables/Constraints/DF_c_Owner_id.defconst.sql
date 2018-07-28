ALTER TABLE [dbo].[c_Owner]
    ADD CONSTRAINT [DF_c_Owner_id] DEFAULT (newid()) FOR [id];


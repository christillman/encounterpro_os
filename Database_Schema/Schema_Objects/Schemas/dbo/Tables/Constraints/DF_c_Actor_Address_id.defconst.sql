ALTER TABLE [dbo].[c_Actor_Address]
    ADD CONSTRAINT [DF_c_Actor_Address_id] DEFAULT (newid()) FOR [id];


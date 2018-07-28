ALTER TABLE [dbo].[c_Drug_Administration]
    ADD CONSTRAINT [DF_c_Drug_Administration_id] DEFAULT (newid()) FOR [id];


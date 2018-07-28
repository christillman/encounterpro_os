ALTER TABLE [dbo].[c_Disease]
    ADD CONSTRAINT [DF_c_Disease_id] DEFAULT (newid()) FOR [id];


ALTER TABLE [dbo].[c_Actor_Communication]
    ADD CONSTRAINT [DF_c_Actor_Communication_id] DEFAULT (newid()) FOR [id];


ALTER TABLE [dbo].[c_Actor_Class_Purpose]
    ADD CONSTRAINT [DF__id] DEFAULT (newid()) FOR [id];


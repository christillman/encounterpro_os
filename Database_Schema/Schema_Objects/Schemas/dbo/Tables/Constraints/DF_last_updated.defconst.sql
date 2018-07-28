ALTER TABLE [dbo].[c_Actor_Class_Purpose]
    ADD CONSTRAINT [DF_last_updated] DEFAULT (getdate()) FOR [last_updated];


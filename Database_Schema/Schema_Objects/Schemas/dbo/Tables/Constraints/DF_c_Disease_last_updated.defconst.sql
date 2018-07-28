ALTER TABLE [dbo].[c_Disease]
    ADD CONSTRAINT [DF_c_Disease_last_updated] DEFAULT (getdate()) FOR [last_updated];

